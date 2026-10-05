-- p01_lingkungan_25430045.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.
CREATE DATABASE kopma_045
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'mhs_045'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_045.* TO 'mhs_045'@'localhost';