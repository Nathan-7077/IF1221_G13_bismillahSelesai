:-include('card.pl').
%Untuk mengambil kartu
findKartu(Template, Goal, List) :-
    retractall(tempFind(_)),
    (
        Goal,
        assertz(tempFind(Template)),
        fail
        ;
        true
    ),
    ambilHasil(List),
    retractall(tempFind(_)).

ambilHasil(List):-
    ambilHasilHelper([],List).

ambilHasilHelper(Acc,List):-
    retract(tempFind(X)), !,
    append(Acc,[X],NewAcc),
    ambilHasilHelper(NewAcc,List).
ambilHasilHelper(List,List).

/* Shuffle */
shuffle([],[]).

shuffle(List,[Elem|Shuffled]):-
    getLength(List,Len),
    random(0,Len,Indeks),
    deleteElement(Indeks,List,Elem,Sisa),
    shuffle(Sisa,Shuffled).

%yang dari Handbook
getIndex([_|Tail], Index, Element):-
    Index>0,
    NewIndex is Index-1,
    get_index(Tail, NewIndex, Element).
getIndex([Element|_], 0, Element).

getElement([Element|_], 0, Element).
getElement([_|Tail], Index, Element):-
    Index>0,
    NewIndex is Index-1,
    getElement(Tail, NewIndex, Element).

appendElement([], Element, [Element]).
appendElement([Head|Tail], Element, [Head|NewTail]):-
    appendElement(Tail, Element, NewTail).

getLength([], 0).
getLength([_|Tail], Length):-
    getLength(Tail, TailLength),
    Length is TailLength+1.

updateElement([_|Tail], 0, NewElement, [NewElement|Tail]).
updateElement([Head|Tail], Index, NewElement, [Head|UpdatedTail]):-
    Index>0,
    NewIndex is Index-1,
    updateElement(Tail, NewIndex, NewElement, UpdatedTail).
    
deleteElement(0,[H|T],H,T):- !.
deleteElement(N,[H|T],Elem,[H|Sisa]):-
    N>0,
    N1 is N-1,
    deleteElement(N1,T,Elem,Sisa).

reverseList(List, Reversed):-
    reverseHelper(List, [], Reversed).
reverseHelper([], Accumulator, Accumulator).
reverseHelper([Head|Tail], Accumulator, Reversed):-
    reverseHelper(Tail, [Head|Accumulator], Reversed).

cekKartuTinggalDua(Player):-
	cards(Player, Hand),
	getLength(Hand, Length),
	Length is 2.
