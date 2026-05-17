#!/bin/bash

echo "=== SOAL 1: Jumlah Customer per Status ==="
awk -F, 'NR>1 {print tolower($6)}' data.csv | sed 's/aktif/active/g; s/activee/active/g; s/inaktif/inactive/g' | sort | uniq -c
echo ""

echo "=== SOAL 2: Konversi Tanggal ke ISO 8601 ==="
# Mengubah format dd/mm/yyyy dan dd-mm-yy menjadi yyyy-mm-dd
sed -E 's|([0-9]{2})/([0-9]{2})/([0-9]{4})|\3-\2-\1|g; s|([0-9]{2})-([0-9]{2})-([0-9]{2})|20\3-\2-\1|g' data.csv > output/data_normalized_date.csv
head -n 5 output/data_normalized_date.csv
echo ""

echo "=== SOAL 3: Ekstrak Customer Gmail ==="
grep '@gmail.com' data.csv > output/gmail-customers.csv
echo "Berhasil mengekstrak, jumlah baris:"
wc -l output/gmail-customers.csv
echo ""

echo "=== SOAL 4: Hapus Duplikat Email ==="
awk -F, '!seen[$3]++' data.csv > output/data_clean.csv
echo "Jumlah data setelah duplikat dihapus:"
wc -l output/data_clean.csv
echo ""

echo "=== SOAL 5: Hitung Nama Tidak Title-Case ==="
awk -F, 'NR>1 {print $2}' data.csv | grep -E '[a-z][A-Z]|^[a-z]' | wc -l
