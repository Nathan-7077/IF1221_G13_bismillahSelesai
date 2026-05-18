% warna

warna(merah).
warna(biru).
warna(hijau).
warna(kuning).

% jenis angka

jenis(0).
jenis(1).
jenis(2).
jenis(3).
jenis(4).
jenis(5).
jenis(6).
jenis(7).
jenis(8).
jenis(9).

% jenis umum

jenis(skip).
jenis(reverse).
jenis(draw_two).

% jenis wildcard

wildJenis(wild).
wildJenis(wild_draw_four).
wildJenis(mimic).

% definisi

kartu(Warna,Jenis):-
    warna(Warna),
    jenis(Jenis).

kartu(hitam,Jenis):-
    wildJenis(Jenis).
