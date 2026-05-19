cekKartuTinggalSatu(Player):-
	currentPlayer(Player),
	cards(Player, Hand),
	getLength(Hand, Length),
	Length is 1.

cekPlayerNggaUni(Nama, Hasil):-
	(
		playerBilangUni(Nama)
		->
		Hasil = 0
		;
		Hasil = 1
	).

tangkapPlayer(Player):-
	(
		cekKartuTinggalSatu(Player), cekPlayerNggaUni == 1
		->
		/* nambah kartu di tangan dari random */
		write(Nama),
		write(' ditangkap!, kartu '),
		write(Nama),
		write(' bertambah satu')
		;
		write('Tidak bisa menangkap '),
		write(Nama),
		/* ambilKartu(). */
	).
