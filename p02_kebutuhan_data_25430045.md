# Dokumen Kebutuhan Data - Perpustakaan Kampus Pustaka Sejahtera (fiktif)

NIM: 25430045 · Mata kuliah: Praktikum Basis Data · Milestone Proyek 2

---

## 1. Latar belakang dan aktivitas organisasi

Perpustakaan Kampus Pustaka Sejahtera (fiktif) melayani mahasiswa dan dosen di lingkungan kampus. Perpustakaan memiliki koleksi buku cetak. Satu judul buku dapat memiliki beberapa eksemplar fisik, dan setiap eksemplar punya nomor induk sendiri.

Aktivitas utama:

1. Calon anggota mendaftar dengan NIM/NIDN, nama, program studi/unit, dan nomor HP, lalu memperoleh nomor anggota berformat `M-xxxx`.
2. Pustakawan mencatat peminjaman dan mencetak slip peminjaman. Satu transaksi maksimal 3 eksemplar.
3. Saat buku kembali, pustakawan mencatat pengembalian, memeriksa kondisi buku, dan menghitung denda bila terlambat.
4. Anggota membayar denda di meja layanan.
5. Petugas koleksi mencatat judul dan eksemplar baru ke katalog.
6. Setiap awal bulan, kepala perpustakaan menerima laporan peminjaman, buku terpopuler, buku terlambat, dan denda.

Keluhan yang melatarbelakangi (hasil wawancara fiktif):

- Kepala perpustakaan: "Tarif denda pernah diubah, tapi kami bingung menghitung ulang denda lama."
- Petugas koleksi: "Satu judul punya banyak buku, kami sulit tahu eksemplar mana yang sedang dipinjam."
- Pustakawan: "Anggota sering lupa kartu, jadi kami mencarinya lewat NIM."

## 2. Aktor dan proses bisnis

| Kode  | Proses bisnis                  | Aktor                        | Pemicu                              |
|-------|--------------------------------|------------------------------|-------------------------------------|
| PB-01 | Mendaftarkan anggota           | Pustakawan                   | Calon anggota ingin menjadi anggota |
| PB-02 | Mencatat peminjaman            | Pustakawan                   | Anggota membawa buku ke meja layanan|
| PB-03 | Mencatat pengembalian & denda  | Pustakawan                   | Anggota mengembalikan buku          |
| PB-04 | Mencatat pembayaran denda      | Pustakawan                   | Anggota membayar denda              |
| PB-05 | Katalogisasi buku              | Petugas koleksi              | Buku baru diterima                  |
| PB-06 | Mengelola data petugas         | Kepala perpustakaan          | Petugas baru/berhenti               |
| PB-07 | Menyusun laporan bulanan       | Kepala perpustakaan          | Awal bulan                          |

## 3. Dokumen sumber yang dianalisis

### 3.1 Slip peminjaman (fiktif, dirancang sendiri)

```
PERPUSTAKAAN KAMPUS PUSTAKA SEJAHTERA
No. Slip   : PM-2610-0021
Tanggal    : 07-10-2026 13:20
Petugas    : PT-02 (Sari)
Anggota    : M-0123  (NIM 25430011, Budi, Ilmu Komputer)
----------------------------------------------------------
No  No. Induk   Judul                       Jatuh Tempo
1   EKS-00451   Basis Data Dasar            14-10-2026
2   EKS-00812   Pemrograman Python          14-10-2026
----------------------------------------------------------
Jumlah buku    : 2
Tarif denda    : Rp1.000 / hari / buku
```

### 3.2 Pembedahan isian

| Isian pada slip     | Disimpan / Dihitung | Keterangan                                                         |
|---------------------|---------------------|--------------------------------------------------------------------|
| No. slip            | Disimpan            | Identitas unik peminjaman                                          |
| Tanggal-jam         | Disimpan            | Waktu transaksi                                                    |
| Petugas             | Disimpan            | Pencatat transaksi                                                 |
| No. anggota         | Disimpan            | Rujukan ke anggota                                                 |
| NIM, nama, prodi    | Disimpan di anggota | Tidak diulang di tiap transaksi                                    |
| No. induk eksemplar | Disimpan            | Rujukan ke eksemplar fisik (bukan judul)                           |
| Judul               | Disimpan di judul   | Diambil dari katalog                                               |
| Jatuh tempo         | Disimpan            | Tanggal pinjam + 7 hari; disimpan karena aturan lama pinjam bisa berubah |
| Jumlah buku         | Dihitung            | Turunan dari jumlah baris detail                                   |
| Tarif denda         | Disimpan per baris  | Tarif saat transaksi, tidak berubah walau tarif kemudian naik (AB-04) |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat  | Elemen data utama                                                              | Sumber                  |
|-------------------|--------------------------------------------------------------------------------|-------------------------|
| Anggota           | no anggota, NIM/NIDN, nama, prodi/unit, no HP, tanggal daftar, status aktif    | Formulir pendaftaran    |
| Petugas           | kode petugas, nama, peran (pustakawan/koleksi/kepala), status                  | Wawancara               |
| Judul buku        | kode judul, ISBN, judul, pengarang, penerbit, tahun terbit, kategori           | Katalog                 |
| Eksemplar         | no induk, kode judul, kondisi, status (tersedia/dipinjam/rusak/hilang)         | Buku fisik, katalog     |
| Peminjaman        | no slip, tanggal-jam, anggota, petugas                                         | Slip peminjaman         |
| Detail peminjaman | no slip, no induk, tanggal jatuh tempo, tarif denda saat transaksi, tanggal kembali | Slip peminjaman    |
| Denda             | no denda, no slip, no induk, jumlah hari terlambat, jumlah denda, status bayar, tanggal bayar | Pengembalian  |

## 5. Aturan bisnis

| Kode  | Aturan bisnis                                                                                                    |
|-------|------------------------------------------------------------------------------------------------------------------|
| AB-01 | Setiap peminjaman memiliki no slip unik dan minimal satu baris eksemplar.                                         |
| AB-02 | Satu transaksi peminjaman maksimal **3** eksemplar (P + 2, P = 1).                                                |
| AB-03 | Hanya anggota berstatus aktif yang boleh meminjam.                                                                |
| AB-04 | Tarif denda (Rp1.000 per hari per buku, P = 1) disimpan per baris detail peminjaman dan tidak berubah walau tarif baru berlaku. |
| AB-05 | Satu eksemplar tidak boleh dipinjam dua kali pada waktu bersamaan; hanya eksemplar berstatus *tersedia* yang boleh dipinjam. |
| AB-06 | Lama pinjam 7 hari sejak tanggal peminjaman; keterlambatan dihitung per hari kalender setelah jatuh tempo.        |
| AB-07 | Anggota yang masih memiliki denda belum lunas tidak boleh melakukan peminjaman baru.                              |
| AB-08 | NIM/NIDN dan no anggota unik; pencarian anggota dapat lewat no anggota atau NIM/NIDN.                             |
| AB-09 | No induk eksemplar unik dan setiap eksemplar terhubung ke tepat satu judul.                                       |
| AB-10 | Denda untuk eksemplar hilang atau rusak berat ditetapkan sama dengan harga pengganti buku dan dicatat terpisah dari denda terlambat. |

## 6. Kebutuhan informasi

| Kode  | Kebutuhan informasi                                                | Data yang diperlukan                                  |
|-------|--------------------------------------------------------------------|-------------------------------------------------------|
| KI-01 | Jumlah transaksi peminjaman per hari dan per bulan                 | Peminjaman, detail peminjaman                         |
| KI-02 | Lima judul buku terpopuler per bulan berdasarkan jumlah dipinjam   | Detail peminjaman, eksemplar, judul buku              |
| KI-03 | Daftar eksemplar yang melewati jatuh tempo beserta peminjamnya     | Detail peminjaman, peminjaman, anggota, eksemplar     |
| KI-04 | Total denda terbayar dan belum terbayar per bulan                  | Denda                                                 |
| KI-05 | Sepuluh anggota paling aktif meminjam per bulan                    | Peminjaman, detail peminjaman, anggota                |
| KI-06 | Jumlah eksemplar tersedia per judul                                | Eksemplar, judul buku                                 |

## 7. Matriks CRUD

| Proses                          | Anggota | Petugas | Judul | Eksemplar | Peminjaman | Detail | Denda |
|---------------------------------|:-------:|:-------:|:-----:|:---------:|:----------:|:------:|:-----:|
| PB-01 Daftar anggota            | C, U    | R       |       |           |            |        |       |
| PB-02 Catat peminjaman          | R       | R       | R     | R, U      | C          | C      | R     |
| PB-03 Catat pengembalian & denda| R       | R       |       | R, U      | R          | U      | C     |
| PB-04 Catat bayar denda         | R       | R       |       |           |            |        | U     |
| PB-05 Katalogisasi buku         |         | R       | C, U  | C, U      |            |        |       |
| PB-06 Kelola data petugas       |         | C, U    |       |           |            |        |       |
| PB-07 Laporan bulanan           | R       | R       | R     | R         | R          | R      | R     |

Pemeriksaan: setiap entitas memiliki minimal satu huruf C (Anggota: PB-01, Petugas: PB-06, Judul dan Eksemplar: PB-05, Peminjaman dan Detail: PB-02, Denda: PB-03), sehingga tidak ada entitas yatim. Status aktif anggota diubah lewat proses PB-01 (pemeliharaan data anggota, `U` ditambahkan saat perubahan status dilakukan pustakawan atas persetujuan kepala).

## 8. Kamus data awal

| No | Elemen                | Arti                                      | Contoh          | Aturan                                   | Penanggung jawab |
|----|-----------------------|-------------------------------------------|-----------------|------------------------------------------|------------------|
| 1  | no_anggota            | Nomor anggota perpustakaan                | M-0123          | Unik, format M-4 digit                   | Kepala           |
| 2  | nim_nidn_anggota      | NIM atau NIDN anggota                     | 25430011        | Unik, 8-10 digit (AB-08)                 | Kepala           |
| 3  | nama_anggota          | Nama lengkap anggota                      | Budi Santoso    | Wajib diisi                              | Kepala           |
| 4  | prodi_anggota         | Program studi/unit anggota                | Ilmu Komputer   | Wajib diisi                              | Kepala           |
| 5  | no_hp_anggota         | Nomor HP anggota                          | 0812xxxx        | Data pribadi, akses terbatas             | Kepala           |
| 6  | tgl_daftar_anggota    | Tanggal pendaftaran                       | 2026-09-01      | Tanggal valid                            | Pustakawan       |
| 7  | status_aktif_anggota  | Status keaktifan anggota                  | Aktif           | Aktif/Nonaktif (AB-03)                   | Kepala           |
| 8  | kode_petugas          | Kode petugas                              | PT-02           | Unik                                     | Kepala           |
| 9  | nama_petugas          | Nama petugas                              | Sari            | Wajib diisi                              | Kepala           |
| 10 | peran_petugas         | Peran petugas                             | Pustakawan      | Pustakawan/Koleksi/Kepala                | Kepala           |
| 11 | kode_judul            | Kode judul buku                           | J-0045          | Unik                                     | Petugas koleksi  |
| 12 | isbn_judul            | ISBN buku                                 | 9786020xxxxxx   | 13 digit, boleh kosong                   | Petugas koleksi  |
| 13 | judul_buku            | Judul buku                                | Basis Data Dasar| Wajib diisi                              | Petugas koleksi  |
| 14 | pengarang_judul       | Nama pengarang                            | A. Rahman       | Wajib diisi                              | Petugas koleksi  |
| 15 | tahun_terbit_judul    | Tahun terbit                              | 2022            | Bilangan 4 digit                         | Petugas koleksi  |
| 16 | no_induk_eksemplar    | Nomor induk eksemplar fisik               | EKS-00451       | Unik (AB-09)                             | Petugas koleksi  |
| 17 | kondisi_eksemplar     | Kondisi fisik buku                        | Baik            | Baik/Rusak ringan/Rusak berat            | Petugas koleksi  |
| 18 | status_eksemplar      | Status ketersediaan                       | Tersedia        | Tersedia/Dipinjam/Rusak/Hilang (AB-05)   | Petugas koleksi  |
| 19 | no_slip_peminjaman    | Nomor slip peminjaman                     | PM-2610-0021    | Unik per transaksi (AB-01)               | Pustakawan       |
| 20 | tgl_jam_peminjaman    | Waktu transaksi peminjaman                | 2026-10-07 13:20| Tidak boleh di masa depan                | Pustakawan       |
| 21 | tgl_jatuh_tempo       | Batas pengembalian                        | 2026-10-14      | Tanggal pinjam + 7 hari (AB-06)          | Pustakawan       |
| 22 | tarif_denda_detail    | Tarif denda saat transaksi                | 1000            | Bilangan bulat >= 0 rupiah (AB-04)       | Pustakawan       |
| 23 | tgl_kembali_detail    | Tanggal buku dikembalikan                 | 2026-10-16      | Kosong bila belum kembali                | Pustakawan       |
| 24 | no_denda              | Nomor catatan denda                       | DN-2610-0007    | Unik                                     | Pustakawan       |
| 25 | hari_terlambat_denda  | Jumlah hari terlambat                     | 2               | Bilangan bulat >= 0                      | Pustakawan       |
| 26 | jumlah_denda          | Besar denda dalam rupiah                  | 2000            | Bilangan bulat >= 0 (AB-04, AB-10)       | Pustakawan       |
| 27 | status_bayar_denda    | Status pembayaran denda                   | Belum lunas     | Lunas/Belum lunas (AB-07)                | Pustakawan       |
| 28 | tgl_bayar_denda       | Tanggal denda dibayar                     | 2026-10-17      | Kosong bila belum bayar                  | Pustakawan       |

## 9. Kebutuhan non-fungsional data

### 9.1 Parameter personal berbasis NIM

NIM = 25430045. Dua digit terakhir = 45.

P = (45 mod 9) + 1 = 0 + 1 = **1**

| Penggunaan                                  | Rumus      | Hasil                 |
|---------------------------------------------|------------|-----------------------|
| Batas maksimal item per transaksi           | P + 2      | 3 eksemplar           |
| Tarif denda harian (dalam ribu rupiah)      | P          | Rp1.000 per hari      |
| Perkiraan volume transaksi harian           | 40 + 5 x P | 45 transaksi per hari |

### 9.2 Volume dan retensi

- Perkiraan 45 transaksi peminjaman per hari (rata-rata sekitar 1,5 buku per transaksi, sekitar 70 baris detail per hari).
- Data transaksi (peminjaman, detail, denda) disimpan minimal 5 tahun.
- Data katalog (judul, eksemplar) disimpan selama koleksi masih dimiliki.

### 9.3 Data pribadi dan hak akses

| Data pribadi                      | Boleh melihat/mengubah                                      |
|-----------------------------------|-------------------------------------------------------------|
| no_hp_anggota, nim_nidn_anggota   | Kepala perpustakaan (lihat/ubah); pustakawan hanya lihat saat melayani |
| nama, prodi anggota               | Pustakawan dan kepala                                       |
| Riwayat pinjam per anggota        | Pustakawan, kepala; petugas koleksi tidak memiliki akses    |
| Data petugas                      | Kepala saja                                                 |

Pembatasan ini sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

| No | Isu kualitas                                                 | Dimensi mutu     | Antisipasi                                                           |
|----|--------------------------------------------------------------|------------------|----------------------------------------------------------------------|
| 1  | Tarif denda lama hilang saat tarif berubah                   | Akurasi, historis| Simpan tarif per baris detail (AB-04)                                |
| 2  | Satu eksemplar tercatat dipinjam dua kali                    | Konsistensi      | Validasi status eksemplar sebelum peminjaman (AB-05)                 |
| 3  | NIM anggota ganda karena pendaftaran berulang                | Keunikan         | NIM unik, cek sebelum mendaftar (AB-08)                              |
| 4  | Judul sama tercatat dengan penulisan berbeda                 | Konsistensi      | Standardisasi penulisan judul, pakai ISBN bila ada                   |
| 5  | Tanggal kembali kosong padahal buku sudah di rak             | Kelengkapan      | Pengembalian wajib diisi bersamaan dengan perubahan status eksemplar |
| 6  | Nomor HP salah format                                        | Validitas        | Validasi format 10-13 digit diawali 08                               |
| 7  | Status denda tidak diperbarui setelah dibayar                | Ketepatan waktu  | PB-04 wajib mengubah status dan tanggal bayar                        |
