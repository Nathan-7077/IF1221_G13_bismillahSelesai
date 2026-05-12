:- include('card.pl').
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
