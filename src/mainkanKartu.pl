:- include('startGame.pl').
:- include('handleEffect.pl').
:- include('main.pl').

ambilDariHand(1, [H|_], H).
ambilDariHand(NoKartu, [_|T], Temp) :-
    NoKartu > 1,
    N1 is NoKartu - 1,
    ambilDariHand(N1, T, Temp).

efekJenis(Y) :-
    Y == reverse, 
    efekReverse,
    write('Urutan pemain dibalik!'), !.

efekJenis(Y) :-
    Y == skip, 
    efekSkip,
    write('Pemain berikutnya kehilangan giliran'), !.

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

buangDariHand :-


mainkanKartu(NoKartu):-
    currentPlayer(Player),
    cards(Player, Hand),
    ambilDariHand(NoKartu, Hand, kartu(Warna, Jenis)),
    (bisaDimainkan(Player, kartu(Warna, Jenis))->
    write(Player), write('memainkan kartu: '), write(Warna), write('-'), write(Jenis), nl,
    efekJenis(Jenis),
    jadiTop(kartu(Warna, Jenis)),
    buangDariHand(kartu(Warna, Jenis)),
    passTurn,
    currentPlayer(NextPlayer),
    write('Giliran '), write(Player), nl
    ;
    write('Kartu tidak bisa dimainkan, ulangi atau ambil kartu.'), nl). 

