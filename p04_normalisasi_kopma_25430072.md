# Normalisasi Data Kopma

**Nama:** Selvi Dia Nurmala  
**NIM:** 25430072  
**Kelas:** C  
**Mata Kuliah:** Praktikum Basis Data  
**Modul:** 4 — Normalisasi dan Skema Relasional

---

## 1. Pendahuluan

Normalisasi merupakan proses menyusun data ke dalam tabel yang sesuai untuk mengurangi pengulangan data serta mencegah anomali penyisipan, perubahan, dan penghapusan.

Pada praktikum ini, data nota penjualan Kopma dianalisis mulai dari bentuk tidak normal (UNF), bentuk normal pertama (1NF), bentuk normal kedua (2NF), hingga bentuk normal ketiga (3NF). Selanjutnya, skema relasional diperiksa berdasarkan aturan Boyce-Codd Normal Form (BCNF).

Normalisasi dilakukan dengan memperhatikan aturan bisnis Kopma agar setiap tabel menyimpan informasi yang sesuai dan hubungan antartabel dapat dipertahankan.

## 2. Aturan Bisnis

Proses normalisasi mengacu pada aturan bisnis berikut.

- **AB-01:** Setiap nota penjualan memiliki nomor nota yang unik dan memuat minimal satu barang.
- **AB-02:** Penjualan dapat dilakukan kepada anggota maupun pembeli umum. Anggota aktif memperoleh diskon 5% sesuai ketentuan Kopma.
- **AB-03:** Stok barang tidak boleh bernilai negatif.
- **AB-04:** Harga jual pada setiap baris transaksi harus disimpan agar riwayat harga saat transaksi tetap tersedia.
- **AB-05:** NIM anggota harus unik dan anggota dapat dicari menggunakan nomor anggota atau NIM.
- **AB-06:** Pesanan pembelian dibuat apabila stok barang berada di bawah batas minimum.
- **AB-07:** Kode pemasok harus unik.
- **AB-08:** Perubahan status keanggotaan hanya dapat dilakukan oleh ketua Kopma.

Aturan tersebut digunakan untuk menentukan atribut, dependensi fungsional, dan hubungan antartabel.

## 3. Bentuk Tidak Normal (UNF)

### 3.1 Relasi UNF

Pada bentuk UNF, informasi nota penjualan, petugas, anggota, dan barang masih digabungkan dalam satu relasi. Satu nota dapat memuat beberapa barang sehingga terdapat kelompok atribut barang yang berulang.

Relasi UNF:

NOTA_UNF(
no_nota_penjualan,
tgl_penjualan,
kode_petugas,
nama_petugas,
no_anggota,
nama_anggota,
{kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan},
jumlah_penjualan,
diskon_penjualan,
total_penjualan
)

Tanda kurung kurawal menunjukkan kelompok atribut barang yang dapat berulang pada satu nota.

### 3.2 Anomali Data

Bentuk data yang belum dinormalisasi dapat menimbulkan tiga jenis anomali.

1. **Anomali ubah:** Informasi yang disimpan berulang dapat menjadi tidak konsisten ketika hanya sebagian baris diperbarui.
2. **Anomali sisip:** Informasi tertentu sulit ditambahkan jika harus menunggu informasi lain tersedia.
3. **Anomali hapus:** Penghapusan satu transaksi dapat menyebabkan informasi lain ikut hilang apabila keduanya disimpan dalam relasi yang sama.

Oleh karena itu, data perlu dipecah berdasarkan ketergantungan fungsional dan aturan bisnisnya.

## 4. Bentuk Normal Pertama (1NF)

Untuk mencapai 1NF, kelompok barang yang berulang dihilangkan. Setiap baris mewakili satu barang pada satu nota dan setiap atribut berisi satu nilai.

Relasi 1NF:

NOTA_1NF(
no_nota_penjualan,
kode_barang,
tgl_penjualan,
kode_petugas,
nama_petugas,
no_anggota,
nama_anggota,
nama_barang,
qty_detail_penjualan,
harga_satuan_detail_penjualan,
subtotal_detail_penjualan,
jumlah_penjualan,
diskon_penjualan,
total_penjualan
)

Kunci primer komposit:

`(no_nota_penjualan, kode_barang)`

Pada tahap ini, setiap atribut telah disusun agar bernilai atomik. Namun, informasi nota, petugas, anggota, dan barang masih berulang pada beberapa baris sehingga perlu dilakukan pemisahan lebih lanjut.

## 5. Dependensi Fungsional

Dependensi fungsional menunjukkan hubungan ketika suatu atribut atau kelompok atribut menentukan nilai atribut lain. Dependensi berikut ditetapkan berdasarkan aturan bisnis Kopma.

### FD1

`no_nota_penjualan → tgl_penjualan, kode_petugas, no_anggota`

Satu nomor nota menentukan tanggal transaksi, petugas yang melayani, dan anggota yang melakukan transaksi jika pembeli merupakan anggota. Transaksi pembeli umum tidak memiliki anggota sehingga `no_anggota` dapat bernilai NULL. Dependensi ini berkaitan dengan AB-01 dan AB-02.

### FD2

`kode_petugas → nama_petugas`

Kode petugas menentukan nama petugas yang bersangkutan.

### FD3

`no_anggota → nama_anggota`

Nomor anggota menentukan nama anggota. Hal ini mengikuti aturan bahwa identitas anggota dapat dikenali melalui nomor anggota dan NIM sesuai AB-05.

### FD4

`kode_barang → nama_barang`

Kode barang menentukan nama barang yang bersangkutan.

### FD5

`(no_nota_penjualan, kode_barang) → qty_detail_penjualan, harga_satuan_detail_penjualan`

Gabungan nomor nota dan kode barang menentukan jumlah barang dan harga satuan yang digunakan pada baris transaksi. Harga satuan transaksi harus dipertahankan sesuai AB-04 karena harga tersebut dapat berbeda dari harga barang saat ini.

### FD6

`(qty_detail_penjualan, harga_satuan_detail_penjualan) → subtotal_detail_penjualan`

Subtotal dihitung dari jumlah barang dikalikan harga satuan transaksi. Subtotal merupakan nilai turunan yang dapat dihitung ketika diperlukan sehingga tidak wajib disimpan sebagai atribut operasional.

**Catatan:** `kode_barang` tidak menentukan `harga_satuan_detail_penjualan`, karena harga barang pada transaksi dapat berbeda dari harga jual barang saat ini.

## 6. Bentuk Normal Kedua (2NF)

Bentuk 2NF harus memenuhi 1NF dan menghilangkan ketergantungan parsial, yaitu ketika atribut bukan kunci hanya bergantung pada sebagian dari kunci primer komposit.

Pada NOTA_1NF, informasi nota bergantung pada `no_nota_penjualan`, sedangkan nama barang bergantung pada `kode_barang`. Oleh karena itu, relasi dipisahkan menjadi tabel PENJUALAN, BARANG, dan DETAIL_PENJUALAN.

### 6.1 Tabel PENJUALAN

PENJUALAN(
no_nota_penjualan PK,
tgl_penjualan,
kode_petugas,
nama_petugas,
no_anggota,
nama_anggota,
jumlah_penjualan,
diskon_penjualan,
total_penjualan
)

Tabel ini menyimpan informasi utama nota penjualan. Nama petugas dan nama anggota masih dicantumkan pada tahap ini untuk menunjukkan proses normalisasi sebelum pemisahan menuju 3NF.

### 6.2 Tabel BARANG

BARANG(
kode_barang PK,
nama_barang
)

Tabel ini menyimpan identitas barang. Pemisahan dilakukan agar nama barang tidak perlu diulang pada setiap baris transaksi.

### 6.3 Tabel DETAIL_PENJUALAN

DETAIL_PENJUALAN(
no_nota_penjualan PK/FK,
kode_barang PK/FK,
qty_detail_penjualan,
harga_satuan_detail_penjualan
)

Kunci primer komposit:

`(no_nota_penjualan, kode_barang)`

Kunci tamu:

- `no_nota_penjualan` mengacu pada tabel PENJUALAN.
- `kode_barang` mengacu pada tabel BARANG.

Harga satuan transaksi tetap disimpan sesuai AB-04. Subtotal dapat dihitung dari jumlah barang dikalikan harga satuan sehingga tidak harus disimpan sebagai atribut terpisah.

## 7. Bentuk Normal Ketiga (3NF)

Bentuk 3NF harus memenuhi 2NF dan menghilangkan ketergantungan transitif, yaitu ketika atribut bukan kunci bergantung pada atribut bukan kunci lainnya melalui suatu penentu.

Pada tabel PENJUALAN hasil 2NF terdapat ketergantungan:

- `kode_petugas → nama_petugas`
- `no_anggota → nama_anggota`

Informasi nama petugas dan nama anggota tidak perlu disimpan berulang pada setiap transaksi. Oleh karena itu, tabel dipisahkan menjadi PETUGAS, ANGGOTA, dan PENJUALAN.

### 7.1 Tabel PETUGAS

PETUGAS(
kode_petugas PK,
nama_petugas,
peran_petugas
)

`kode_petugas` menjadi kunci primer dan menentukan informasi petugas.

### 7.2 Tabel ANGGOTA

ANGGOTA(
no_anggota PK,
nim_anggota UNIQUE,
nama_anggota,
prodi_anggota,
no_hp_anggota,
status_anggota,
tgl_daftar_anggota
)

`no_anggota` menjadi kunci primer, sedangkan `nim_anggota` harus unik sesuai AB-05. Informasi anggota disimpan terpisah dari transaksi penjualan.

### 7.3 Tabel PENJUALAN

PENJUALAN(
no_nota_penjualan PK,
tgl_penjualan,
kode_petugas FK,
no_anggota FK NULL
)

Kunci tamu:

- `kode_petugas` mengacu pada PETUGAS.
- `no_anggota` mengacu pada ANGGOTA dan boleh bernilai NULL.

Kolom `no_anggota` boleh bernilai NULL karena transaksi dapat dilakukan kepada pembeli umum.

Pemisahan ini mengurangi pengulangan informasi petugas dan anggota. Informasi utama penjualan tetap tersimpan dalam PENJUALAN, sedangkan rincian barang disimpan dalam DETAIL_PENJUALAN.

## 8. Skema Relasional Kanonik Kopma

Skema berikut mengikuti tabel kanonik yang digunakan pada Modul 4. Kunci primer ditulis sebagai PK, kunci unik sebagai UNIQUE, dan kunci tamu sebagai FK.

### 8.1 PETUGAS

PETUGAS(
id_petugas PK,
kode_petugas UNIQUE,
nama_petugas,
peran_petugas
)

Tabel ini menyimpan identitas dan peran petugas Kopma.

### 8.2 ANGGOTA

ANGGOTA(
id_anggota PK,
no_anggota UNIQUE,
nim_anggota UNIQUE,
nama_anggota,
prodi_anggota,
no_hp_anggota,
status_anggota,
tgl_daftar_anggota
)

Tabel ini menyimpan informasi anggota. `no_anggota` dan `nim_anggota` ditetapkan unik sesuai AB-05.

### 8.3 BARANG

BARANG(
id_barang PK,
kode_barang UNIQUE,
nama_barang,
kategori_barang,
harga_jual_barang,
stok_barang,
stok_minimum_barang
)

Tabel ini menyimpan identitas, harga jual, stok, dan batas minimum stok barang. Stok tidak boleh negatif sesuai AB-03, sedangkan batas minimum membantu menentukan kebutuhan pembelian sesuai AB-06.

### 8.4 PEMASOK

PEMASOK(
id_pemasok PK,
kode_pemasok UNIQUE,
nama_pemasok,
telepon_pemasok,
alamat_pemasok
)

Tabel ini menyimpan identitas pemasok. Kode pemasok harus unik sesuai AB-07.

### 8.5 PENJUALAN

PENJUALAN(
id_penjualan PK,
no_nota_penjualan UNIQUE,
tgl_penjualan,
id_petugas FK,
id_anggota FK NULL,
bayar_penjualan
)

Tabel ini menyimpan informasi utama penjualan. `id_petugas` mengacu pada PETUGAS dan `id_anggota` mengacu pada ANGGOTA. `id_anggota` boleh NULL untuk transaksi pembeli umum.

### 8.6 DETAIL_PENJUALAN

DETAIL_PENJUALAN(
id_penjualan PK/FK,
id_barang PK/FK,
qty_detail_penjualan,
harga_satuan_detail_penjualan
)

Kunci primer komposit:

`(id_penjualan, id_barang)`

Kunci tamu:

- `id_penjualan` mengacu pada PENJUALAN.
- `id_barang` mengacu pada BARANG.

Tabel ini menyimpan jumlah barang dan harga satuan saat transaksi. Harga satuan harus dipertahankan sesuai AB-04 agar perubahan harga barang saat ini tidak mengubah riwayat transaksi.

### 8.7 PEMBELIAN

PEMBELIAN(
id_pembelian PK,
no_faktur_pembelian,
tgl_pembelian,
id_pemasok FK
)

Tabel ini menyimpan informasi utama pembelian barang dari pemasok. `id_pemasok` mengacu pada tabel PEMASOK.

### 8.8 DETAIL_PEMBELIAN

DETAIL_PEMBELIAN(
id_pembelian PK/FK,
id_barang PK/FK,
qty_detail_pembelian,
harga_satuan_detail_pembelian
)

Kunci primer komposit:

`(id_pembelian, id_barang)`

Kunci tamu:

- `id_pembelian` mengacu pada PEMBELIAN.
- `id_barang` mengacu pada BARANG.

Tabel ini menyimpan jumlah dan harga beli per barang pada setiap transaksi pembelian apabila atribut tersebut telah ditetapkan dalam kebutuhan data Kopma.

## 9. Pemeriksaan BCNF

BCNF mensyaratkan setiap penentu dalam dependensi fungsional nontrivial merupakan superkey. Pemeriksaan dilakukan berdasarkan dependensi fungsional dan aturan kunci yang telah ditetapkan.

| Tabel | Kunci atau penentu yang diketahui | Pemeriksaan |
|---|---|---|
| PETUGAS | `id_petugas`, `kode_petugas` | `kode_petugas` ditetapkan unik sehingga menjadi kunci kandidat. |
| ANGGOTA | `id_anggota`, `no_anggota`, `nim_anggota` | Pengenal tersebut ditetapkan unik sehingga menjadi kunci kandidat. |
| BARANG | `id_barang`, `kode_barang` | `kode_barang` ditetapkan unik sehingga menjadi kunci kandidat. |
| PEMASOK | `id_pemasok`, `kode_pemasok` | `kode_pemasok` unik sesuai AB-07. |
| PENJUALAN | `id_penjualan`, `no_nota_penjualan` | `no_nota_penjualan` unik sesuai AB-01. |
| DETAIL_PENJUALAN | `(id_penjualan, id_barang)` | Pasangan tersebut menjadi kunci primer komposit. |
| PEMBELIAN | `id_pembelian` | `id_pembelian` menjadi kunci primer. |
| DETAIL_PEMBELIAN | `(id_pembelian, id_barang)` | Pasangan tersebut menjadi kunci primer komposit. |

Berdasarkan dependensi fungsional yang telah diidentifikasi, tidak ditemukan pelanggaran BCNF pada relasi yang diperiksa. Namun, pemeriksaan ini terbatas pada dependensi yang diketahui. Jika terdapat aturan bisnis tambahan yang menghasilkan penentu bukan superkey, tabel terkait harus diperiksa kembali.

## 10. Keputusan Penyimpanan Nilai Turunan

Nilai turunan dapat dihitung dari atribut lain. Keputusan penyimpanan ditentukan berdasarkan kebutuhan operasional dan kebutuhan pencatatan riwayat transaksi.

| Nilai | Perhitungan atau dasar | Keputusan |
|---|---|---|
| Subtotal detail penjualan | `qty_detail_penjualan × harga_satuan_detail_penjualan` | Dapat dihitung dari jumlah dan harga satuan. |
| Jumlah penjualan | Penjumlahan nilai detail pada satu nota | Dapat dihitung dari detail penjualan. |
| Diskon penjualan | Aturan diskon anggota aktif sebesar 5% | Dihitung berdasarkan aturan bisnis dan status anggota yang berlaku. |
| Total penjualan | Jumlah penjualan dikurangi diskon | Dapat dihitung dari jumlah dan diskon. |

Subtotal, jumlah penjualan, diskon, dan total penjualan dapat dihitung saat diperlukan sehingga tidak wajib disimpan berulang sebagai atribut operasional.

Namun, harga satuan pada DETAIL_PENJUALAN tetap harus disimpan karena merupakan harga yang berlaku saat transaksi terjadi. Harga tersebut tidak boleh digantikan oleh harga jual barang saat ini, sesuai AB-04.

Jika Kopma membutuhkan arsip transaksi untuk audit, nilai transaksi yang telah disahkan dapat disimpan sebagai snapshot dengan aturan yang jelas agar catatan historis tetap sesuai dengan transaksi saat terjadi.

## 11. Analisis dan Latihan Tambahan

### 11.1 Informasi Pemasok Barang

Informasi pemasok disimpan dalam tabel PEMASOK. Tabel PEMBELIAN menghubungkan transaksi pembelian dengan pemasok melalui `id_pemasok`, sedangkan DETAIL_PEMBELIAN menghubungkan transaksi pembelian dengan barang melalui `id_pembelian` dan `id_barang`.

Dengan hubungan tersebut, informasi pemasok tidak perlu disimpan sebagai nama teks berulang pada tabel BARANG. Sistem dapat mengetahui barang yang dibeli dari pemasok melalui hubungan PEMBELIAN, DETAIL_PEMBELIAN, dan BARANG.

### 11.2 Beberapa Nomor Telepon Pemasok

Jika satu pemasok dapat memiliki beberapa nomor telepon, menyimpan seluruh nomor dalam satu kolom akan menyulitkan pengolahan data dan tidak memenuhi prinsip nilai atomik.

Untuk mengatasinya, dibuat tabel PEMASOK_TELEPON.

PEMASOK_TELEPON(
id_pemasok PK/FK,
no_telepon_pemasok PK
)

Kunci primer komposit:

`(id_pemasok, no_telepon_pemasok)`

`id_pemasok` mengacu pada tabel PEMASOK. Setiap baris menyimpan satu nomor telepon sehingga satu pemasok dapat mempunyai beberapa nomor tanpa menggabungkan seluruh nomor dalam satu kolom.

### 11.3 Anomali Ubah Nama Anggota

Jika `nama_anggota` disimpan langsung pada PENJUALAN, nama anggota dapat berulang pada banyak nota.

Contoh data:

| no_nota_penjualan | no_anggota | nama_anggota |
|---|---|---|
| N001 | A001 | Siti Aminah |
| N002 | A001 | Siti Aminah |
| N003 | A001 | Siti Aminah |

Dependensi fungsionalnya:

`no_anggota → nama_anggota`

Jika hanya satu nota yang diperbarui, nama anggota dapat menjadi tidak konsisten. Contohnya:

```sql
UPDATE PENJUALAN
SET nama_anggota = 'Siti A.'
WHERE no_nota_penjualan = 'N001';
```

Kueri tersebut menggambarkan anomali pada rancangan yang belum dinormalisasi, ketika `nama_anggota` disimpan berulang pada PENJUALAN.

Pada skema akhir, `nama_anggota` disimpan pada ANGGOTA dan tidak diperbarui langsung pada PENJUALAN. Dengan demikian, perubahan nama cukup dilakukan pada satu tempat.

## 12. Kesimpulan

Normalisasi data Kopma dilakukan dari UNF hingga 3NF untuk mengurangi kelompok atribut berulang, ketergantungan parsial, dan ketergantungan transitif.

Pada tahap UNF, informasi nota dan barang masih berada dalam satu relasi dengan kelompok atribut barang yang berulang. Pada tahap 1NF, setiap baris mewakili satu barang dalam satu nota. Pada tahap 2NF, informasi penjualan, barang, dan detail penjualan dipisahkan untuk mengurangi ketergantungan parsial. Pada tahap 3NF, informasi petugas dan anggota dipisahkan dari transaksi untuk mengurangi pengulangan dan ketergantungan transitif.

Skema relasional kanonik terdiri dari PETUGAS, ANGGOTA, BARANG, PEMASOK, PENJUALAN, DETAIL_PENJUALAN, PEMBELIAN, dan DETAIL_PEMBELIAN. Pemeriksaan BCNF dilakukan berdasarkan dependensi fungsional serta kunci yang telah diidentifikasi.

Nilai turunan seperti subtotal, jumlah penjualan, diskon, dan total penjualan dapat dihitung berdasarkan detail transaksi dan aturan bisnis. Sementara itu, harga satuan pada detail penjualan tetap disimpan untuk mempertahankan riwayat harga saat transaksi.

Dengan normalisasi, struktur data Kopma menjadi lebih terorganisasi dan lebih mudah dikelola. Skema akhir tetap perlu dicocokkan dengan ERD dan kebutuhan data dari pertemuan sebelumnya agar seluruh atribut, kunci, dan hubungan antartabel konsisten.