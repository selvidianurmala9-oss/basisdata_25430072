-- =========================================================
-- Modul 6: Mengisi, Mengubah, dan Menguji Data dengan DML
-- Data sampel Koperasi Mahasiswa Sejahtera (Kopma)
-- Nama : Selvi Dia Nurmala
-- NIM  : 25430072
-- Kelas: C
-- Database: kopma_072
-- =========================================================

USE kopma_072;

-- 1. Mengisi data petugas
INSERT INTO petugas
(kode_petugas, nama_petugas, peran_petugas)
VALUES
('K01', 'Dimas', 'kasir'),
('K02', 'Sari', 'kasir'),
('K03', 'Rina', 'kasir'),
('G01', 'Joko', 'gudang'),
('P01', 'Ketua Kopma', 'ketua');

-- 2. Mengisi data barang
INSERT INTO barang
(kode_barang, nama_barang, kategori_barang,
 harga_jual_barang, stok_barang, stok_minimum_barang)
VALUES
('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000, 120, 10),
('ATK-002', 'Buku Tulis 58', 'ATK', 6500, 80, 10),
('MNM-001', 'Air Mineral 600', 'minuman', 4000, 24, 5),
('MKN-001', 'Roti Cokelat', 'makanan', 5000, 60, 5);

-- 3. Mengisi data anggota (satu nonaktif, daftar sebelum 2025)
INSERT INTO anggota
(no_anggota, nim_anggota, nama_anggota, prodi_anggota,
 no_hp_anggota, status_anggota, tgl_daftar_anggota)
VALUES
('A-0001', '2543000001', 'Andi', 'Ilmu Komputer',
 '081234567801', 'aktif', '2026-09-01'),
('A-0002', '2543000002', 'Budi', 'Ilmu Komputer',
 '081234567802', 'aktif', '2026-09-02'),
('A-0003', '2543000003', 'Citra', 'Manajemen',
 '081234567803', 'nonaktif', '2024-08-12');

-- 4. Mengisi data pemasok
INSERT INTO pemasok
(kode_pemasok, nama_pemasok, telepon_pemasok, alamat_pemasok)
VALUES
('PSP-001', 'CV Sumber ATK', '081234567811', 'Metro'),
('PSP-002', 'PT Sumber Pangan', '081234567812', 'Lampung');

-- 5. Mengisi penjualan
INSERT INTO penjualan
(no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES
('PJ-2609-0142', '2026-09-24 10:15:00',
 (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K03'),
 (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0001'), 30000),
('PJ-2609-0143', '2026-09-25 13:40:00',
 (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'),
 NULL, 15000),
('PJ-2609-0144', '2026-09-26 09:05:00',
 (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K02'),
 (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0002'), 25000);

-- 6. Mengisi detail penjualan (harga disalin dari tabel barang)
INSERT INTO detail_penjualan
(id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, x.qty, b.harga_jual_barang
FROM (
  SELECT 'PJ-2609-0142' AS nota, 'ATK-001' AS kode, 3 AS qty
  UNION ALL SELECT 'PJ-2609-0142', 'ATK-002', 1
  UNION ALL SELECT 'PJ-2609-0142', 'MNM-001', 2
  UNION ALL SELECT 'PJ-2609-0143', 'MKN-001', 2
  UNION ALL SELECT 'PJ-2609-0143', 'MNM-001', 1
  UNION ALL SELECT 'PJ-2609-0144', 'ATK-001', 5
  UNION ALL SELECT 'PJ-2609-0144', 'MKN-001', 1
) AS x
JOIN penjualan p ON p.no_nota_penjualan = x.nota
JOIN barang    b ON b.kode_barang       = x.kode;

-- 7. Mengurangi stok sesuai qty terjual
UPDATE barang SET stok_barang = stok_barang - 8 WHERE kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'MNM-001';
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'MKN-001';

-- 8. Memeriksa data
SELECT * FROM petugas;
SELECT * FROM barang;
SELECT * FROM anggota;
SELECT * FROM pemasok;
SELECT * FROM penjualan;
SELECT * FROM detail_penjualan;

SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'barang',           COUNT(*) FROM barang
UNION ALL SELECT 'anggota',          COUNT(*) FROM anggota
UNION ALL SELECT 'pemasok',          COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan',        COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan;