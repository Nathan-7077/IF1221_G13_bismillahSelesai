warna(merah).
warna(biru).
warna(hijau).
warna(kuning).
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
jenis(skip).
jenis(reverse).
jenis(draw_two).

kartu(wild, draw_four).
kartu(wild, _).
kartu(X, Y) :- warna(X), jenis(Y).
