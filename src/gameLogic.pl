:- include('player.pl').
:- include('utils.pl').

kartuValid(kartu(hitam, wild),_).
kartuValid(kartu(hitam, wild_draw_four), _).
%kartuValid(kartu(hitam, mimic), _). Nyiapin doang buat entar
kartuValid(kartu(Color, _), kartu(Color, _)):-
    Color\=hitam.
kartuValid(kartu(_, Type), kartu(_, Type)):-
    Type \=wild,
    Type \= wild_draw_four.
%Type \= mimic. klo mau pake
%Cek WDF kuilangin, soalnya ternyata bisa dimainkan, cuma kalau dimainkan pemain selanjutnya bisa nantang (sebelumnya di startGame tulisannya gabisa soalnya, baru ngecek td di kelas alpro ternyata dibutuhin buat mekanik tantang)
bisaDimainkan(Player, Card):-
    currentPlayer(Player),
    cards(Player, Hand),
    member(Card, Hand),
    discardPile([Head|_]),
    kartuValid(Card, Head).

/*Ambil Kartu Umum*/
ambilKartuUmum(Player, N, KartuNew):-
    cards(Player, HandPrev),
    findKartu(kartu(W,J), kartu(W, J), Deck),
    shuffle(Deck, Shuffled),
    helperAmbil(N, Shuffled, KartuNew),
    tambahKartu(HandPrev, KartuNew, HandAfter),
    retract(cards(Player, HandPrev)),
    assertz(cards(Player, HandAfter)).


tambahKartu(Hand, [], Hand):-!.
tambahKartu(Hand, [Head|Tail], Hasil):-
    appendElement(Hand, Head, HandNew),
    tambahKartu(HandNew, Tail, Hasil).

printAmbilKartu([]).
printAmbilKartu([kartu(Warna, Jenis)|Sisa]):-
    write('- '), write(Warna), write('-'), write(Jenis), nl,
    printAmbilKartu(Sisa).
helperAmbil(0, _, []):-!.
helperAmbil(N, [H|T], [H|Sisa]):-
        N>0,
        N1 is N-1,
        helperAmbil(N1, T, Sisa).

/* Tantang */
cekdiLoop(_, []).
cekdiLoop(Player, [Head|Tail]) :-
	\+ bisaDimainkan(Player, Head),
	cekdiLoop(Player, Tail).

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

/* Tangkap */
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

tangkapPlayer(PlayerTuduh):-
	(
		cekKartuTinggalSatu(PlayerTuduh), cekPlayerNggaUni(PlayerTuduh, Hasil), Hasil == 1
		->
		ambilKartuUmum(PlayerTuduh, 1, _),
		write(PlayerTuduh),
		write(' ditangkap!, kartu '),
		write(PlayerTuduh),
		write(' bertambah satu')
		;
		write('Tidak bisa menangkap '),
		write(PlayerTuduh),
		nl,
		currentPlayer(CurrPlayer),
		write(CurrPlayer),
		write(' mendapat 1 kartu penalti'),
		nl,
		ambilKartuUmum(CurrPlayer, 1, _),
		passTurn,
		currentPlayer(NextPlayer),
    		write('Giliran '), 
		write(NextPlayer), 
		nl
	).

/*Handle Effect*/
/* balik(List, Hasil) :- 
    balik(List, [], Hasil).

balik([], B, B).
balik([H|T], B, Hasil) :- 
    balik(T, [H|B], Hasil). */

balikUrutan(Max, Max) :-
    playerOrder(Max, Current),
    !,
    retract(playerOrder(Max, Current)),
    assertz(playerOrder(1, Current)).

balikUrutan(Index1, Max) :- 
    Index1 < Max, 
    N is Max - Index1 + 1,
    playerOrder(Index1, Current),
    !,
    retract(playerOrder(Index1, Current)),
    assertz(playerOrder(N, Current)),
    NextIndex is Index1 + 1,
    balikUrutan(NextIndex, Max).


efekReverse :- 
    numPlayers(Max),
    balikUrutan(1, Max),
    write('Urutan pemain dibalik!'), nl.

efekSkip :- 
    passTurn,
    write('Pemain berikutnya kehilangan giliran'), nl.

efekDrawTwo :-
    currentPlayer(Current),
    getNextPlayer(Current, NextPlayer),
    ambilKartuUmum(NextPlayer, 2, _),
    efekSkip.

efekWild :- 
    write('Pilih warna kartu yang diinginkan: '), 
    read(WarnaNew), 
    discardPile([kartu(_, Jenis)|_]),
    jadiTop(kartu(WarnaNew, Jenis)),
    write('Kartu paling atas sekarang berwarna '), write(WarnaNew).

efekDrawFour :-
    currentPlayer(Current),
    getNextPlayer(Current, NextPlayer),
    ambilKartuUmum(NextPlayer, 4, _),
    efekSkip.
