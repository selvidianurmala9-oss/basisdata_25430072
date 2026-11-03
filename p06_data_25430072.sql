-- =====================================================
-- PROYEK TOKO DARING SERBA DIGITAL SDN
-- MODUL 6: DATA DML
-- Nama  : Selvi Dia Nurmala
-- NIM   : 25430072
-- Kelas : C
-- Database: toko_072
-- =====================================================

USE toko_072;

-- =====================================================
-- 1. DATA PELANGGAN
-- =====================================================

INSERT INTO pelanggan
(id_pelanggan, nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pelanggan)
VALUES
('PLG-P06-01', 'Andi Saputra', 'andi.p06@email.com', '081234567801', 'Jl. Mawar No. 1'),
('PLG-P06-02', 'Bunga Lestari', 'bunga.p06@email.com', '081234567802', 'Jl. Melati No. 2'),
('PLG-P06-03', 'Citra Amelia', 'citra.p06@email.com', '081234567803', 'Jl. Kenanga No. 3'),
('PLG-P06-04', 'Dimas Pratama', 'dimas.p06@email.com', '081234567804', 'Jl. Anggrek No. 4'),
('PLG-P06-05', 'Eka Putri', 'eka.p06@email.com', '081234567805', 'Jl. Flamboyan No. 5')
ON DUPLICATE KEY UPDATE
nama_pelanggan = VALUES(nama_pelanggan);

-- =====================================================
-- 2. DATA PRODUK
-- =====================================================

INSERT INTO produk
(kode_produk, nama_produk, kategori_produk, harga_produk, stok_produk)
VALUES
('PRD-P06-01', 'Laptop ASUS VivoBook', 'Elektronik', 7500000, 20),
('PRD-P06-02', 'Mouse Wireless', 'Aksesoris', 150000, 50),
('PRD-P06-03', 'Keyboard Mechanical', 'Aksesoris', 350000, 30),
('PRD-P06-04', 'Headset Bluetooth', 'Elektronik', 275000, 25),
('PRD-P06-05', 'Flashdisk 64GB', 'Penyimpanan', 85000, 60)
ON DUPLICATE KEY UPDATE
nama_produk = VALUES(nama_produk),
harga_produk = VALUES(harga_produk),
stok_produk = VALUES(stok_produk);

-- =====================================================
-- 3. DATA ADMIN
-- =====================================================

INSERT INTO admin
(id_admin, nama_admin, peran_admin)
VALUES
('ADM-P06-01', 'Rina Amelia', 'Admin Utama'),
('ADM-P06-02', 'Budi Santoso', 'Admin Produk'),
('ADM-P06-03', 'Siti Rahma', 'Admin Pesanan'),
('ADM-P06-04', 'Agus Setiawan', 'Admin Pembayaran'),
('ADM-P06-05', 'Dewi Anggraini', 'Admin Pengiriman')
ON DUPLICATE KEY UPDATE
nama_admin = VALUES(nama_admin);

-- =====================================================
-- 4. DATA KERANJANG
-- =====================================================

INSERT INTO keranjang
(id_keranjang, id_pelanggan, tanggal_pembuatan)
VALUES
('KRG-P06-01', 'PLG-P06-01', '2026-10-01'),
('KRG-P06-02', 'PLG-P06-02', '2026-10-02'),
('KRG-P06-03', 'PLG-P06-03', '2026-10-03'),
('KRG-P06-04', 'PLG-P06-04', '2026-10-04'),
('KRG-P06-05', 'PLG-P06-05', '2026-10-05')
ON DUPLICATE KEY UPDATE
id_pelanggan = VALUES(id_pelanggan);

-- =====================================================
-- 5. DATA DETAIL KERANJANG
-- =====================================================

INSERT INTO detail_keranjang
(id_keranjang, kode_produk, jumlah_produk)
VALUES
('KRG-P06-01', 'PRD-P06-02', 2),
('KRG-P06-01', 'PRD-P06-05', 1),
('KRG-P06-02', 'PRD-P06-03', 1),
('KRG-P06-02', 'PRD-P06-04', 1),
('KRG-P06-03', 'PRD-P06-01', 1),
('KRG-P06-03', 'PRD-P06-02', 1),
('KRG-P06-04', 'PRD-P06-04', 2),
('KRG-P06-04', 'PRD-P06-05', 2),
('KRG-P06-05', 'PRD-P06-03', 1),
('KRG-P06-05', 'PRD-P06-05', 3)
ON DUPLICATE KEY UPDATE
jumlah_produk = VALUES(jumlah_produk);

-- =====================================================
-- 6. DATA PESANAN
-- Minimal 10 transaksi, 3 tanggal berbeda
-- =====================================================

INSERT INTO pesanan
(no_pesanan, tanggal_pesanan, id_pelanggan, ongkos_kirim, alamat_pengiriman)
VALUES
('PSN-P06-0001', '2026-10-10', 'PLG-P06-01', 15000, 'Jl. Mawar No. 1'),
('PSN-P06-0002', '2026-10-10', 'PLG-P06-02', 15000, 'Jl. Melati No. 2'),
('PSN-P06-0003', '2026-10-10', 'PLG-P06-03', 20000, 'Jl. Kenanga No. 3'),
('PSN-P06-0004', '2026-10-11', 'PLG-P06-04', 15000, 'Jl. Anggrek No. 4'),
('PSN-P06-0005', '2026-10-11', 'PLG-P06-05', 20000, 'Jl. Flamboyan No. 5'),
('PSN-P06-0006', '2026-10-11', 'PLG-P06-01', 15000, 'Jl. Mawar No. 1'),
('PSN-P06-0007', '2026-10-12', 'PLG-P06-02', 15000, 'Jl. Melati No. 2'),
('PSN-P06-0008', '2026-10-12', 'PLG-P06-03', 20000, 'Jl. Kenanga No. 3'),
('PSN-P06-0009', '2026-10-12', 'PLG-P06-04', 15000, 'Jl. Anggrek No. 4'),
('PSN-P06-0010', '2026-10-12', 'PLG-P06-05', 20000, 'Jl. Flamboyan No. 5')
ON DUPLICATE KEY UPDATE
tanggal_pesanan = VALUES(tanggal_pesanan),
id_pelanggan = VALUES(id_pelanggan);

-- =====================================================
-- 7. DATA DETAIL PESANAN
-- =====================================================

INSERT INTO detail_pesanan
(no_pesanan, kode_produk, jumlah_produk, harga_saat_transaksi)
VALUES
('PSN-P06-0001', 'PRD-P06-02', 2, 150000),
('PSN-P06-0001', 'PRD-P06-05', 1, 85000),
('PSN-P06-0002', 'PRD-P06-03', 1, 350000),
('PSN-P06-0002', 'PRD-P06-04', 1, 275000),
('PSN-P06-0003', 'PRD-P06-01', 1, 7500000),
('PSN-P06-0003', 'PRD-P06-02', 1, 150000),
('PSN-P06-0004', 'PRD-P06-04', 2, 275000),
('PSN-P06-0004', 'PRD-P06-05', 2, 85000),
('PSN-P06-0005', 'PRD-P06-03', 1, 350000),
('PSN-P06-0005', 'PRD-P06-05', 3, 85000),
('PSN-P06-0006', 'PRD-P06-02', 1, 150000),
('PSN-P06-0006', 'PRD-P06-04', 1, 275000),
('PSN-P06-0007', 'PRD-P06-01', 1, 7500000),
('PSN-P06-0007', 'PRD-P06-05', 1, 85000),
('PSN-P06-0008', 'PRD-P06-03', 2, 350000),
('PSN-P06-0008', 'PRD-P06-02', 1, 150000),
('PSN-P06-0009', 'PRD-P06-04', 1, 275000),
('PSN-P06-0009', 'PRD-P06-05', 2, 85000),
('PSN-P06-0010', 'PRD-P06-01', 1, 7500000),
('PSN-P06-0010', 'PRD-P06-03', 1, 350000)
ON DUPLICATE KEY UPDATE
jumlah_produk = VALUES(jumlah_produk),
harga_saat_transaksi = VALUES(harga_saat_transaksi);

-- =====================================================
-- 8. DATA PEMBAYARAN
-- =====================================================

INSERT INTO pembayaran
(id_pembayaran, no_pesanan, tanggal_pembayaran, jumlah_pembayaran, status_pembayaran)
VALUES
('BYR-P06-01', 'PSN-P06-0001', '2026-10-10', 400000, 'Lunas'),
('BYR-P06-02', 'PSN-P06-0002', '2026-10-10', 640000, 'Lunas'),
('BYR-P06-03', 'PSN-P06-0003', '2026-10-10', 7670000, 'Lunas'),
('BYR-P06-04', 'PSN-P06-0004', '2026-10-11', 735000, 'Lunas'),
('BYR-P06-05', 'PSN-P06-0005', '2026-10-11', 625000, 'Menunggu Konfirmasi'),
('BYR-P06-06', 'PSN-P06-0006', '2026-10-11', 440000, 'Lunas'),
('BYR-P06-07', 'PSN-P06-0007', '2026-10-12', 7600000, 'Lunas'),
('BYR-P06-08', 'PSN-P06-0008', '2026-10-12', 870000, 'Lunas'),
('BYR-P06-09', 'PSN-P06-0009', '2026-10-12', 460000, 'Belum Dibayar'),
('BYR-P06-10', 'PSN-P06-0010', '2026-10-12', 7870000, 'Lunas')
ON DUPLICATE KEY UPDATE
jumlah_pembayaran = VALUES(jumlah_pembayaran),
status_pembayaran = VALUES(status_pembayaran);

-- =====================================================
-- 9. DATA PENGIRIMAN
-- =====================================================

INSERT INTO pengiriman
(id_pengiriman, no_pesanan, tanggal_pengiriman, nomor_resi, status_pengiriman)
VALUES
('KRM-P06-01', 'PSN-P06-0001', '2026-10-11', 'RESI-P060001', 'Terkirim'),
('KRM-P06-02', 'PSN-P06-0002', '2026-10-11', 'RESI-P060002', 'Terkirim'),
('KRM-P06-03', 'PSN-P06-0003', '2026-10-11', 'RESI-P060003', 'Dalam Pengiriman'),
('KRM-P06-04', 'PSN-P06-0004', '2026-10-12', 'RESI-P060004', 'Terkirim'),
('KRM-P06-05', 'PSN-P06-0005', NULL, NULL, 'Belum Dikirim'),
('KRM-P06-06', 'PSN-P06-0006', '2026-10-12', 'RESI-P060006', 'Dalam Pengiriman'),
('KRM-P06-07', 'PSN-P06-0007', '2026-10-13', 'RESI-P060007', 'Terkirim'),
('KRM-P06-08', 'PSN-P06-0008', '2026-10-13', 'RESI-P060008', 'Terkirim'),
('KRM-P06-09', 'PSN-P06-0009', NULL, NULL, 'Belum Dikirim'),
('KRM-P06-10', 'PSN-P06-0010', '2026-10-13', 'RESI-P060010', 'Dalam Pengiriman')
ON DUPLICATE KEY UPDATE
status_pengiriman = VALUES(status_pengiriman);

-- =====================================================
-- SELESAI
-- =====================================================

-- Memeriksa jumlah data pada seluruh tabel

SELECT 'pelanggan' AS nama_tabel, COUNT(*) AS jumlah_data FROM pelanggan
UNION ALL
SELECT 'produk', COUNT(*) FROM produk
UNION ALL
SELECT 'admin', COUNT(*) FROM admin
UNION ALL
SELECT 'keranjang', COUNT(*) FROM keranjang
UNION ALL
SELECT 'detail_keranjang', COUNT(*) FROM detail_keranjang
UNION ALL
SELECT 'pesanan', COUNT(*) FROM pesanan
UNION ALL
SELECT 'detail_pesanan', COUNT(*) FROM detail_pesanan
UNION ALL
SELECT 'pembayaran', COUNT(*) FROM pembayaran
UNION ALL
SELECT 'pengiriman', COUNT(*) FROM pengiriman;