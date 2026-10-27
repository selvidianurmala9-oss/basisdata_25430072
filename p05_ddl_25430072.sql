-- =====================================================
-- PROYEK: TOKO DARING SERBA DIGITAL SDN
-- MODUL 5: DDL DAN CONSTRAINT
-- NAMA: SELVI DIA NURMALA
-- NIM: 25430072
-- KELAS: C
-- DATABASE: toko_072
-- =====================================================

CREATE DATABASE IF NOT EXISTS toko_072;
USE toko_072;

-- =====================================================
-- 1. TABEL PELANGGAN
-- =====================================================

CREATE TABLE IF NOT EXISTS pelanggan (
id_pelanggan VARCHAR(10) PRIMARY KEY,
nama_pelanggan VARCHAR(100) NOT NULL,
email_pelanggan VARCHAR(100) NOT NULL UNIQUE,
no_hp_pelanggan VARCHAR(15),
alamat_pelanggan TEXT NOT NULL
) ENGINE=InnoDB;

-- =====================================================
-- 2. TABEL PRODUK
-- =====================================================

CREATE TABLE IF NOT EXISTS produk (
kode_produk VARCHAR(10) PRIMARY KEY,
nama_produk VARCHAR(100) NOT NULL,
kategori_produk VARCHAR(50) NOT NULL,
harga_produk DECIMAL(12,2) NOT NULL,
stok_produk INT NOT NULL DEFAULT 0,
CONSTRAINT chk_harga_produk CHECK (harga_produk >= 0),
CONSTRAINT chk_stok_produk CHECK (stok_produk >= 0)
) ENGINE=InnoDB;

-- =====================================================
-- 3. TABEL ADMIN
-- =====================================================

CREATE TABLE IF NOT EXISTS admin (
id_admin VARCHAR(10) PRIMARY KEY,
nama_admin VARCHAR(100) NOT NULL,
peran_admin VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- =====================================================
-- 4. TABEL KERANJANG
-- =====================================================

CREATE TABLE IF NOT EXISTS keranjang (
id_keranjang VARCHAR(10) PRIMARY KEY,
id_pelanggan VARCHAR(10) NOT NULL,
tanggal_pembuatan DATE NOT NULL,
CONSTRAINT fk_keranjang_pelanggan
FOREIGN KEY (id_pelanggan)
REFERENCES pelanggan(id_pelanggan)
) ENGINE=InnoDB;

-- =====================================================
-- 5. TABEL DETAIL KERANJANG
-- =====================================================

CREATE TABLE IF NOT EXISTS detail_keranjang (
id_keranjang VARCHAR(10) NOT NULL,
kode_produk VARCHAR(10) NOT NULL,
jumlah_produk INT NOT NULL,
PRIMARY KEY (id_keranjang, kode_produk),
CONSTRAINT fk_detail_keranjang_keranjang
FOREIGN KEY (id_keranjang)
REFERENCES keranjang(id_keranjang),
CONSTRAINT fk_detail_keranjang_produk
FOREIGN KEY (kode_produk)
REFERENCES produk(kode_produk),
CONSTRAINT chk_jumlah_keranjang
CHECK (jumlah_produk > 0)
) ENGINE=InnoDB;

-- =====================================================
-- 6. TABEL PESANAN
-- =====================================================

CREATE TABLE IF NOT EXISTS pesanan (
no_pesanan VARCHAR(12) PRIMARY KEY,
tanggal_pesanan DATE NOT NULL,
id_pelanggan VARCHAR(10) NOT NULL,
ongkos_kirim DECIMAL(12,2) NOT NULL DEFAULT 0,
alamat_pengiriman TEXT NOT NULL,
CONSTRAINT fk_pesanan_pelanggan
FOREIGN KEY (id_pelanggan)
REFERENCES pelanggan(id_pelanggan),
CONSTRAINT chk_ongkos_kirim
CHECK (ongkos_kirim >= 0)
) ENGINE=InnoDB;

-- =====================================================
-- 7. TABEL DETAIL PESANAN
-- =====================================================

CREATE TABLE IF NOT EXISTS detail_pesanan (
no_pesanan VARCHAR(12) NOT NULL,
kode_produk VARCHAR(10) NOT NULL,
jumlah_produk INT NOT NULL,
harga_saat_transaksi DECIMAL(12,2) NOT NULL,
PRIMARY KEY (no_pesanan, kode_produk),
CONSTRAINT fk_detail_pesanan_pesanan
FOREIGN KEY (no_pesanan)
REFERENCES pesanan(no_pesanan),
CONSTRAINT fk_detail_pesanan_produk
FOREIGN KEY (kode_produk)
REFERENCES produk(kode_produk),
CONSTRAINT chk_jumlah_pesanan
CHECK (jumlah_produk > 0),
CONSTRAINT chk_harga_transaksi
CHECK (harga_saat_transaksi >= 0)
) ENGINE=InnoDB;

-- =====================================================
-- 8. TABEL PEMBAYARAN
-- =====================================================

CREATE TABLE IF NOT EXISTS pembayaran (
id_pembayaran VARCHAR(10) PRIMARY KEY,
no_pesanan VARCHAR(12) NOT NULL UNIQUE,
tanggal_pembayaran DATE,
jumlah_pembayaran DECIMAL(12,2) NOT NULL,
status_pembayaran ENUM(
'Belum Dibayar',
'Menunggu Konfirmasi',
'Lunas',
'Gagal'
) NOT NULL DEFAULT 'Belum Dibayar',
CONSTRAINT fk_pembayaran_pesanan
FOREIGN KEY (no_pesanan)
REFERENCES pesanan(no_pesanan),
CONSTRAINT chk_jumlah_pembayaran
CHECK (jumlah_pembayaran >= 0)
) ENGINE=InnoDB;

-- =====================================================
-- 9. TABEL PENGIRIMAN
-- =====================================================

CREATE TABLE IF NOT EXISTS pengiriman (
id_pengiriman VARCHAR(10) PRIMARY KEY,
no_pesanan VARCHAR(12) NOT NULL,
tanggal_pengiriman DATE,
nomor_resi VARCHAR(30) UNIQUE,
status_pengiriman ENUM(
'Belum Dikirim',
'Dalam Pengiriman',
'Terkirim',
'Gagal'
) NOT NULL DEFAULT 'Belum Dikirim',
CONSTRAINT fk_pengiriman_pesanan
FOREIGN KEY (no_pesanan)
REFERENCES pesanan(no_pesanan)
) ENGINE=InnoDB;

-- =====================================================
-- MENAMPILKAN SELURUH TABEL
-- =====================================================

SHOW TABLES;
