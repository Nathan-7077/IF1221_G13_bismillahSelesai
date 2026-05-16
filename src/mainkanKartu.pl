:- include('startGame.pl').
:- include('handleEffect.pl').
:- dynamic(mainkanKartu/2).

ambilDariDeck(0, [H|], Kartu).
ambilDariDeck(NoKartu, [|T], Temp) :-
    NoKartu > 0,
    N1 is NoKartu - 1,
    ambilDariDeck(N1, T, Temp).

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

mainkanKartu(NoKartu):-
    ReakNoKartu is NoKartu - 1,
    currentPlayer(Player),
    ambilDariDeck(RealNoKartu, Deck, Kartu),
    bisaDimainkan(Kartu),
    kartu(X, Y) = Kartu,
    write(Player), write('memainkan kartu: '), write(X), write('-'), write(Y), 
    efekJenis(Y),
    passTurn,
    currentPlayer(Player),
    write('Giliran '), write(Player). 

