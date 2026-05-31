:- include('player.pl').
:- include('utils.pl').

:- dynamic(bisaDitantang/1).

kartuValid(kartu(hitam, wild),_).
kartuValid(kartu(hitam, wild_draw_four), _).
kartuValid(kartu(hitam, mimic), _). 
kartuValid(kartu(Color, _), kartu(Color, _)):-
    Color\=hitam.
kartuValid(kartu(_, Type), kartu(_, Type)):-
    Type \=wild,
    Type \= wild_draw_four,
    Type \= mimic.
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
    write('-> '), write(Warna), write('-'), write(Jenis), nl,
    printAmbilKartu(Sisa). 

helperAmbil(0, _, []):-!.
helperAmbil(N, [H|T], [H|Sisa]):-
        N>0,
        N1 is N-1,
        helperAmbil(N1, T, Sisa).

/* Handle Effect */
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

efekTerakhir([], 0).
efekTerakhir([kartu(_, Jenis)|Tail], Hasil) :-
    (Jenis == reverse ->
    efekReverse, 
    Hasil = 1,
    ! 
    ;
    Jenis == skip ->
    efekSkip, 
    Hasil = 1,
    !
    ;
    Jenis == draw_two ->
    efekDrawTwo,
    Hasil = 1,
    !
    ;
    efekTerakhir(Tail, Hasil)).

efekReverse :- 
    numPlayers(Max),
    balikUrutan(1, Max),
    write('Urutan pemain dibalik!'), nl.

efekSkip :- 
    passTurn,
    write('Pemain berikutnya kehilangan giliran'), nl.

efekDrawTwo :-
    passTurn,
    currentPlayer(NextPlayer),
    ambilKartuUmum(NextPlayer, 2, KartuNew),
    write(NextPlayer), write(' mendapatkan 2 kartu.'), nl,
    write('Kartu yang didapat:'), nl,
    printAmbilKartu(KartuNew), nl.

efekWild :- 
    write('Pilih warna kartu yang diinginkan (hijau/kuning/biru/merah): '), 
    read(WarnaNew), 
    discardPile([K|_]),
    K=kartu(Warna, Jenis), 
    jadiTop(kartu(WarnaNew, Jenis)),
    write('Kartu paling atas sekarang berwarna '), write(WarnaNew), nl.

efekDrawFour :-  
    currentPlayer(Player),
    retractall(bisaDitantang(_)),
    assertz(bisaDitantang(Player)),
    passTurn,
    currentPlayer(NextPlayer),
    nl, write('Giliran '),
    write(NextPlayer), nl, nl,
    write('Tantang '), write(Player), write(' (ya/tidak)? '),
    read(Konfirmasi),
    (
        Konfirmasi == ya
        ->
        tantang
        ;
        Konfirmasi == tidak
        ->
        retractall(bisaDitantang(_)),
        ambilKartuUmum(NextPlayer, 4, KartuNew),
        nl, write(NextPlayer),
        write(' mendapatkan 4 kartu.'), nl,
        write('Kartu yang didapat:'), nl,
        printAmbilKartu(KartuNew)
    ).
    

efekMimic :-
    discardPile(Discard),
    efekTerakhir(Discard, Hasil), 
    (Hasil == 1 ->
    write('Efek mimic aktif'), nl).