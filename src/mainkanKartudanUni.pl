:- include('startGameProgres.pl').
:- include('handleEffectProgres.pl').
:- include('playerProgres.pl').

:- dynamic(playerBilangUni/1).

getLength([], 0).
getLength([_|Tail], Length) :-
	getLength(Tail, TailLength),
	Length is TailLength + 1.

cekKartuTinggalDua(Player):-
	cards(Player, Hand),
	getLength(Hand, Length),
	Length is 2.

mainkanKartudanUni(NoKartu):-
	currentPlayer(Player),
	(
		cekKartuTinggalDua(Player)
		->
		NoKartuRill is NoKartu - 1,
		cards(Player, Hand),
		ambilDariHand(NoKartuRill, Hand, kartu(Warna, Jenis)),
		(
			bisaDimainkan(Player, kartu(Warna, Jenis))
			->
			write(Player),
			write(' memainkan kartu: '),
			write(Warna),
			write('-'),
			write(Jenis),
			nl,
			jadiTop(kartu(Warna, Jenis)),
			buangDariHand(NoKartuRill),
			cards(Player, NewHand),
			(
				NewHand = []
				->
				write(Player),
				write(' memenangkan permainan!'),
				nl,
				endGame
				;
				efekJenis(Jenis),
				write(Player),
				write(' menyerukan UNI!'),
				nl,
				assertz(playerBilangUni(Player)),
				passTurn,
				currentPlayer(NextPlayer),
				write('Giliran '),
				write(NextPlayer),
				write('.'),
				nl,nl
			),
			!
			;
			write('Kartu tidak bisa dimainkan, mainkan kartu lain atau ambil kartu.'),
			nl,
			!,
			fail
		)
		;
		write('Kartu masih lebih dari 2, '),
		write(Player),
		write(' mendapat 1 kartu'),
		nl,
		ambilKartuUmum(Player, 1, _),
		passTurn,
		currentPlayer(NextPlayer),
		write('Giliran '),
		write(NextPlayer),
		write('.'),
		nl
	).
