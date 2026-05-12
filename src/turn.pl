:- include('startGame.pl').
playable(kartu(wild,_), _).
playable(kartu(Color,_), kartu(Color,_)).
playable(kartu(_, Type), kartu(_, Type)):-
    Type \= wild,
    Type \= draw_four.
kartuValid(kartu(wild, draw_four), Top):-
    playable(kartu(wild, draw_four), Top), !.
kartuValid(kartu(_, draw_two), kartu(_, draw_two)) :- !, fail.
kartuValid(kartu(Color,_), kartu(Color,_)):- !.
kartuValid(kartu(_, Type), kartu(_, Type)):-
    Type \= wild,
    Type \= draw_four, !.
kartuValid(kartu(wild,_), _):- !.
cekWDF(Hand, Top) :-
    \+ (
        member(Card, Hand),
        playable(Card, Top)
    ).
bisaDimainkan(Player, Card):-
    currentPlayer(Player),
    hand(Player, Hand),
    member(Card, Hand),
    discardPile([Top|_]),
    kartuValid(Card, Top),
    (
        Card = kartu(wild, draw_four) ->
            cekWDF(Hand, Top);
            true
    ).
printUrutan([]).
printUrutan([H|[]]) :-
    write(H), printUrutan(T).
printUrutan([H|T]) :-
    write(H), write(' - '),
    printUrutan(T).

infoPemain([],[]).
infoPemain([H|T],[A|B]) :-
    write('Nama Pemain '), write(': '), write(H), nl,
    write('Jumlah Kartu : '), write(A), nl,
    infoPemain(T,B).

cekInfo:-
    write(kartuAtas(Warna, Jenis)), nl,
    printUrutan([]), nl,
    infoPemain([],[]).
