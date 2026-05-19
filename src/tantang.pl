cekdiLoop(Player, [], 0).
cekdiLoop(Player, [Head|Tail], Length) :-
	(
		bisaDimainkan(Player, Head)
		->
		!, fail
		;
		NewLength is Length - 1
		cekdiLoop(Player, Tail, NewLength)
	). 

getLength([], 0).
getLength([_|Tail], Length) :-
	getLength(Tail, TailLength),
	Length is TailLength + 1.

cekGaAdaKartuYangBisaDimainin(Player, Hasil):-
	(
		currentPlayer(Player),
		cards(Player, Hand),
		getLength(Hand, Length),
		( 
			cekdiLoop(Player, Hand, Length)
				-> Hasil = 1
				; Hasil = 0
		).
	). 

tantang:-
	write('Tantangan dilakukan!'),
	write('Memeriksa kartu '),
	currentPlayer(Player),
	write('...'),
	cekGaAdaKartuYangBisaDimainin(Player, Hasil),
	(		
		Hasil = 1
		->
		/* nambah 4 kartu di tangan dari random */
		write('Tantangan berhasil. '),
		NextPlayer(Player),
		write(Player),
		write(' mendapatkan 4 kartu secara acak').
		;
		/* nambah 6 kartu di tangan dari random */
		write('Tantangan gagal. '),
		NextPlayer(Player),
		write(Player),
		write(' mendapatkan 6 kartu secara acak')
	).
