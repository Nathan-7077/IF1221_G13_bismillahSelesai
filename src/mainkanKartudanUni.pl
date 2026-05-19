cekKartuTinggalDua(Player):-
	getLength([kartu(Warna, Jenis)| Sisa], Length),
	Length is 2.

  mainkanKartudanUni(NoKartu):-
	currentPlayer(Player),
	(
		cekKartuTinggalDua(Player)
		->
		(
			NoKartuRill is NoKartu - 1,
			currentPlayer(Player),
			cards(Player, Hand),
			ambilDariHand(NoKartuRill, Hand, Kartu(Warna, Jenis)),
			(
				BisaDimainkan(Player, kartu(Warna, Jenis)) 
				->
				write(Player), write('memainkan kartu: '), write(Warna), write('-'), write(Jenis), nl, efekJenis(Jenis),
				jadiTop(kartu(Warna, Jenis)),
				buangDariHand(NoKartuRill),
				write(Player),
				write(' menyerukan UNI!'),
				assertz(PlayerBilangUni(Nama)),
				passTurn,
				currentPlayer(NextPlayer)
				;
				write('Kartu tidak bisa dimainkan, mainkan kartu lain atau ambil kartu.')
				nl
		).
		;
		write('Kartu masih lebih dari 2, '),
		write(Player),
		write('mendapat 1 kartu'),
		/* ambil kartu */
		passTurn
		).
	).
