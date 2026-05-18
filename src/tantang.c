tantang:-
	write('Tantangan dilakukan!'),
	write('Memeriksa kartu '),
	/* ngambil player giliran sebelumnya -> write(P),*/
	write('...'),
	(
		/* predikat buat ngecek apakah pemain yang ditantang itu beneran tidak punya kartu lain yang bisa dimainkan */
		->
		/* nambah 4 kartu di tangan dari random -> assertz(Warna, Jenis), */
		write('Tantangan berhasil. '),
		/* ngambil player giliran sekarang -> write(P), */
		write(' mendapatkan 4 kartu secara acak').
		;
		/* nambah 6 kartu di tangan dari random -> assertz(Warna, Jenis), */
		write('Tantangan gagal. '),
		/* ngambil player giliran sekarang -> write(P), */
		write(' mendapatkan 6 kartu secara acak')
	).
