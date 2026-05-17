<<<<<<< HEAD
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
=======
# praktikum-linux-sesi5
>>>>>>> 3320ba52af61cf9c4b8969651cdffd680bf5f7c1

## 5. Refleksi Praktikum

### 1. Kesulitan Terbesar dan Solusinya
Kesulitan terbesar terjadi pada saat proses konfigurasi koneksi awal SSH dari Git Bash menuju Linuxbox karena masalah IP internal NAT bawaan VirtualBox yang tidak dapat dijangkau secara langsung oleh host OS. Masalah ini berhasil dipecahkan dengan menerapkan teknik Port Forwarding pada port khusus 2222 melalui menu pengaturan jaringan VirtualBox, sehingga lalu lintas data lokal dari laptop bisa diteruskan dengan tepat ke dalam port 22 SSH milik mesin virtual Ubuntu.

### 2. Command dan Teknik Baru yang Dipelajari
* Perintah pemindahan data secara efisien melalui rsync beserta parameter pengecekan status (`rsync -avz --progress`).
* Pemeriksaan integritas data otentik menggunakan fungsi hashing kriptografi SHA-256 (`sha256sum`).
* Konfigurasi identitas repositori serta penanganan konflik sinkronisasi riwayat komit pada Git (`--allow-unrelated-histories` dan `--force push`).

### 3. Implementasi Skenario Nyata di Dunia Kerja IT
Kombinasi keahlian remote access dan sinkronisasi data ini sangat krusial dalam peran DevOps Engineer maupun System Administrator untuk melakukan pemeliharaan server jarak jauh, otomatisasi proses backup data cadangan antar pusat data (data center) secara berkala, serta melakukan deployment kode aplikasi web dari komputer lokal langsung ke lingkungan server produksi (production server) secara aman.

### 4. Estimasi Total Waktu Pengerjaan
* Exercise 1 (Manajemen File CSV): 45 Menit
* Exercise 2 (Analisis Log Nginx): 30 Menit
* Exercise 3 (Pengolahan Data JSON): 40 Menit
* Exercise 4 (Migrasi Basis Data SQL): 35 Menit
* Exercise Bonus (Skrip Otomatisasi): 50 Menit
* Remote Transfer & Dokumentasi: 40 Menit
