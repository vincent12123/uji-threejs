# uji-threejs

Halaman uji three.js (r186, dimuat dari jsDelivr): pemuat FBX, glTF, LDraw, dan three-gpu-pathtracer.
Situs statis — cukup disajikan dengan server web apa pun, mis. `python -m http.server`.

| Halaman | Isi |
|---|---|
| `uji_fbx_angry.html` | FBXLoader + animasi |
| `uji_kepala_facecap.html` | Kepala Face Cap (glTF, KTX2 + Meshopt) di badan minifig LDraw |
| `webgl_renderer_pathtracer_luke.html` | Pathtracer minifig Luke Skywalker |
| `uji_ubah_fbx.html` | Konversi FBX → GLB (hasil dikirim ke penerima lokal `127.0.0.1:8090`) |

## Deploy

Situs: https://threejs.sukardi.cloud (shared hosting Hostinger). Commit dulu, lalu jalankan `bash deploy.sh`.
Skrip itu juga membuat salinan `.gz` untuk model; `.htaccess` menyajikannya ke browser yang menerima gzip
(server tidak mengompres berkas besar sendiri). Angry.fbx tetap ±50 MB karena teksturnya sudah terkompres.

## Sumber aset

- `models/fbx/` — karakter & animasi dari Mixamo (Adobe).
- `models/gltf/uji-quaternius/` — karakter Quaternius (CC0).
- `models/gltf/facecap.glb`, `textures/equirectangular/royal_esplanade_2k.hdr.jpg`, `main.css` — dari contoh repo three.js.
- `models/ldraw/` — LDraw Parts Library (CC BY 2.0), https://www.ldraw.org.
