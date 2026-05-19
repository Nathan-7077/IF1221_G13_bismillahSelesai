:- include('startGame.pl').
:- include('handleEffect.pl').
:- include('main.pl').
:- include('util.pl').

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
    ;
    efekSkip), 
    jadiTop(kartu(Warna, Jenis)),
    !.

efekJenis(Y) :-
    Y == skip, 
    efekSkip,
    jadiTop(kartu(Warna, Jenis)),
    !.

efekJenis(Y) :-
    Y == draw_two, 
    efekDrawTwo, 
    jadiTop(kartu(Warna, Jenis)),
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
    NoKartuRill is NoKartu - 1;
    currentPlayer(Player),
    cards(Player, Hand),
    ambilDariHand(NoKartuRill, Hand, kartu(Warna, Jenis)),
    (bisaDimainkan(Player, kartu(Warna, Jenis))->
    write(Player), write('memainkan kartu: '), write(Warna), write('-'), write(Jenis), nl,
    buangDariHand(NoKartuRill),
    efekJenis(Jenis),
    passTurn,
    currentPlayer(NextPlayer),
    write('Giliran '), write(NextPlayer), nl
    ;
    write('Kartu tidak bisa dimainkan, ulangi atau ambil kartu.'), nl, 
    !,
    fail). 

