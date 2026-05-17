# Dokumentasi Exercise 5: Remote File Transfer

## 1. Bukti Koneksi SSH Sukses
Koneksi remote menggunakan SSH berhasil dijalankan dari terminal laptop menuju server Linuxbox dengan memanfaatkan fitur Port Forwarding pada port 2222:
ssh dindalasegar@127.0.0.1 -p 2222

## 2. Proses Transfer File via Rsync
Proses pengiriman folder exercise pertama berhasil disimulasikan menggunakan perintah rsync:
rsync -avz --progress ./exercise-1-csv/ ./exercise-1-backup/

## 3. Verifikasi Integritas File (SHA256 Checksum)
Hasil pemeriksaan nilai hash terbukti identik dan tidak mengalami kerusakan data:
* Hash File Asli   : a806ef2dbfd6187ecffb8670b909d35960637e30e966d52eec028ae16dde97f5
* Hash File Backup : a806ef2dbfd6187ecffb8670b909d35960637e30e966d52eec028ae16dde97f5

## 4. Analisis Perbandingan SCP vs Rsync

### SCP (Secure Copy)
* Kelebihan: Sangat praktis untuk menyalin satu file tunggal secara cepat tanpa konfigurasi tambahan.
* Kekurangan: Kurang efisien untuk folder besar karena akan menyalin ulang seluruh isi data dari awal meskipun tidak ada perubahan.

### Rsync (Remote Synchronization)
* Kelebihan: Jauh lebih cepat karena hanya mengirim bagian file yang mengalami perubahan (delta sync), mempertahankan hak akses file asli, dan memiliki informasi progress bar yang jelas.
* Kekurangan: Struktur perintahnya sedikit lebih rumit dibandingkan dengan perintah salin biasa.
