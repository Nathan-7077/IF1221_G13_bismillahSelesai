:- include('startGame.pl').
kartuValid(kartu(wild,_), _).
kartuValid(kartu(Color,_), kartu(Color,_)).
kartuValid(kartu(_, Type), kartu(_, Type)) :-
    Type \= wild,
    Type \= draw_four.
cekWDF(Hand, Top) :-
    \+ (
        member(Card, Hand),
        Card \= kartu(wild, draw_four),
        kartuValid(Card, Top)
    ).
bisaDimainkan(Player, Card):-
    currentPlayer(Player),
    hand(Player, Hand),
    member(Card, Hand),
    discardPile([Top|_]),
    (
        Card = kartu(wild, draw_four) ->
            cekWDF(Hand, Top)
        ;
            kartuValid(Card, Top)
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
