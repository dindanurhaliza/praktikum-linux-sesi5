-- ============================================================
-- Migration : log teks → app_logs
-- Source    : sample.log
-- Generated : 2026-05-17 09:49:51
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

INSERT INTO app_logs (created_at, log_level, service_name, log_message)
VALUES ('2026-05-10 08:12:34', 'INFO', 'auth-service', 'User login successful');

INSERT INTO app_logs (created_at, log_level, service_name, log_message)
VALUES ('2026-05-10 08:13:01', 'WARN', 'payment-service', 'Slow payment gateway response');

INSERT INTO app_logs (created_at, log_level, service_name, log_message)
VALUES ('2026-05-10 08:14:22', 'ERROR', 'order-service', 'Order creation failed');

INSERT INTO app_logs (created_at, log_level, service_name, log_message)
VALUES ('2026-05-10 08:15:05', 'DEBUG', 'inventory-service', 'Querying stock level');

INSERT INTO app_logs (created_at, log_level, service_name, log_message)
VALUES ('2026-05-10 08:16:48', 'INFO', 'auth-service', 'Token refreshed');

COMMIT;

-- ============================================================
-- Selesai  : 5 baris berhasil dimigrasi
-- Dilewati : 0 baris (kosong / komentar / format salah)
-- Total    : 5 baris dibaca
-- ============================================================
