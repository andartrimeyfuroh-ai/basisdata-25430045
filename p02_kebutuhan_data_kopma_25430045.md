# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

NIM: 25430045 · Mata kuliah: Praktikum Basis Data · Modul 2 (studi kasus Kopma)

---

## 1. Latar belakang dan aktivitas organisasi

Koperasi Mahasiswa Sejahtera (Kopma, fiktif) menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli dapat berupa anggota atau umum.

- Mahasiswa mendaftar sebagai anggota dengan NIM, nama, program studi, dan nomor HP, lalu memperoleh nomor anggota berformat `A-xxxx`.
- Anggota aktif memperoleh diskon 5% untuk setiap nota.
- Tiga kasir bekerja bergantian per sif. Kasir mencatat penjualan dan mencetak nota.
- Setiap sore petugas gudang memeriksa stok. Bila stok suatu barang di bawah batas minimum, ia membuat pesanan pembelian ke pemasok.
- Ketika barang datang, stok bertambah sesuai faktur pemasok.
- Setiap awal bulan, ketua koperasi menerima laporan omzet, barang terlaris, barang dengan stok menipis, dan anggota paling aktif.

Keluhan pengguna (kutipan wawancara):

- Ketua: "Harga barang sering naik, jadi kami bingung saat melihat nota lama."
- Petugas gudang: "Kadang di buku catatan stoknya malah minus."
- Kasir: "Anggota sering lupa membawa kartu, jadi kami mencarinya lewat NIM."

Kebutuhan data yang tersirat: harga harus tersimpan per transaksi, stok tidak boleh negatif, dan anggota harus bisa dicari lewat nomor anggota maupun NIM.

## 2. Aktor dan proses bisnis

| Kode  | Proses bisnis                    | Aktor                                | Pemicu                                    |
|-------|----------------------------------|--------------------------------------|-------------------------------------------|
| PB-01 | Mendaftarkan anggota             | Kasir (atas permintaan mahasiswa)    | Mahasiswa ingin menjadi anggota           |
| PB-02 | Mencatat penjualan               | Kasir                                | Pembeli membayar di kasir                 |
| PB-03 | Memesan barang ke pemasok        | Petugas gudang                       | Stok di bawah batas minimum               |
| PB-04 | Menerima barang dari pemasok     | Petugas gudang                       | Barang datang bersama faktur              |
| PB-05 | Menyusun laporan bulanan         | Ketua koperasi                       | Awal bulan                                |
| PB-06 | Mengelola data pemasok           | Petugas gudang                       | Pemasok baru atau data pemasok berubah    |

PB-06 ditambahkan setelah pemeriksaan matriks CRUD (bagian 7): tanpa proses ini, entitas Pemasok tidak pernah di-*create*.

## 3. Dokumen sumber yang dianalisis

Dokumen sumber: **nota penjualan Kopma** (Gambar 2.5 pada buku praktikum). Setiap isian nota adalah kandidat elemen data.

| Isian pada nota                  | Disimpan / Dihitung | Keterangan                                                              |
|----------------------------------|---------------------|-------------------------------------------------------------------------|
| Nomor nota                       | Disimpan            | Identitas unik penjualan                                                |
| Tanggal-jam                      | Disimpan            | Waktu transaksi                                                         |
| Kasir                            | Disimpan            | Pencatat transaksi                                                      |
| Anggota (opsional)               | Disimpan            | Kosong untuk pembeli umum                                               |
| Barang (kode, nama)              | Disimpan di barang  | Diambil dari data barang                                                |
| Qty                              | Disimpan            | Jumlah barang per baris                                                 |
| Harga saat transaksi             | Disimpan per baris  | Tidak berubah walau harga barang naik (AB-04)                           |
| Subtotal per baris               | Dihitung            | qty x harga saat transaksi                                              |
| Diskon 5%                        | Dihitung            | Berlaku bila anggota aktif (AB-02)                                      |
| Total                            | Dihitung            | Jumlah subtotal dikurangi diskon                                        |
| Bayar                            | Disimpan            | Uang yang diterima kasir                                                |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat          | Elemen data utama                                                              | Sumber                   |
|---------------------------|--------------------------------------------------------------------------------|--------------------------|
| Anggota                   | nomor anggota, NIM, nama, program studi, nomor HP, status aktif                | Formulir pendaftaran     |
| Barang                    | kode, nama, kategori, harga jual, stok, batas minimum stok                     | Daftar barang, faktur    |
| Penjualan                 | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar                      | Nota penjualan           |
| Detail penjualan          | nomor nota, barang, qty, harga saat transaksi                                  | Nota penjualan           |
| Petugas                   | kode petugas, nama, peran (kasir/gudang/ketua)                                 | Wawancara                |
| Pemasok                   | kode, nama, telepon, alamat                                                    | Faktur pemasok           |
| Pembelian dan detailnya   | nomor faktur, tanggal, pemasok, barang, qty, harga beli                        | Faktur pemasok           |

## 5. Aturan bisnis

| Kode  | Aturan bisnis                                                                                              |
|-------|------------------------------------------------------------------------------------------------------------|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang.                                             |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia.                        |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik.   |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM.                          |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut.                              |

## 6. Kebutuhan informasi

| Kode  | Kebutuhan informasi                                    | Data yang diperlukan                          |
|-------|--------------------------------------------------------|-----------------------------------------------|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan           | Penjualan, detail penjualan                   |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty         | Detail penjualan, barang                      |
| KI-03 | Barang dengan stok di bawah batas minimum              | Barang                                        |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan      | Penjualan, detail penjualan, anggota          |

## 7. Matriks CRUD

| Proses                     | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
|----------------------------|:-------:|:------:|:---------:|:------:|:-------:|:---------:|
| PB-01 Daftar anggota       | C       |        |           |        |         |           |
| PB-02 Catat penjualan      | R       | R, U   | C         | C      |         |           |
| PB-03 Pesan ke pemasok     |         | R      |           |        | R       | C         |
| PB-04 Terima barang        |         | U      |           |        | R       | U         |
| PB-05 Laporan bulanan      | R       | R      | R         | R      |         | R         |
| PB-06 Kelola data pemasok  |         |        |           |        | C, U    |           |

Catatan pemeriksaan:

- Pada matriks awal buku (PB-01 sampai PB-05), kolom Pemasok tidak memiliki huruf C. Artinya ada proses yang terlewat, yaitu pemeliharaan data pemasok. Proses PB-06 ditambahkan untuk menutup celah ini.
- Status aktif anggota (AB-02) diubah oleh ketua koperasi. Perubahan ini belum tercakup oleh PB-01 (yang hanya *create*), sehingga perlu proses pemeliharaan anggota dengan hak `U` pada entitas Anggota.

## 8. Kamus data awal

| Elemen                        | Arti                          | Contoh          | Aturan                          | Penanggung jawab |
|-------------------------------|-------------------------------|-----------------|---------------------------------|------------------|
| no_anggota                    | Nomor anggota koperasi        | A-0457          | Unik, format A-4 digit          | Ketua            |
| nim_anggota                   | NIM anggota                   | 2301010123      | Unik, 10 digit                  | Ketua            |
| nama_anggota                  | Nama lengkap anggota          | Rina Putri      | Wajib diisi                     | Ketua            |
| no_hp_anggota                 | Nomor HP anggota              | 0812xxxx        | Data pribadi, akses terbatas    | Ketua            |
| status_aktif_anggota          | Status keaktifan anggota      | Aktif           | Aktif/Nonaktif (AB-02)          | Ketua            |
| kode_barang                   | Kode barang                   | BRG-0012        | Unik                            | Petugas gudang   |
| nama_barang                   | Nama barang                   | Pulpen hitam    | Wajib diisi                     | Petugas gudang   |
| harga_jual_barang             | Harga jual saat ini           | 4000            | Bilangan bulat >= 0 (rupiah)    | Ketua            |
| stok_barang                   | Jumlah barang tersedia        | 35              | Bilangan bulat >= 0 (AB-03)     | Petugas gudang   |
| batas_min_stok_barang         | Batas minimum stok            | 10              | Bilangan bulat >= 0 (AB-06)     | Petugas gudang   |
| no_nota_penjualan             | Nomor nota penjualan          | PJ-2609-0142    | Unik per nota                   | Kasir            |
| tgl_jam_penjualan             | Waktu transaksi penjualan     | 2026-09-15 10:30| Tidak boleh di masa depan       | Kasir            |
| qty_detail_penjualan          | Jumlah barang per baris nota  | 3               | Bilangan bulat > 0              | Kasir            |
| harga_satuan_detail_penjualan | Harga jual saat transaksi     | 4000            | Bilangan bulat >= 0 (AB-04)     | Kasir            |
| kode_petugas                  | Kode petugas                  | PT-01           | Unik                            | Ketua            |
| peran_petugas                 | Peran petugas                 | Kasir           | Kasir/Gudang/Ketua              | Ketua            |
| kode_pemasok                  | Kode pemasok                  | PS-003          | Unik                            | Petugas gudang   |
| no_faktur_pembelian           | Nomor faktur pemasok          | FK-2609-0007    | Unik                            | Petugas gudang   |
| harga_beli_detail_pembelian   | Harga beli per barang         | 3000            | Bilangan bulat >= 0 (rupiah)    | Petugas gudang   |

## 9. Kebutuhan non-fungsional data

- **Volume:** perkiraan sekitar 150 nota per hari.
- **Retensi:** data transaksi disimpan minimal 5 tahun.
- **Privasi:** nomor HP anggota adalah data pribadi dan hanya boleh dilihat oleh ketua koperasi. Pembatasan ini sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

| No | Isu kualitas                                         | Dimensi mutu      | Antisipasi                                                    |
|----|------------------------------------------------------|-------------------|---------------------------------------------------------------|
| 1  | Harga nota lama hilang saat harga barang naik        | Akurasi, historis | Simpan harga saat transaksi per baris detail (AB-04)          |
| 2  | Stok bernilai minus di catatan                       | Validitas         | Tolak penjualan bila qty melebihi stok (AB-03)                |
| 3  | NIM anggota ganda akibat pendaftaran berulang        | Keunikan          | NIM unik, pencarian lewat NIM sebelum mendaftar (AB-05)       |
| 4  | Pemasok tercatat tanpa data kontak lengkap           | Kelengkapan       | Wajibkan nama dan telepon pada PB-06                          |
| 5  | Nomor HP anggota salah format                        | Validitas         | Validasi format nomor HP saat pendaftaran                     |
