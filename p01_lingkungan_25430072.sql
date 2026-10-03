-- Nama: Selvi Dia Nurmala
-- NIM: 25430072
-- Kelas: C

SELECT VERSION();

SELECT USER();

SHOW DATABASES;

CREATE DATABASE kopma_072
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER 'mhs_072'@'localhost'
IDENTIFIED BY '<PASSWORD>';

GRANT ALL PRIVILEGES ON kopma_072.* 
TO 'mhs_072'@'localhost';

USE kopma_072;

SHOW TABLES;

SELECT @@sql_mode;