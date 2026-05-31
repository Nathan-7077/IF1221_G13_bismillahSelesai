---
# IF1221 - Tugas Besar Logika Komputasional
---
## Daftar Isi
- [Gambaran Singkat](#gambaran-singkat)
- [Cara Menjalankan Program](#cara-menjalankan-program)
- [Struktur Repository](#struktur-repository)
- [Daftar Fitur Utama](#daftar-fitur-utama)
- [Anggota dan Pembagian Tugas](#anggota-dan-pembagian-tugas)

## Gambaran Singkat
Program berupa implementasi game bernama “UNI” dengan menggunakan GNU Prolog. Implementasi yang dibuat mengandung berbagai materi prolog yang telah diajarkan seperti deklarasi fakta dan rules, rekursi, list, file eksternal, penggunaan cut dan fail, dan materi-materi lain yang telah diajarkan di kelas Logika Komputasional IF1221.	

## Cara Menjalankan Program
### Prasyarat:  
   - Telah menginstall [GNU Prolog](http://www.gprolog.org/#download).
     
### Menjalankan Program:
**Windows (Command Prompt / PowerShell):**
```bash
gprolog --consult-file src/main.pl
```

**Linux / Mac:**
```bash
gprolog --consult-file src/main.pl
```

### Memulai Permainan
Setelah program berjalan, ketik perintah berikut di prompt `| ?-`:
```prolog
| ?- startGame.
```
## Struktur Repository
```text
.
├── docs/
|   ├── Milestone1_G13.pdf  # Laporan Milestone 1
│   ├── Milestone2_G13.pdf  # Laporan Milestone 2
│   └── Laporan             # Laporan Akhir
├── src/                     
│   ├── card.pl             # Definisi kartu
│   ├── endGame.pl          # Logika akhir permainan dan perhitungan skor
│   ├── gameLogic.pl        # Logika utama permainan
│   ├── main.pl             # Entry point program
│   ├── player.pl           # Manajemen pemain
│   ├── saveAndLoad.pl      # Simpan dan muat state permainan
│   ├── startGame.pl        # Inisialisasi permainan
│   ├── turn.pl             # Implememtasi aksi utama dan pendukung dalam turn
│   └── utils.pl            # Utilitas umum
│
└── README.md               # Dokumentasi Projek
```
## Daftar Fitur Utama
| Command | Deskripsi |
|---|---|
|`mulaiUNI`| Memulai permainan UNI|
| `lihatCommand` | Menampilkan daftar command |
| `cekInfo` | Mengecek status aktif permainan |
| `lihatKartu ` | Mengecek kartu yang dimiliki pemain |
| `mainkanKartu` | Memainkan kartu |
| `uni` | Menyerukan UNI |
| `tantang` | Menantang penggunaan wild draw four |
| `tangkap` | Menangkap pemain yang tidak menyerukan UNI |
| `sembunyikanKartu` | Menyembunyikan kartu dari cek info |
| `tampilkanKartu ` | Menampilkan kartu yang disembunyikan |
---
## Anggota dan Pembagian Tugas
|Nama|NIM|Tugas|
|---|---|---|
|Faishal Ahmad Nurdin|13525027 | gameLogic.pl, turn.pl, mimic card, card.pl, pengerjaan laporan bab 2 |
|Aditya Rasyid| 13525039|startGame.pl, card.pl, player.pl, endGame.pl, saveAndLoad.pl, pengerjaan laporan bab 3 |
|Nathaniel Marvelo|13525107 | startGame.pl, gameLogic.pl, turn.pl, sembunyikanKartu, README.md, pengerjaan laporan bab 1 |
|Abdur Rauuf Fawaaz|13525117| main.pl, turn.pl, gameLogic.pl, pengerjaan laporan bab 3 |
---
