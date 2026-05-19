:- include('card.pl').
:- include('player.pl').

:- dynamic(discardPile/1).
:- dynamic(gameStarted/0).
:- dynamic(tempFind/1).

/* Mengambil Kartu dengan spesifikasi tertentu */
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
    appendElement(Acc,[X],NewAcc),
    ambilHasilHelper(NewAcc,List).
ambilHasilHelper(List,List).


/* Mulai Game */
startGame:-

    retractall(player(_)),
    retractall(cards(_,_)),
    retractall(points(_,_)),
    retractall(currentPlayer(_)),
    retractall(playerOrder(_,_)),
    retractall(numPlayers(_)),
    retractall(discardPile(_)),
    retractall(gameStarted),

    inisialisasiPlayer,
    distribusiKartu,
    write('Setiap pemain mendapatkan 7 kartu acak.'),nl,nl,

    inisialisasiDiscardPile,
    assertz(gameStarted),
    currentPlayer(First),
    write('Giliran '),
    write(First),
    write('.'),
    nl.

/* Inisialisasi Pemain */
inisialisasiPlayer:-

    inputNumPlayersValid,
    inputPlayersValid,
    shufflePlayers,
    initializeFirstPlayer.

/* Validasi jumlah pemain */
inputNumPlayersValid:-

    write('Masukkan jumlah pemain: '),
    read(N),
    (
        integer(N),
        N>=2,
        N=<4
        ->
        assertz(numPlayers(N))
        ;
        write('Mohon masukkan angka antara 2 - 4.'),nl,nl,

        inputNumPlayersValid
    ).



/* Input nama */
inputPlayersValid:-
    numPlayers(N),
    inputPlayersLoop(1,N).

inputPlayersLoop(I,N):-
    I>N,!.

inputPlayersLoop(I,N):-
    write('Masukkan nama pemain '),
    write(I),
    write(': '),
    read(Name),
    (
        player(Name)
        ->
        write('Nama sudah digunakan. Masukkan nama lain: '),

        read(NewName),

        assertz(player(NewName)),
        assertz(cards(NewName,[])),
        assertz(points(NewName,0))
        ;

        assertz(player(Name)),
        assertz(cards(Name,[])),
        assertz(points(Name,0))
    ),

    I2 is I+1,

    inputPlayersLoop(I2,N).



/* Shuffle pemain */
shufflePlayers:-
    findall(P,player(P),Players),
    shuffle(Players,Shuffled),
    assignPlayerOrder(Shuffled,1),

    write(nl),
    write('Urutan pemain: '),
    writeList(Shuffled),
    write('.'),
    nl,nl.

assignPlayerOrder([],_) :- !.
assignPlayerOrder([P|Ps],I):-
    assertz(playerOrder(I,P)),
    I2 is I+1,
    assignPlayerOrder(Ps,I2).

/* Shuffle */
shuffle([],[]).

shuffle(List,[Elem|Shuffled]):-
    getLength(List,Len),
    random(0,Len,Indeks),
    hapusElemen(Indeks,List,Elem,Sisa),
    shuffle(Sisa,Shuffled).

hapusElemen(0,[H|T],H,T):- !.

hapusElemen(N,[H|T],Elem,[H|Sisa]):-
    N>0,
    N1 is N-1,
    hapusElemen(N1,T,Elem,Sisa).

writeList([]):-!.
writeList([H]):-write(H),!.
writeList([H|T]):-
    write(H),
    write(' - '),
    writeList(T).

/* Distribusi kartu */
distribusiKartu:-
    findKartu(
        kartu(W,J),
        kartu(W,J),
        Deck
    ),
    shuffle(Deck,Shuffled),

    distribusiPlayer(1,Shuffled).

distribusiPlayer(I,_):-
    numPlayers(N),
    I>N,!.

distribusiPlayer(I,Deck):-
    playerOrder(I,P),
    getLength(Hand,7),
    append(Hand,Sisa,Deck),
    retract(cards(P,_)),
    assertz(cards(P,Hand)),

    I2 is I+1,
    distribusiPlayer(I2,Sisa).

/* Discard pile */
inisialisasiDiscardPile :-
    findKartu(
        kartu(W,J),
        kartu(W,J),
        Deck
    ),
    Deck \=[],
    getLength(Deck,Len),
    random(0,Len,Indeks),
    hapusElemen(Indeks,Deck,K,_),
    retractall(discardPile(_)),
    assertz(discardPile([K])),
    K=kartu(Warna,Jenis),
    write('Kartu discard top: '),
    write(Warna),
    write('-'),
    write(Jenis),
    write('.'),
    nl,nl.
