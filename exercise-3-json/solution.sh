#!/bin/bash

# Pastikan folder output sudah ada
mkdir -p output

echo "=== SOAL 1: Jumlah Log per Level ==="
grep -o '"level"[[:space:]]*:[[[:space:]]*"[^"]*' app.json | awk -F'"' '{print $4}' | sort | uniq -c
echo ""

echo "=== SOAL 2: Total Error di payment-service ==="
grep -E '"level"[[:space:]]*:[[:space:]]*"ERROR"' app.json | grep -E '"service_name"[[:space:]]*:[[:space:]]*"payment-service"' | wc -l
echo ""

echo "=== SOAL 3: Ekstrak Log ERROR ke File Terpisah ==="
grep -E '"level"[[:space:]]*:[[:space:]]*"ERROR"' app.json > output/error-logs.json
echo "Berhasil mengekstrak log ERROR, jumlah baris:"
wc -l output/error-logs.json
echo ""

echo "=== SOAL 4: User ID Terbanyak yang Mengalami ERROR ==="
grep -E '"level"[[:space:]]*:[[:space:]]*"ERROR"' app.json | grep -o '"user_id"[[:space:]]*:[[:space:]]*"[^"]*' | awk -F'"' '{print $4}' | sort | uniq -c | sort -rn | head -n 5
echo ""

echo "=== SOAL 5: Pesan Error Unik dan Jumlahnya ==="
grep -E '"level"[[:space:]]*:[[:space:]]*"ERROR"' app.json | grep -o '"message"[[:space:]]*:[[:space:]]*"[^"]*' | awk -F'"' '{print $4}' | sort | uniq -c | sort -rn
