#!/usr/bin/env bash
# Deploy commit HEAD ke threejs.sukardi.cloud (shared hosting Hostinger).
# Arsip → scp → cek sha256 → ekstrak ke public_html.baru → buat salinan .gz → tukar folder.
set -euo pipefail

SSH_HOST=u715621294@88.223.90.200
SSH_PORT=65002
SITUS='~/domains/threejs.sukardi.cloud'

cd "$(dirname "$0")"
arsip=$(mktemp -t uji-threejs-XXXX.tgz)
git archive --format=tar.gz -o "$arsip" HEAD
hash=$(sha256sum "$arsip" | cut -d' ' -f1)
scp -q -P "$SSH_PORT" "$arsip" "$SSH_HOST:~/uji-threejs.tgz"
rm "$arsip"

ssh -p "$SSH_PORT" "$SSH_HOST" bash -s <<EOF
set -euo pipefail
cd $SITUS
[ "\$(sha256sum ~/uji-threejs.tgz | cut -d' ' -f1)" = "$hash" ] || { echo "sha256 tidak cocok"; exit 1; }
rm -rf public_html.baru && mkdir public_html.baru
tar -xzf ~/uji-threejs.tgz -C public_html.baru
rm ~/uji-threejs.tgz

# Salinan .gz untuk model yang menyusut >10% (dipakai .htaccess)
find public_html.baru/models -type f \( -name '*.fbx' -o -name '*.gltf' -o -name '*.mpd' \) | while read -r f; do
	gzip -9 -k -f "\$f"
	[ \$(( \$(stat -c%s "\$f.gz") * 10 )) -lt \$(( \$(stat -c%s "\$f") * 9 )) ] || rm "\$f.gz"
done

mv public_html "public_html.lama-\$(date +%Y%m%d%H%M%S)"
mv public_html.baru public_html
ls -d public_html.lama-* | head -n -2 | xargs -r rm -rf   # simpan 2 cadangan terakhir
echo "deploy selesai: \$(find public_html/models -name '*.gz' | wc -l) salinan .gz"
EOF
