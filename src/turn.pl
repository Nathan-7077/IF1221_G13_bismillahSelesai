:- include('startGame.pl').
kartuValid(kartu(wild, drawFour), kartu(wild, drawFour)):- !, fail.
kartuValid(kartu(_, drawTwo), kartu(_, drawTwo)):- !, fail.
kartuValid(kartu(Color,_), kartu(Color,_)):- !.
kartuValid(kartu(_, Type), kartu(_, Type)):-
    Type \= wild,
    Type \= drawFour, !.
kartuValid(kartu(wild,_), _):- !.

cekWDF(Hand, kartu(CurrentColor, CurrentType)):-
    \+(
        member(kartu(Color, Type), Hand),
        Color \= wild,
        (
            Color=CurrentColor;
            Type=CurrentType
        )
    ).
    
bisaDimainkan(Player, Card):-
    currentPlayer(Player),
    hand(Player, Hand),
    member(Card, Hand),
    discardPile([Top|_]),
    kartuValid(Card, Top),
    (
        Card=kartu(wild, drawFour)->
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
