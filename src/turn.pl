:-include('gameLogic.pl').
:- dynamic(playerBilangUni/1).

/*Yang tentang info2 dalam game*/
lihatCommand:-
    write('Aksi utama yang tersedia:'),nl,
    write('1. ambilKartu'), nl,
    write('2. mainkanKartu'), nl,
    write('3. tantang'), nl,
    write('4. uni'), nl,
    write('5. tampilkanKartu'), nl,
	write('6. sembunyikanKartu'), nl,
  	
    write('Aksi pendukung yang tersedia:'),nl,
    write('1. lihatCommand'),nl,
    write('2. lihatKartu'),nl,
    write('3. cekInfo'),nl,
	write('4. tangkap'), nl.
	
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
cekHidden(Player, Jumlah, JumlahTampil):-
    kartuHidden(Player,_),!,
    JumlahTampil is Jumlah-1.
infoPemain([],[],_):-!.
infoPemain([H|T],[A|B], Indeks) :-
    hitungKartu(A, Jumlah),
    (kartuHidden(H, _)->
    JumlahTampil is Jumlah-1;
    JumlahTampil is Jumlah),
    write('Nama Pemain '), write(Indeks), write(': '), write(H), nl,
    write('Jumlah Kartu : '), write(JumlahTampil), nl,nl,
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
    write('Giliran '), write(NextPlayer), write('.'), nl, !.

/*Mainkan Kartu*/
ambilDariHand(0, [H|_], H).
ambilDariHand(NoKartu, [_|T], Temp) :-
    NoKartu > 0,
    N1 is NoKartu - 1,
    ambilDariHand(N1, T, Temp).

jadiTop(NewTop) :-
    discardPile(OldList),
    retract(discardPile(OldList)),
    NewList = [NewTop|OldList],
    assertz(discardPile(NewList)).

efekJenis(Y) :-
    Y == reverse,
    numPlayers(Max), 
    (Max > 2 ->
    efekReverse
    ;
    efekSkip), 
    !.

efekJenis(Y) :-
    Y == skip, 
    efekSkip,
    !.

efekJenis(Y) :-
    Y == draw_two, 
    efekDrawTwo, 
    !.

efekJenis(Y) :-
    Y == wild, 
    efekWild, !.

efekJenis(Y) :-
    Y == wild_draw_four, 
    efekWild,
    efekDrawFour, !.

efekJenis(Y) :-
    Y == mimic,
    efekMimic,
    efekWild,
    !.

efekJenis(_).

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
    buangDariHand(NoKartuRill),
    retractall(kartuHidden(Player, kartu(Warna, Jenis))),
    jadiTop(kartu(Warna, Jenis)),
    efekJenis(Jenis),
    passTurn,
    currentPlayer(NextPlayer),
    write('Giliran '), write(NextPlayer), nl,
    !
    ;
    write('Kartu tidak bisa dimainkan, ulangi atau ambil kartu.'), nl, 
    !). 

/* Mainkan kartu dan uni */
uni(NoKartu):-
    currentPlayer(Player),
    (
        NoKartuRill is NoKartu - 1,
        cards(Player, Hand),
        ambilDariHand(NoKartuRill, Hand, kartu(Warna, Jenis)),
        (
            bisaDimainkan(Player, kartu(Warna, Jenis))
            ->
            (
                cekKartuTinggalDua(Player)
                ->
                write(Player),
                write(' memainkan kartu: '),
                write(Warna),
                write('-'),
                write(Jenis),
                nl, nl,
                jadiTop(kartu(Warna, Jenis)),
                buangDariHand(NoKartuRill),
                retractall(kartuHidden(Player, kartu(Warna, Jenis))),
                write(Player),
                write(' menyerukan UNI!'),
                nl,
                assertz(playerBilangUni(Player)),
                efekJenis(Jenis),
                passTurn,
                currentPlayer(NextPlayer),
                write('Giliran '),
                write(NextPlayer),
                write('.'),
                nl, nl,
                lihatKartuTop, !
                ;
                write(Player),
                write(' memainkan kartu: '),
                write(Warna),
                write('-'),
                write(Jenis),
                nl, nl,
                jadiTop(kartu(Warna, Jenis)),
                buangDariHand(NoKartuRill),
                write(Player),
                write(' masih memiliki kartu lebih dari 2!'),
                nl,
                write(Player),
                write(' mendapatkan 1 kartu penalti.'),
                nl, nl,
                ambilKartuUmum(Player, 1, KartuNew),
                write(Player), 
                write(' mendapatkan:'), nl,
                printAmbilKartu(KartuNew), nl,
                efekJenis(Jenis),
                passTurn,
                currentPlayer(NextPlayer),
                write('Giliran '),
                write(NextPlayer),
                write('.'),
                nl, nl,
                lihatKartuTop,
                !
            )
            ;
            write('Kartu tidak bisa dimainkan, mainkan kartu lain atau ambil kartu'),
            nl, nl,
            lihatKartuTop,
            nl,
            !
        )
    ).

/*tantang*/
kartuCocokDenganTop(KartuPlayer):-
    discardPile([K|_]),
    K=kartu(Warna1, Jenis1),
    KartuPlayer=kartu(Warna2, Jenis2),
    (Warna1 == Warna2 ; Jenis1 == Jenis2 ; Warna2 == hitam).

cekdiLoop([]):- !.
cekdiLoop([Head|Tail]) :-
	\+ kartuCocokDenganTop(Head),
	cekdiLoop(Tail).

cekGaAdaKartuYangBisaDimainin(Player, Hasil):-
	cards(Player, Hand),
	getLength(Hand, Length),
	( 
		cekdiLoop(Hand)
			-> Hasil = 1
			; Hasil = 0
	).

tantang:-
    discardPile([_, K|_]),
    K=kartu(Warna, Jenis),
    getBeforePlayer(BeforePlayer), 
    (
        Jenis == wild_draw_four, bisaDitantang(BeforePlayer)
        ->
        write('Tantangan dilakukan!'), nl,
        write('Memeriksa kartu '),
        write(BeforePlayer),
        write('...'), nl,
        currentPlayer(Player),
        cekGaAdaKartuYangBisaDimainin(BeforePlayer, Hasil),
        (
            Hasil == 1
            ->
            retractall(bisaDitantang(_)),
            write('Tantangan gagal.'), nl,
            ambilKartuUmum(Player, 6, KartuNew),
            write(Player),
            write(' mendapatkan 6 kartu penalti.'), nl,
            write('Kartu yang didapat:'),
            printAmbilKartu(KartuNew), nl, !
            ;
            retractall(bisaDitantang(_)),
            write('Tantangan berhasil.'), nl,
            ambilKartuUmum(BeforePlayer, 4, KartuNew),
            write(BeforePlayer),
            write(' mendapatkan 4 kartu penalti.'), nl, nl,
            write('Kartu yang didapat:'), nl,
            printAmbilKartu(KartuNew), nl, !
        )
        ;
        write('Tantang tidak bisa dilakukan.'), nl,
        write('Pemain sebelumnya tidak mengeluarkan Wild Draw Four.'), nl, !
    ).
    

/* Tangkap */
cekKartuTinggalSatu(Player):-
	cards(Player, Hand),
	getLength(Hand, Length),
	Length is 1.

cekPlayerNggaUni(Nama, Hasil):-
	(
		playerBilangUni(Nama)
		->
		Hasil is 0
		;
		Hasil is 1
	).
tangkap(PlayerTuduh):-
        kartuHidden(PlayerTuduh, _),!,
        write('Terdapat kartu yang disembunyikan oleh '), write(PlayerTuduh), nl,
        write('Perintah tangkap tidak valid. '),
        currentPlayer(CurrPlayer),
        write(CurrPlayer), write(' mendapatkan 1 kartu penalti'), nl,
        ambilKartuUmum(CurrPlayer, 1, _),
        passTurn,
        currentPlayer(NextPlayer),
        write('Giliran '), write(NextPlayer), write('.'),nl.

tangkap(PlayerTuduh):-
    cekPlayerNggaUni(PlayerTuduh, Hasil),
	(
		cekKartuTinggalSatu(PlayerTuduh), Hasil =:= 1
        ->
        ambilKartuUmum(PlayerTuduh, 2, _),
        write(PlayerTuduh),
        write(' ditangkap!, kartu '),
        write(PlayerTuduh),
        write(' bertambah dua'),
        !
        ;
        write('Tidak bisa menangkap '),
        write(PlayerTuduh),
        nl,
        currentPlayer(CurrPlayer),
        write(CurrPlayer),
        write(' mendapat 1 kartu penalti'),
        nl,
        ambilKartuUmum(CurrPlayer, 1, _), !
	).
/*sembunyikanKartu*/
sembunyikanKartu(NomorUrut):-
    currentPlayer(Player),
    (kartuHidden(Player,_)->
    write('Anda telah menyembunyikan kartu'),nl,fail;true),
    cards(Player, Hand),
    getLength(Hand, Len),
    (Len=<1->
    write('Gagal menyembunyikan kartu'),nl,fail;true),
    NoKartuRill is NomorUrut-1,
    (ambilDariHand(NoKartuRill, Hand, Kartu)->true;
    write('Nomor kartu tidak valid'),nl,fail),
    assertz(kartuHidden(Player, Kartu)),
    Kartu=kartu(Warna, Jenis),
    write('kartu '), write(Warna), write('-'), write(Jenis), write(' berhasil disembunyikan.'),nl,
	passTurn,
    currentPlayer(NextPlayer),
    write('Giliran '), write(NextPlayer), write('.'), nl,!.
sembunyikanKartu(_):-
    write('Gagal menyembunyikan kartu'),nl.
	
/*tampilkanKartu*/
tampilkanKartu:-
    currentPlayer(Player),
    (kartuHidden(Player, Kartu)->true;
	write('Tidak ada kartu yang sedang disembunyikan'),nl,fail),
	retract(kartuHidden(Player, _)),
	write('Kartu tersembunyi ditampilkan kembali'), nl,
    passTurn,
    currentPlayer(NextPlayer),
    write('Giliran '), write(NextPlayer),nl,!.
tampilkanKartu:-
    write('Gagal menampilkan kartu tersembunyi.'),nl.
