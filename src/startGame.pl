:- include('fakta.pl').
:- dynamic(player/1).
:- dynamic(listPlayer/1).
:- dynamic(hand/2).
:- dynamic(discardPile/1).
:- dynamic(currentPlayer/1).
:- dynamic(gameStarted/0).
:- dynamic(tempFind/1).

/*Mengambil Kartu dengan spesifikasi tertentu*/
findKartu(Template, Goal, List) :-
    retractall(tempFind(_)),
    (
        Goal,
        assertz(tempFind(Template)),
        fail;
        true
    ),
    ambilHasil(List),
    retractall(tempFind(_)).
ambilHasil(List):-
    ambilHasilHelper([], List).
ambilHasilHelper(Acc, List):-
    retract(tempFind(X)), !,
    append(Acc, [X], NewAcc),
    ambilHasilHelper(NewAcc, List).
ambilHasilHelper(List, List).

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
    inisialisasiDiscardPile,
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
inisialisasiDiscardPile:-
    findKartu(kartu(W,J), (warna(W), jenis(J), integer(J)), Numerik),
    length(Numerik, Len),
    random(0,Len,Indeks),
    hapusElemen(Indeks, Numerik, K, _),
    assertz(discardPile([K])),
    K= kartu(Warna, Jenis),
    write('Kartu discard top: '), write(Warna), write('-'), write(Jenis), nl.
    
