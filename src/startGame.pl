:- include('fakta.pl').
:- dynamic(player/1).
:- dynamic(listPlayer/1).
:- dynamic(hand/2).
:- dynamic(discardPile/1).
:- dynamic(currentPlayer/1).
:- dynamic(gameStarted/0).

/*Untuk mengambil kartu*/
findKartu(Temp, Goal, List):-
    findall(Temp, Goal, List).

/*Mulai Game*/
startGame:-
    retractall(player(_)),
    retractall(listPlayer(_)),
    retractall(hand(_, _)),
    retractall(discardPile(_)),
    retractall(currentPlayer(_)),
    retractall(gameStarted),
    inisialisasiPlayer,
    distribusiKartu,
    write('Setiap Pemain mendapatkan 7 kartu acak'), nl,
    inisialiasiDiscardPile,
    assertz(gameStarted),
    listPlayer([First|_]),
    assertz(currentPlayer(First)),
    write('Giliran '), write(First), nl.

/*Inisialisasi Pemain*/
inisialisasiPlayer:-
    write('Masukkan jumlah pemain: '),
    read(N),
    (
        integer(N), N>=2, N=<4->
        inputNamaPlayer(N, 1, Names),
        shuffle(Names, Shuffled),
        assertz(listPlayer(Shuffled)),
        write('Urutan pemain: '),
        writeList(Shuffled), write('.'), nl;
        write('Mohon masukkan angka antara 2-4.'), nl,
        inisialisasiPlayer

    ).

/*Validasi keunikan nama pemain*/
namaUnik(Name):-
    read(Tmp), 
    (
        player(Tmp)->
        write('Nama sudah digunakan. Masukkan nama lain: '),
        namaUnik(Name);
        Name=Tmp
    ).

inputNamaPlayer(0, _, []):- !.
inputNamaPlayer(N, Num, [Name|Sisa]):-
    N>0,
    write('Masukkan nama pemain '), write(Num), write(': '),
    namaUnik(Name),
    assertz(player(Name)),
    N1 is N-1,
    Num1 is Num+1,
    inputNamaPlayer(N1, Num1, Sisa).

/*Shuffle list (Buat shuffle pemain dan deck kartu)*/
shuffle([],[]).
shuffle(List, [Elem|Shuffled]):-
    length(List, Len),
    random(0, Len, Indeks),
    hapusElemen(Indeks, List, Elem, Sisa),
    shuffle(Sisa, Shuffled).

/*Penghapusan Elemen berdasarkan indeks*/
hapusElemen(0,[H|T], H, T):-!.
hapusElemen(N, [H|T], Elem, [H|Sisa]):-
    N>0,
    N1 is N-1,
    hapusElemen(N1, T, Elem, Sisa).
writeList([]):- !.
writeList([H]):- write(H), !.
writeList([H|T]):-
    write(H), write(' - '),
    writeList(T).

/*Distribusi Kartu*/
distribusiKartu:-
    findKartu(kartu(W,J),(warna(W), jenis(J)), Deck),
    shuffle(Deck, Shuffled),
    listPlayer(Players),
    ruleDistribusi(Players, Shuffled).
ruleDistribusi([], _).
ruleDistribusi([P|Ps], Deck):-
    length(Hand, 7),
    append(Hand, Sisa, Deck),
    assertz(hand(P, Hand)),
    ruleDistribusi(Ps, Sisa).

/*Discard Pile*/
inisialiasiDiscardPile:-
    findKartu(kartu(W,J), (warna(W), jenis(J), integer(J)), Numerik),
    length(Numerik, Len),
    random(0,Len,Indeks),
    hapusElemen(Indeks, Numerik, K, _),
    assertz(discardPile([K])),
    K= kartu(Warna, Jenis),
    write('Kartu discard top: '), write(Warna), write('-'), write(Jenis), nl.

/*Validasi Kartu*/
/*Aturan-Aturan Umum*/
kartuValid(kartu(wild, drawFour), kartu(wild, drawFour)):- !, fail.
kartuValid(kartu(_, drawTwo), kartu(_, drawTwo)):- !, fail.
kartuValid(kartu(Color,_), kartu(Color,_)):- !.
kartuValid(kartu(_, Type), kartu(_, Type)):-
    Type \= wild,
    Type \= drawFour, !.
kartuValid(kartu(wild,_), _):- !.

/*Aturan Khusus untuk wild draw four*/
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
    
