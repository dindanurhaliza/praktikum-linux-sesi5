#!/bin/bash

INPUT="produk-lama.csv"
OUTPUT="produk-clean.csv"

echo "=== Memulai Proses Data Cleansing ==="

# 1. Ambil header asli
head -n 1 "$INPUT" > "$OUTPUT"

# 2. Proses baris data dengan menggunakan pemisah koma (,)
tail -n +2 "$INPUT" | while IFS=',' read -r kode nama kat harga stok lu || [[ -n "$kode" ]]; do
    [[ -z "$kode" ]] && continue

    # Normalisasi Nama Produk (Title Case + Hapus Spasi Ganda)
    nama_clean=$(echo "$nama" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
    nama_clean=$(echo "$nama_clean" | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//')

    # Normalisasi Kategori
    kat_lower=$(echo "$kat" | tr '[:upper:]' '[:lower:]')
    if [[ "$kat_lower" == "clothes" || "$kat_lower" == "pakaian" || "$kat_lower" == "pakian" ]]; then
        kat_clean="pakaian"
    else
        kat_clean="$kat_lower"
    fi

    # Normalisasi Waktu Last Updated ke ISO 8601
    if [[ "$lu" =~ ^[0-9]+$ ]]; then
        lu_clean=$(date -d @"$lu" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -r "$lu" +"%Y-%m-%dT%H:%M:%SZ")
    else
        lu_clean="$lu"
    fi

    # Tulis hasil sementara dengan pemisah koma
    echo "$kode,$nama_clean,$kat_clean,$harga,$stok,$lu_clean" >> temp_clean.csv
done

# 3. Deduplikasi data berdasarkan kode_produk
sort -t',' -k1,1 -k6,6r temp_clean.csv | awk -F',' '!seen[$1]++' >> "$OUTPUT"
rm -f temp_clean.csv

echo "✔ Data berhasil dibersihkan dan disimpan di produk-clean.csv"
echo ""

# 4. Menampilkan Validation Report Ringkas
echo "=== VALIDATION REPORT ==="
echo -n "Total baris input  : "
wc -l < "$INPUT"
echo -n "Total setelah dedup: "
wc -l < "$OUTPUT"
echo "Distribusi Kategori:"
tail -n +2 "$OUTPUT" | cut -d',' -f3 | sort | uniq -c
echo "Statistik Harga:"
tail -n +2 "$OUTPUT" | cut -d',' -f4 | awk 'BEGIN {min=99999999; max=0} {sum+=$1; count++; if($1<min) min=$1; if($1>max) max=$1} END {if (count>0) printf "  Min: Rp %d\n  Max: Rp %d\n  Avg: Rp %.2f\n", min, max, sum/count}'
