tangkapPlayer(nama):-
	(
		/* predikat buat ngecek bisa tangkap ngga -> cekTangkap(nama)*/
		->
		/* nambah kartu di tangan dari random -> assertz(Warna, Jenis), */
		write(nama),
		write(' ditangkap!, kartu '),
		write(nama),
		write(' bertambah satu').
		;
		write('Tidak bisa menangkap '),
		write(nama)
	).

/* Predikat penunjang */
cekTangkap(nama):-
	/* ngecek apakah kartu yang ada di tangan tinggal 1 */
	
	/* kalau misal bener tinggal 1, ngecek bener ngga playernya belum bilang UNI */

cekKartuTinggalSatu(Nama):-
  kumpulSemuaKartuPemain(Nama, ListKartu),
	getLength(ListKartu, Length),
	Length is 1.

/* ambilKartu(nama):-
	assertz(kartuPemain(nama */

kumpulSemuaKartuPemain(Nama, List) :-
    kumpulSemuaKartuPemain([], Nama, List).

kumpulSemuaKartuPemain(Akumulator, Nama, List) :-
    (   clause(kartuPemain(Nama, Y), true), \+ member(kartuPemain(Nama, Y), Akumulator)
    	->  kumpulSemuaKartuPemain([kartuPemain(Nama, Y) | Akumulator], Nama, List)
    	;   List = Akumulator
    ).

getLength([], 0).
getLength([_|Tail], Length) :-
	getLength(Tail, TailLength),
	Length is TailLength + 1.
