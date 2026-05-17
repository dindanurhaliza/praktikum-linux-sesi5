#!/usr/bin/env bash
# ============================================================
# migrate_logs.sh
# Migrasi log teks (pipe-delimited) ke SQL INSERT statements
#
# Usage  : bash migrate_logs.sh <input_file> [output_file]
# Default output : output/migration.sql
#
# Format input   : TIMESTAMP|LEVEL|SERVICE|MESSAGE
# Contoh data    :
#   2026-05-10 08:12:34|INFO|auth-service|User login successful
#   2026-05-10 08:13:01|WARN|payment-service|Slow payment gateway response
#   2026-05-10 08:14:22|ERROR|order-service|Order creation failed
#   2026-05-10 08:15:05|DEBUG|inventory-service|Querying stock level
#   2026-05-10 08:16:48|INFO|auth-service|Token refreshed
# ============================================================

set -euo pipefail

# ---------- warna terminal ----------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

# ---------- argumen ----------
INPUT_FILE="${1:-}"
OUTPUT_FILE="${2:-output/migration.sql}"

# ---------- validasi ----------
if [[ -z "$INPUT_FILE" ]]; then
    echo -e "${RED}[ERROR]${RESET} Harap sertakan file input."
    echo -e "        Usage: bash migrate_logs.sh <input_file> [output_file]"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo -e "${RED}[ERROR]${RESET} File tidak ditemukan: $INPUT_FILE"
    exit 1
fi

# ---------- buat direktori output jika belum ada ----------
OUTPUT_DIR="$(dirname "$OUTPUT_FILE")"
mkdir -p "$OUTPUT_DIR"

# ---------- fungsi: escape single-quote SQL ----------
sql_escape() {
    # ganti ' menjadi ''  (standar SQL)
    printf '%s' "$1" | sed "s/'/''/g"
}

# ---------- header file SQL ----------
cat > "$OUTPUT_FILE" << SQLHEADER
-- ============================================================
-- Migration : log teks → app_logs
-- Source    : $INPUT_FILE
-- Generated : $(date '+%Y-%m-%d %H:%M:%S')
-- ============================================================

-- Pastikan tabel sudah ada sebelum menjalankan script ini:
-- CREATE TABLE IF NOT EXISTS app_logs (
--     id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
--     created_at   DATETIME        NOT NULL,
--     log_level    VARCHAR(10)     NOT NULL,
--     service_name VARCHAR(64)     NOT NULL,
--     log_message  TEXT            NOT NULL,
--     INDEX idx_level   (log_level),
--     INDEX idx_service (service_name),
--     INDEX idx_time    (created_at)
-- );

BEGIN;

SQLHEADER

# ---------- proses baris demi baris ----------
total=0
skipped=0
inserted=0

while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
    ((total++)) || true

    # lewati baris kosong dan komentar (#)
    [[ -z "$raw_line" || "$raw_line" == \#* ]] && { ((skipped++)) || true; continue; }

    # hitung jumlah delimiter
    pipe_count=$(awk -F'|' '{print NF-1}' <<< "$raw_line")
    if [[ "$pipe_count" -lt 3 ]]; then
        echo -e "${YELLOW}[SKIP]${RESET}  Baris $total format tidak valid (kolom < 4): $raw_line"
        ((skipped++)) || true
        continue
    fi

    # ambil 4 kolom (MESSAGE boleh mengandung | ekstra)
    ts="$(cut -d'|' -f1 <<< "$raw_line")"
    lvl="$(cut -d'|' -f2 <<< "$raw_line")"
    svc="$(cut -d'|' -f3 <<< "$raw_line")"
    msg="$(cut -d'|' -f4- <<< "$raw_line")"

    # trim whitespace
    # trim hanya leading/trailing, bukan spasi tengah
    ts="$(echo "$ts" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    ts="${ts/T/ }"          # dukung format ISO 8601 juga
    lvl="${lvl// /}"
    svc="${svc// /}"
    msg="${msg#"${msg%%[![:space:]]*}"}"   # ltrim

    # escape untuk SQL
    ts_esc="$(sql_escape "$ts")"
    lvl_esc="$(sql_escape "$lvl")"
    svc_esc="$(sql_escape "$svc")"
    msg_esc="$(sql_escape "$msg")"

    # tulis INSERT
    printf "INSERT INTO app_logs (created_at, log_level, service_name, log_message)\n" >> "$OUTPUT_FILE"
    printf "VALUES ('%s', '%s', '%s', '%s');\n\n" \
        "$ts_esc" "$lvl_esc" "$svc_esc" "$msg_esc" >> "$OUTPUT_FILE"

    ((inserted++)) || true
done < "$INPUT_FILE"

# ---------- footer SQL ----------
cat >> "$OUTPUT_FILE" << SQLFOOTER
COMMIT;

-- ============================================================
-- Selesai  : $inserted baris berhasil dimigrasi
-- Dilewati : $skipped baris (kosong / komentar / format salah)
-- Total    : $total baris dibaca
-- ============================================================
SQLFOOTER

# ---------- ringkasan terminal ----------
echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${CYAN}║        Migrasi Log → SQL Selesai         ║${RESET}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════╝${RESET}"
echo -e "  ${GREEN}✔ Berhasil dimigrasi :${RESET} ${BOLD}$inserted${RESET} baris"
echo -e "  ${YELLOW}⚠ Dilewati           :${RESET} ${BOLD}$skipped${RESET} baris"
echo -e "  ${CYAN}📄 Total dibaca      :${RESET} ${BOLD}$total${RESET} baris"
echo -e "  ${CYAN}💾 Output            :${RESET} ${BOLD}$OUTPUT_FILE${RESET}"
echo ""
