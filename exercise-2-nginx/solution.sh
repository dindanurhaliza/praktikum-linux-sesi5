#!/bin/bash

# Pastikan folder output sudah ada
mkdir -p output

echo "=== SOAL 1: Top 10 IP dengan Request Terbanyak ==="
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -n 10
echo ""

echo "=== SOAL 2: Error Rate per Jam ==="
echo -e "Jam\t|\tTotal\t|\tError\t|\tRate%"
echo "--------------------------------------------------------"
awk '{
    split($4, data, ":");
    jam = data[2];
    total[jam]++;
    if ($9 >= 400) error[jam]++;
} END {
    for (j in total) {
        err = error[j] ? error[j] : 0;
        rate = (err / total[j]) * 100;
        printf "%s:00\t|\t%d\t|\t%d\t|\t%.2f%%\n", j, total[j], err, rate
    }
}' access.log | sort
echo ""

echo "=== SOAL 3: Identifikasi Suspected Brute Force ==="
awk '($7 ~ /\/login/ || $7 ~ /\/admin/) {print $1}' access.log | sort | uniq -c | awk '$1 > 50 {print "IP: " $2 " - Total: " $1 " requests"}'
echo ""

echo "=== SOAL 4: Endpoint Paling Lambat (Top 10 Rata-rata) ==="
awk '{print $7, $NF}' access.log | awk '{sum[$1]+=$2; cnt[$1]++} END {for(e in sum) printf "%.2f ms - %s\n", sum[e]/cnt[e], e}' | sort -rn | head -n 10
echo ""

echo "=== SOAL 5: Total Bytes Transferred ==="
total_bytes=$(awk '{sum+=$10} END {print sum}' access.log)
total_mb=$(awk -v bytes="$total_bytes" 'BEGIN {printf "%.2f", bytes/1024/1024}')
echo "Total: $total_bytes bytes ($total_mb MB)"
