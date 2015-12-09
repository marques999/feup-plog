:-use_module(library(clpfd)).

verifyHead([],[],_).
verifyHead([H|T],[P|C],ComprimentoLista):-
		verifyHead_aux(H,P,ComprimentoLista),
		verifyHead(T,C,ComprimentoLista).

%(1)lista de C1,C2,C3...
%(2)lista de comando (numero de pecas pretas)
%(3)largura do tabuleiro

verifyHead_aux(L,T,ComprimentoLista):-
		sum(T,#=,NumeroDePecas),
		OutrasPecas #= ComprimentoLista - NumeroDePecas,
		global_cardinality(L,[0-OutrasPecas, 1-NumeroDePecas]).

verifyHeadWhite([],[],_).
verifyHeadWhite([H|T],[P|C],ComprimentoLista):-
		verifyHead_auxWhite(H,P,ComprimentoLista),
		verifyHeadWhite(T,C,ComprimentoLista).

%(1)lista de C1,C2,C3...
%(2)lista de comando (numero de pecas brancas)
%(3)largura do tabuleiro

verifyHead_auxWhite(L,T,ComprimentoLista):-
		sum(T,#=,NumeroDePecas),
		OutrasPecas #= ComprimentoLista - NumeroDePecas,
		global_cardinality(L,[1-OutrasPecas, 0-NumeroDePecas]).

verifyColumnSizes([],_).
verifyColumnSizes([H|T],Size):-
		sum(H,#=,Val),
		length(H, Val2),
		Val4 #= Val2 - 1,
		Val3 #= Val + Val4,
		Size #>= Val3,
		verifyColumnSizes(T,Size).

adjacentTester([_],[]).
adjacentTester([X,Y|T] , [B|Bs]):-
		(X #= 1 #/\ Y #= 0) #<=> B,
		adjacentTester([Y|T],Bs).

verifyBlock_aux(_,0).
verifyBlock_aux(L,Lacunas):-
		Lacunas > 0,
	adjacentTester(L,B),
		count(Lacunas,B,#=,1).
	%length(B,SizeB),
	%Complement is SizeB - Lacunas,
	%global_cardinality(B,[1-Lacunas]).

%1. board
%2. black squares
verifyBlock([],[]).
verifyBlock([H|T], [P|C]):-
	length(P,ComprimentoDaLista),
		NumeroDeLacunas is ComprimentoDaLista - 1,
	nl,nl,write(H),
		verifyBlock_aux(H,NumeroDeLacunas),
		verifyBlock(T,C).

analisaHead_aux(_,0).
analisaHead_aux([H|T],ValInicial):-
		Val2 is ValInicial - 1,
		analisaHead_aux([H|T],Val2).


analisaHead(_,[]).
analisaHead(L,[P|C]):-
		analisaHead_aux(L,P),
		analisaHead(L,C).


isElement([],_).
isElement([H|T],[P|C]):-
		analisaHead(H,P),
		isElement(T,C).

verifyAreas_aux([],[]).
verifyAreas_aux([H|T],[H|ListaRet]):-
		H #= 0,
		verifyAreas_aux(T,ListaRet).


verifyAreas([]).

verifyAreas([H|T]):-
		verifyAreas_aux(H,[]),
		verifyAreas(T).

scanWhite(List,Result):-
		scanList(List,0,isWhite,Result).

isWhite(Arg):- Arg #= 0.
isBlack(Arg):- Arg #= 1.

is_neighbour(From, To):-
		FromX #= From // 7, FromY #= From mod 7,
		ToX #= To // 7 , ToY #= To mod 7,
		((ToX #\= FromX) #/\ (ToY #= FromY #/\ abs(FromX - ToX) #= 1 )) #\/ ((ToY #\= FromY) #/\ (ToX #= FromX #/\ abs(FromY - ToY) #= 1)).

scanList([], _Position, _Predicate, []).

scanList([H|T], Position, Predicate, [Position|Lista]):-
		call(Predicate,H),
		Next #= Position + 1,
		scanList(T, Next, Predicate, Lista).

scanList([_H|T],Position, Predicate, Lista):-
		Next #= Position + 1,
		scanList(T, Next, Predicate, Lista).

trans([[H|T] |Tail], [[H|NT] |NTail]) :-
		firstCol(Tail, NT, Rest),
		trans(Rest, NRest),
		firstCol(NTail, T, NRest).
trans([], []).

firstCol([[H|T] |Tail], [H|Col], [T|Rows]) :-
		firstCol(Tail, Col, Rows).
firstCol([], [], []).

solution(Blacks,Whites,RetBoard):-

		length(Blacks,BlacksLength),
		length(Whites,WhitesLength),

		make_grid(RetBoard,BlacksLength,WhitesLength),
		write(RetBoard),
		flatten(RetBoard, Vars), nl,nl,
		write('depois de flatten :'),
		write(Vars), nl, nl,
		domain(Vars, 0, 1),
		write('depois de domain vars : '),
		write(Vars), nl,nl,
		 write('depois de domain bard : '),
		write(RetBoard), nl, nl,
		%1st restriction - the row has the correct number of squares(black or white)
		verifyColumnSizes(Blacks, BlacksLength),
		verifyColumnSizes(Whites, WhitesLength),

		% 2nd restriction - the squares are in a block
		verifyBlock(RetBoard, Whites),
		transpose(RetBoard, FlippedBoard),
		verifyBlock(FlippedBoard, Blacks),

	%3rd restriction - the rows have the correct number of squares
		verifyHeadWhite(RetBoard, Whites,WhitesLength),
		verifyHead(FlippedBoard, Blacks,BlacksLength),

	%4th restriction - the white squares form areas all of exact size
	%verifyAreas(RetBoard),

		labeling([],Vars).

solution_stats(Blacks,Whites,RetBoard):-

		length(Blacks,BlacksLength),
		length(Whites,WhitesLength),

		make_grid(RetBoard,BlacksLength,WhitesLength),
		flatten(RetBoard, Vars),
		domain(Vars, 0, 1),

		print('dumping previous fd stats:'),nl,

		fd_statistics,
		statistics(walltime,[W0|_]),
		statistics(runtime,[T0|_]),

		% 1st restriction - the row has the correct number of squares(black or white)
		verifyColumnSizes(Blacks, BlacksLength),
		verifyColumnSizes(Whites, WhitesLength),

		% 2nd restriction - the squares are in a block
		verifyBlock(RetBoard, Whites),
		transpose(RetBoard, FlippedBoard),
		verifyBlock(FlippedBoard, Blacks),

		%3rd restriction - the rows have the correct number of squares
		verifyHeadWhite(RetBoard, Whites,WhitesLength),
		verifyHead(FlippedBoard, Blacks,BlacksLength),

		%4th restriction - the white squares form areas all of exact size
		%verifyAreas(RetBoard),

		statistics(walltime,[W1|_]),
		statistics(runtime,[T1|_]),

		labeling([],Vars).

		statistics(walltime,[W2|_]),
		statistics(runtime,[T2|_]),

		T is T1-T0,
		W is W1-W0,
		Tl is T2-T1,
		Wl is W2-W1,

		nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,
		format('creating constraints took CPU ~3d sec.~n', [T]),
		format('creating constraints took a total of ~3d sec.~n', [W]),
		format('labeling took CPU ~3d sec.~n', [Tl]),
		format('labeling took a total of ~3d sec.~n', [Wl]),
		nl,
		fd_statistics.

flood_fill(StartX-StartY, Board, Length, 0):-
		StartX #< 0 #\/ StartY #< 0 #\/ StartY #>= Length #\/ StartY #>= Length.

flood_fill(StartX-StartY, Board, Length, Count):-
		Xp1 #= StartX + 1,
		Ym1 #= StartY - 1,
		Yp1 #= StartY + 1,
		matrix_at(StartX, StartY, Board, Symbol),
		Symbol #= 0 #<=> B,
		flood_fill(StartX-Ym1, Symbol, Board, Length, Count1),
		flood_fill(Xp1-StartY, Symbol, Board, Length, Count2),
		flood_fill(StartX-Yp1, Symbol,Board, Length, Count3),
		Count #= Count1 + Count2 + Count3 + B.

flood_fill(StartX-StartY, Board, Length, 0).