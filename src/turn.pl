:-include('gameLogic.pl').
:-include('player.pl').
:-include('utils.pl').

:- dynamic(playerBilangUni/1).

/*Yang tentang info2 dalam game*/
lihatCommand:-
    write('Aksi utama yang tersedia:'),nl,
    write('1. ambilKartu'), nl,
    write('2. tantang'), nl,
    nl,
    write('Aksi pendukung yang tersedia:'),nl,
    write('1. lihatCommand'),nl,
    write('2. lihatKartu'),nl,
    write('3. cekInfo'),nl.

lihatKartu:-
    write('Berikut kartu yang anda miliki'),nl,
    currentPlayer(Player),!,
    cards(Player, Hand),
    helperLihat(Hand, 1).
helperLihat([], _):- !.
helperLihat([kartu(Warna, Jenis)| Sisa], Indeks):-
    write(Indeks), write('. '), write(Warna), write('-'), write(Jenis),nl,
    Indeks2 is Indeks + 1,
    helperLihat(Sisa, Indeks2).

printUrutan([]) :-!.
printUrutan([H|[]]) :- !,
    write(H).

printUrutan([H|T]) :-
    write(H), write(' - '),
    printUrutan(T).

infoPemain([],[],_):-!.
infoPemain([H|T],[A|B], Indeks) :-
    hitungKartu(A, Jumlah),
    write('Nama Pemain '), write(Indeks), write(': '), write(H), nl,
    write('Jumlah Kartu : '), write(Jumlah), nl,nl,
    Indeks2 is Indeks+1,
    infoPemain(T,B, Indeks2).
hitungKartu([],0).
hitungKartu([_|Sisa], Jumlah):-
    hitungKartu(Sisa, JumlahSisa),
    Jumlah is JumlahSisa+1.
listPemain(Indeks, []):-
    numPlayers(Max),
    Indeks>Max, !.
listPemain(Indeks, [H|T]):-
    playerOrder(Indeks, H),
    Indeks2 is Indeks+1,
    listPemain(Indeks2, T).
listHand([],[]).
listHand([H|T], [A|B]):-
    cards(H,A),
    listHand(T, B).
cekInfo:-
    discardPile([kartu(Warna, Jenis)| _]),
    write('Kartu discard top: '), write(Warna), write('-'), write(Jenis), write('.'), nl,
    nl,
    listPemain(1, ListPemain),
    write('Urutan pemain: '),
    printUrutan(ListPemain),
    write('.'), nl,
    nl,
    listHand(ListPemain, ListHand),
    infoPemain(ListPemain, ListHand, 1),!.

/*Ambil Kartu (Khusus buat ambil kartu biasa, jangan dipakai di tempat lain, kalau mau pakai pakai yg di gameLogic)*/
ambilKartu:-
    currentPlayer(Player),
    ambilKartuUmum(Player, 1, KartuNew),
    write(Player), 
    write(' mendapatkan kartu: '), nl,
    printAmbilKartu(KartuNew), nl,
    passTurn,
    currentPlayer(NextPlayer),
    write('Giliran '), write(NextPlayer), write('.'), nl.

/*Mainkan Kartu*/
ambilDariHand(0, [H|_], H).
ambilDariHand(NoKartu, [_|T], Temp) :-
    NoKartu > 0,
    N1 is NoKartu - 1,
    ambilDariHand(N1, T, Temp).

efekJenis(Y) :-
    Y == reverse,
    numPlayers(Max), 
    (Max > 2 ->
    efekReverse,
    efekSkip), 
    !.

efekJenis(Y) :-
    Y == skip, 
    efekSkip,
    !.

efekJenis(Y) :-
    Y == draw_two, 
    efekDrawTwo, !.

efekJenis(Y) :-
    Y == wild, 
    efekWild, !.

efekJenis(Y) :-
    Y == wild_draw_four, 
    efekWild,
    efekDrawFour, !.

efekJenis(_).

jadiTop(NewTop) :-
    discardPile(OldList),
    retract(discardPile(OldList)),
    NewList = [NewTop|OldList],
    assertz(discardPile(NewList)).

delete_element([_|Tail], 0, Tail).
delete_element([Head|Tail], Index, [Head|NewTail]) :-
    Index > 0,
    NewIndex is Index - 1,
    delete_element(Tail, NewIndex, NewTail).

buangDariHand(Index) :-
    currentPlayer(Player),
    cards(Player, Hand),
    delete_element(Hand, Index, NewHand),
    retract(cards(Player, Hand)),
    assertz(cards(Player, NewHand)).

mainkanKartu(NoKartu):-
    NoKartuRill is NoKartu - 1,
    currentPlayer(Player),
    cards(Player, Hand),
    ambilDariHand(NoKartuRill, Hand, kartu(Warna, Jenis)),
    (bisaDimainkan(Player, kartu(Warna, Jenis))->
    write(Player), write(' memainkan kartu: '), write(Warna), write('-'), write(Jenis), nl,
    jadiTop(kartu(Warna, Jenis)),
    buangDariHand(NoKartuRill),

    cards(Player, NewHand),
    (
        NewHand = []
        ->
        endGame
        ;
        efekJenis(Jenis),
        passTurn,
        currentPlayer(NextPlayer),
        write('Giliran '),
        write(NextPlayer),
        write('.'),
        nl,nl
    ),
    !
    ;
    write('Kartu tidak bisa dimainkan, ulangi atau ambil kartu.'), nl,
    !,
    fail).

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

/*tantang*/
cekdiLoop(_, []).
cekdiLoop(Player, [Head|Tail]) :-
	\+ bisaDimainkan(Player, Head),
	cekdiLoop(Player, Tail).

getLength([], 0).
getLength([_|Tail], Length) :-
	getLength(Tail, TailLength),
	Length is TailLength + 1.

cekGaAdaKartuYangBisaDimainin(Player, Hasil):-
	cards(Player, Hand),
	getLength(Hand, Length),
	( 
		cekdiLoop(Player, Hand)
			-> Hasil = 1
			; Hasil = 0
	).

tantang:-
	write('Tantangan dilakukan!'),
	nl,
	write('Memeriksa kartu '),
	currentPlayer(Player),
	write(Player),
	write('...'),
	nl,

	cekGaAdaKartuYangBisaDimainin(Player, Hasil),

	(
		Hasil = 1
		->
		write('Tantangan gagal. '),
		nl,
		passTurn,
		currentPlayer(NextPlayer),
		ambilKartuUmum(NextPlayer, 6, _),
		write(NextPlayer),
		write(' mendapatkan 6 kartu secara acak'),
		nl
		;
		write('Tantangan berhasil. '),
		nl,
		ambilKartuUmum(Player, 4, _),
		write(Player),
		write(' mendapatkan 4 kartu secara acak'),
		passTurn,
		currentPlayer(NextPlayer),
		nl
	).
