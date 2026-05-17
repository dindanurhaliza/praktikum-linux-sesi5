
# Dokumentasi Tugas Persiapan

## 1. Bukti Koneksi SSH Sukses
Berikut adalah bukti tangkapan layar koneksi remote SSH yang berhasil dijalankan melalui terminal Git Bash:
![Bukti SSH Sukses](tugas persiapan.png)

## 2. Proses Transfer File via Rsync
Proses pengiriman folder exercise pertama berhasil disimulasikan menggunakan perintah rsync:
dindalasegar@dindalasegar:~/praktikum-linux-sesi5$ rsync -avz --progress ./exercise-1-csv/ ./exercise-1-backup/
sending incremental file list
created directory ./exercise-1-backup
./
data.csv
         74,958 100%   40.24MB/s    0:00:00 (xfr#1, to-chk=6/8)
prompt.txt
            815 100%  397.95kB/s    0:00:00 (xfr#2, to-chk=5/8)
solution.sh
          1,004 100%  490.23kB/s    0:00:00 (xfr#3, to-chk=4/8)
output/
output/data_clean.csv
         70,409 100%   22.38MB/s    0:00:00 (xfr#4, to-chk=2/8)
output/data_normalized_date.csv
         76,958 100%   14.68MB/s    0:00:00 (xfr#5, to-chk=1/8)
output/gmail-customers.csv
         40,454 100%    6.43MB/s    0:00:00 (xfr#6, to-chk=0/8)

sent 38,706 bytes  received 187 bytes  77,786.00 bytes/sec
total size is 264,598  speedup is 6.80

## 3. Verifikasi Integritas File (SHA256 Checksum)
Hasil pemeriksaan nilai hash terbukti identik dan tidak mengalami kerusakan data:
* dindalasegar@dindalasegar:~/praktikum-linux-sesi5$ sha256sum ./exercise-1-csv/data.csv
a806ef2dbfd6187ecffb8670b909d35960637e30e966d52eec028ae16dde97f5  ./exercise-1-csv/data.csv
* dindalasegar@dindalasegar:~/praktikum-linux-sesi5$ sha256sum ./exercise-1-backup/data.csv
a806ef2dbfd6187ecffb8670b909d35960637e30e966d52eec028ae16dde97f5  ./exercise-1-backup/data.csv


## 4. Analisis Perbandingan SCP vs Rsync

### SCP (Secure Copy)
* Kelebihan: Sangat praktis untuk menyalin satu file tunggal secara cepat tanpa konfigurasi tambahan.
* Kekurangan: Kurang efisien untuk folder besar karena akan menyalin ulang seluruh isi data dari awal meskipun tidak ada perubahan.

### Rsync (Remote Synchronization)
* Kelebihan: Jauh lebih cepat karena hanya mengirim bagian file yang mengalami perubahan (delta sync), mempertahankan hak akses file asli, dan memiliki informasi progress bar yang jelas.
* Kekurangan: Struktur perintahnya sedikit lebih rumit dibandingkan dengan perintah salin biasa.
=======
# Refleksi Praktikum

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
