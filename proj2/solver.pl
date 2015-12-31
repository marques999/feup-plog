%                 ------------- %
% #includes                     %
%                 ------------- %

?- ensure_loaded('globals.pl').
:- dynamic global/1.

%                 ------------- %
% #predicados                   %
%                 ------------- %

verifyHead([], [], _).
verifyHead([H|T], [P|C], Tamanho):-
	verifyHead_aux(H, P, Tamanho),
	verifyHead(T, C, Tamanho).

%	(L)					lista de C1,C2,C3...
%	(T)					lista de comando (número de peças pretas)
%	(ComprimentoLista)	largura do tabuleiro

verifyHead_aux(L,T,ComprimentoLista):-
	sum(T,#=,NumeroDePecas),
	OutrasPecas #= ComprimentoLista - NumeroDePecas,
	global_cardinality(L,[0-OutrasPecas, 1-NumeroDePecas]).

verifyHeadWhite([],[],_).
verifyHeadWhite([H|T],[P|C],ComprimentoLista):-
	verifyHead_auxWhite(H,P,ComprimentoLista),
	verifyHeadWhite(T,C,ComprimentoLista).

%	(L)					lista de C1,C2,C3...
%	(T)					lista de comando (número de peças brancas)
%	(ComprimentoLista)	largura do tabuleiro

verifyHead_auxWhite(L,T,ComprimentoLista):-
	sum(T,#=,NumeroDePecas),
	OutrasPecas #= ComprimentoLista - NumeroDePecas,
	global_cardinality(L,[1-OutrasPecas,0-NumeroDePecas]).

verifyColumnSizes([],_).
verifyColumnSizes([H|T],Size):-
	sum(H,#=,Val),
	length(H,Val2),
	Val4 #= Val2 - 1,
	Val3 #= Val + Val4,
	Size #>= Val3,
	verifyColumnSizes(T,Size).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

adjacentTester([_], [], _, _).
adjacentTester([X,Y|T] , [B|Bs], Color1, Color2):-
	(X #= Color1 #/\ Y #= Color2) #<=> B,
	adjacentTester([Y|T], Bs, Color1, Color2).

verifyBlock_aux(L,Lacunas, Color1, Color2):-
	Lacunas > 0,
	adjacentTester(L,B,Color1,Color2),
	count(Lacunas,B,#=,1).
verifyBlock_aux(_,_,_,_).

%	[H|T]		matriz do tabuleiro transposta
%	[P|C]		sequência de quadrados pretos na coluna atual
verifyBlock([],[]).
verifyBlock([H|T], [P|C]):-
	length(P, ComprimentoDaLista),
	NumeroDeLacunas #= ComprimentoDaLista - 1,
	verifyBlock_aux(H, NumeroDeLacunas, 1, 0),
	verifyBlock(T,C).

%	[H|T]		matriz do tabuleiro
%	[P|C]		sequência de quadrados brancos na linha atual
verifyBlockWhite([],[]).
verifyBlockWhite([H|T], [P|C]):-
	length(P, ComprimentoDaLista),
	NumeroDeLacunas #= ComprimentoDaLista - 1,
	verifyBlock_aux(H,NumeroDeLacunas, 0, 1),
	verifyBlockWhite(T, C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verify_areas(Board, Length):-
	flatten(Board, Flatten),
	scan_white(Flatten, 0, Length, [Position|Whites]),
	flood_fill(Flatten, Length, Position, 0, Tamanho, Result),
	list_subtract(Whites, Result, NewResult),
	verify_area(Flatten, Length, NewResult, Tamanho).

verify_area(_, _, [],  _).
verify_area(Flatten, Length, Whites, Count):-
	list_at(0, Whites, PositionX-PositionY),
	flood_fill(Flatten, Length, PositionX, PositionY, 0, Count, Result),
	list_subtract(Whites, Result, NewResult),
	verify_area(Flatten, Length, NewResult, Count).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flood_fill(List, Length, Position, Color, Count, PrevExpl):-
		assert(global([])),
		flood_fillAux(List, Length, Position, Color, Count),
		global(PrevExpl),
		retract(global(PrevExpl)).

flood_fillAux(List, Length, Position, Color, Res):-

		Position #> 0,
		length(List, L),
		Position #< L + 1,

		element(Position, List, Color),
		global(PrevExpl),
		\+member(Position, PrevExpl),
		append(PrevExpl, [Position], CurrExpl),
		retract(global(PrevExpl)),
		assert(global(CurrExpl)),

		Position1 #= Position + 1,
		Position2 #= Position - 1,
		Position3 #= Position + Length,
		Position4 #= Position - Length,

		flood_fillAux(List, Length, Position1, Color, Res1),
		flood_fillAux(List, Length, Position2, Color, Res2),
		flood_fillAux(List, Length, Position3, Color, Res3),
		flood_fillAux(List, Length, Position4, Color, Res4),
		Res #= Res1 + Res2 + Res3 + Res4 + 1.

flood_fillAux(_, _, _, _, 0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global_testEqual2([], _, []).
global_testEqual2([H1|T1], Color, [H2|T2]):-
	count2(H1, Color, R1),
	listsAreEqual2(H2, R1),
	global_testEqual2(T1, Color, T2).

count2(List, Color, Res):-
	countAux2(List, Color, 0, Res).

countAux2([], _, Aux, List):-
	addToListExceptZero2(Aux, [], List).

countAux2([H|T], Color, Aux, List):-
	H #= Color,
	Aux1 #= Aux + 1,
	countAux2(T, Color, Aux1, List).

countAux2([H|T], Color, Aux, List):-
	H #\= Color,
	countAux2(T, Color, 0, List2),
	addToListExceptZero2(Aux,List2,List).

addToListExceptZero2(Elem, List, Res):-
	Elem #\= 0,
	append([Elem],List,Res).

addToListExceptZero2(0, List, List).

listsAreEqual2([],_).
listsAreEqual2([H|T],List2):-
	member(H, List2),
	del2(H,List2,L2Res),
	listsAreEqual2(T,L2Res).

del2(X,[X|Tail],Tail).
del2(X,[Y|Tail],[Y|Tail1]):-
	del2(X,Tail,Tail1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_transitions([], [], FinalState, FinalState,_).
create_transitions([Hint|Hs], Transitions, CurState, FinalState,FirstSquare) :-
	(Hint #= 0, %finished current 'gray' blocks segment
	(
		FirstSquare =:= 0,
			Transitions = [arc(CurState,0,CurState), arc(CurState,0,NextState) | Ts],
			create_transitions(Hs, Ts, NextState, FinalState,1);
		FirstSquare =:= 1,
			Transitions = [arc(CurState,0,CurState)],
			create_transitions(Hs, Ts, CurState, FinalState,1)
	);
	Hint #> 0,
	Transitions = [arc(CurState,1,NextState) | Ts],
	NewHint #= Hint-1,
	create_transitions([NewHint|Hs], Ts, NextState, FinalState,0)).

create_transitionsWhite([], [], FinalState, FinalState,_).
create_transitionsWhite([Hint|Hs], Transitions, CurState, FinalState,FirstSquare) :-
	(Hint #= 0, %finished current 'gray' blocks segment
	(
		FirstSquare =:= 1,
			Transitions = [arc(CurState,1,CurState), arc(CurState,1,NextState) | Ts],
			create_transitionsWhite(Hs, Ts, NextState, FinalState,0);
		FirstSquare =:= 0,
			Transitions = [arc(CurState,1,CurState)],
			create_transitionsWhite(Hs, Ts, CurState, FinalState,0)
	);
	Hint #> 0,
	Transitions = [arc(CurState,0,NextState) | Ts],
	NewHint #= Hint-1,
	create_transitionsWhite([NewHint|Hs], Ts, NextState, FinalState,1)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

restrict_rows([],[]).
restrict_rows(_, [0]).
restrict_rows([R|Rs],[H|Hs]):-
	length(R, MaxSum),
	RowSum #=< MaxSum,
	sum(H, #=, RowSum),
	count(1, R, #>=, RowSum),
	create_transitions(H, Arcs, start, FinalState,1),
	append(R, [0], RowWithExtraZero),
	automaton(RowWithExtraZero, [source(start), sink(FinalState)], [arc(start,0,start) | Arcs]),
	restrict_rows(Rs, Hs).

fast_restrict_rows([],[]).
fast_restrict_rows([R|Rs],[H|Hs]):-
	length(R, MaxSum),
	RowSum #=< MaxSum,
	sum(H, #=, RowSum),
	count(1, R, #>=, RowSum),
	fast_restrict_rows(Rs, Hs).

restrict_rowsWhite([],[]).
restrict_rowsWhite(_, [0]).
restrict_rowsWhite([R|Rs],[H|Hs]):-
	length(R, MaxSum),
	RowSum #=< MaxSum,
	sum(H, #=,RowSum),
	count(0, R, #>=, RowSum),
	create_transitionsWhite(H, Arcs, start, FinalState,0),
	append(R, [1], RowWithExtraZero),
	automaton(RowWithExtraZero, [source(start), sink(FinalState)], [arc(start,1,start) | Arcs]),
	restrict_rowsWhite(Rs, Hs).

fast_restrict_rowsWhite([],[]).
fast_restrict_rowsWhite([R|Rs],[H|Hs]):-
	length(R, MaxSum),
	RowSum #=< MaxSum,
	sum(H, #=,RowSum),
	count(0, R, #>=, RowSum),
	fast_restrict_rowsWhite(Rs, Hs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% percorre uma linha do tabuleiro
% obtém uma lista com as células dessa linha que verificam determinado objetivo
scan_white([],_,_,[]).
scan_white([H|T], Position, Length, [Position|Lista]):-
	H #= 0,
	Next #= Position + 1,
	scan_white(T, Next, Length, Lista).
scan_white([_|T], Position, Length, Lista):-
	Next #= Position + 1,
	scan_white(T, Next, Length, Lista).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fast_solution(Blacks,Whites,Options):-

	length(Blacks,BlacksLength),
	length(Whites,WhitesLength),

	make_grid(RetBoard,BlacksLength,WhitesLength),
	flatten(RetBoard, ResultingBoard),
	domain(ResultingBoard, 0, 1),

	write('\nDumping previous statistics...\n'),

	fd_statistics,
	statistics(walltime, [W0|_]),
	statistics(runtime, [T0|_]),

	% 2nd restriction - as células da mesma cor devem estar em bloco
	transpose(RetBoard, FlippedBoard),
	%verifyBlockWhite(RetBoard, Whites),
	%verifyBlock(FlippedBoard, Blacks),

	% 3rd restriction - cada linha deve ter um determinado número de blocos das duas cores
	%verifyHead(FlippedBoard,Blacks,BlacksLength),

	restrict_rows(FlippedBoard, Blacks),
	restrict_rowsWhite(RetBoard, Whites),
	%verifyHeadWhite(RetBoard,Whites,WhitesLength),

	%4th restriction - os quadrados brancos devem formar regiões com área igual
	%verify_areas(RetBoard, BlacksLength),

	% calcula tempo decorrido até inicialização das restrições do problema
	statistics(walltime, [W1|_]),
	statistics(runtime, [T1|_]),

	% executa predicado de pesquisa com as opções passadas como argumento
	labeling(Options,ResultingBoard),

	% calcula tempo decorrido até finalização do predicado de labeling
	statistics(walltime, [W2|_]),
	statistics(runtime, [T2|_]),

	% calcula intervalos de tempo entre as várias queries
	ConstraintTime is T1 - T0,
	ConstraintWall is W1 - W0,
	LabelingTime is T2 - T1,
	LabelingWall is W2 - W1,

	format('~nInitializing constraints took CPU ~3d sec.~n', [ConstraintTime]),
	format('Initializing constraints took a total of ~3d sec.~n', [ConstraintWall]),
	format('Labeling took CPU ~3d sec.~n', [LabelingTime]),
	format('Labeling took a total of ~3d sec.~n~n', [LabelingWall]),

	printBoard(RetBoard,Blacks,Whites),
	fd_statistics.

solution(Blacks, Whites, Options):-

	length(Blacks, BlacksLength),
	length(Whites, WhitesLength),

	make_grid(RetBoard, BlacksLength, WhitesLength),
	flatten(RetBoard, ResultingBoard),
	transpose(RetBoard, FlippedBoard),
	domain(ResultingBoard, 0, 1),

	write('\nDumping previous statistics...\n'),

	fd_statistics,
	statistics(walltime, [W0|_]),
	statistics(runtime, [T0|_]),

	%1st restriction - the row has the correct number of squares(black or white)
	verifyColumnSizes(Blacks, BlacksLength),
	verifyColumnSizes(Whites, WhitesLength),

	fast_restrict_rows(FlippedBoard, Blacks),
	fast_restrict_rowsWhite(RetBoard, Whites),
	global_testEqual2(FlippedBoard, 1, Blacks),
	global_testEqual2(RetBoard, 0, Whites),

	% calcula tempo decorrido até inicialização das restrições do problema
	statistics(walltime, [W1|_]),
	statistics(runtime, [T1|_]),

	% executa predicado de pesquisa com as opções passadas como argumento
	labeling(Options,ResultingBoard),

	% calcula tempo decorrido até finalização do predicado de labeling
	statistics(walltime, [W2|_]),
	statistics(runtime, [T2|_]),

	% calcula intervalos de tempo entre as várias queries
	ConstraintTime is T1 - T0,
	ConstraintWall is W1 - W0,
	LabelingTime is T2 - T1,
	LabelingWall is W2 - W1,

	format('~nInitializing constraints took CPU ~3d sec.~n', [ConstraintTime]),
	format('Initializing constraints took a total of ~3d sec.~n', [ConstraintWall]),
	format('Labeling took CPU ~3d sec.~n', [LabelingTime]),
	format('Labeling took a total of ~3d sec.~n~n', [LabelingWall]),

	printBoard(RetBoard, Blacks, Whites),
	fd_statistics.