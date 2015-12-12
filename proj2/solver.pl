%=======================================%
%              SOLVER CLASS             %
%=======================================%

%                 ------------- %
% #includes                     %
%                 ------------- %

?- ensure_loaded('globals.pl').
?- ensure_loaded('list.pl').

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
	Val4 is Val2 - 1,
	Val3 is Val + Val4,
	Size #>= Val3,
	verifyColumnSizes(T,Size).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

adjacentTester([_],[], Color1, Color2).
adjacentTester([X,Y|T] , [B|Bs], Color1, Color2):-
	(X #= Color1 #/\ Y #= Color2) #<=> B,
	adjacentTester([Y|T],Bs,Color1,Color2).

cohesionTester([_],[]).
cohesionTester([X,Y|T], [B|Bs]):-
	(X #= 1 #/\ Y #= 1) #<=> B,
	adjacentTester([Y|T],Bs,1,0).

verifyCohese_aux(H):-
	cohesionTester(H,B),
	createMatrix(B,D).

verifyCohese([],[]).
verifyCohese([H|T],[P|C]):-
	verifyCohese_aux(H),
	verifyCohese(T,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verifyBlock_aux(L,Lacunas, Color1, Color2):-
	Lacunas > 0,
	adjacentTester(L,B,Color1,Color2),
	count(Lacunas,B,#=,1).
verifyBlock_aux(L,_,_,_).

%	[H|T]		matriz do tabuleiro transposta
%	[P|C]		sequência de quadrados pretos na coluna atual
verifyBlock([],[]).
verifyBlock([H|T], [P|C]):-
	length(P,ComprimentoDaLista),
	NumeroDeLacunas #= ComprimentoDaLista - 1,
	verifyBlock_aux(H,NumeroDeLacunas,1,0),
	verifyBlock(T,C).

%	[H|T]		matriz do tabuleiro
%	[P|C]		sequência de quadrados brancos na linha atual
verifyBlockWhite([],[]).
verifyBlockWhite([H|T], [P|C]):-
	length(P,ComprimentoDaLista),
	NumeroDeLacunas #= ComprimentoDaLista - 1,
	verifyBlock_aux(H,NumeroDeLacunas,0,1),
	verifyBlockWhite(T,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verifyFirst(Board):-
	scanWhite(Board, [FirstX-FirstY|Whites]),
	csgo_xites(Board, FirstX, FirstY, 0, Tamanho, Result),
	list_subtract(Whites, Result, NewResult),
	verifyAreas(Board, NewResult, Tamanho).

verifyAreas(_, [],  _).
verifyAreas(Board, Whites, Count):-
	list_at(0, Whites, PositionX-PositionY),
	csgo_xites(Board, PositionX, PositionY, 0, Count2, Result),
	Count2 #= Count,
	write(PositionX),write('-'),write(PositionY),write(':'),
	write(Count), nl,
	list_subtract(Whites, Result, NewResult),
	verifyAreas(Board, NewResult, Count).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

csgo_xites(List, X, Y, Color, Count, PrevExpl):-	
	assert(global([])),
	csgo_xitesAux(List, X, Y, Color, Count),
	global(PrevExpl),
	retract(global(PrevExpl)), !.
	
csgo_xitesAux(List, X, Y, Color, Res):-	
	matrix_at(X, Y, List, Color2),
	Color2 #= Color,
	global(PrevExpl),				
	\+member(X-Y, PrevExpl),	
	append(PrevExpl, [X-Y], CurrExpl),
	retract(global(PrevExpl)),
	assert(global(CurrExpl)),
				
	X1 #= X + 1,
	X2 #= X - 1,
	Y1 #= Y + 1,
	Y2 #= Y - 1,
		
	csgo_xitesAux(List, X1, Y, Color, Res1),		
	csgo_xitesAux(List, X2, Y, Color, Res2),
	csgo_xitesAux(List, X, Y1, Color, Res3),	
	csgo_xitesAux(List, X, Y2, Color, Res4),	
	Res #= Res1 + Res2 + Res3 + Res4 + 1.

csgo_xitesAux(_, _, _, _, 0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkHints([],_).
checkHints([H|Hs],MaxSum):-
	(var(H),domain([H],0,MaxSum);
	integer(H)),
	checkHints(Hs,MaxSum).

checkHintsWhite([],_).
checkHintsWhite([H|Hs],MaxSum):-
	(var(H),domain([H],0,MaxSum);
	integer(H)),
	checkHintsWhite(Hs,MaxSum).

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
	(Hint #= 1, %finished current 'gray' blocks segment
	(
		FirstSquare =:=0,
			Transitions = [arc(CurState,1,CurState), arc(CurState,1,NextState) | Ts],
			create_transitionsWhite(Hs, Ts, NextState, FinalState,0);
		FirstSquare =:=1,
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
	length(R,MaxSum),
	RowSum #=< MaxSum,
	sum(H, #=, RowSum),
	count(1, R, #>=, RowSum),
	OtherSum #= MaxSum - RowSum,
	count(0, R, #=, OtherSum),
	create_transitions(H, Arcs, start, FinalState,1),
	append(R, [0], RowWithExtraZero), %a zero is added to simplify the automaton (every gray block must be followed by at least one blank square, even the last one)
	automaton(RowWithExtraZero, [source(start), sink(FinalState)], [arc(start,0,start) | Arcs]),
	restrict_rows(Rs,Hs).

restrict_rowsWhite([],[]).
restrict_rowsWhite(_, [0]).
restrict_rowsWhite([R|Rs],[H|Hs]):-
	length(R,MaxSum),
	RowSum #=< MaxSum,
	sum(H, #=,RowSum),
	count(0, R, #>=, RowSum),
	OtherSum #= MaxSum - RowSum,
	count(1, R, #=, OtherSum),
	write(RowSum),nl,
	%create_transitionsWhite(H, Arcs, start, FinalState,0),
	%append(R, [1], RowWithExtraZero), %a zero is added to simplify the automaton (every gray block must be followed by at least one blank square, even the last one)
	%automaton(RowWithExtraZero, [source(start), sink(FinalState)], [arc(start,1,start) | Arcs]),
	restrict_rowsWhite(Rs,Hs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isBlack(Symbol):- Symbol #= 1.
isWhite(Symbol):- Symbol #= 0.

scanBlack(List, Result):-
	scanMatrix(List, 0, 0, isBlack, Result).
scanWhite(List, Result):-
	scanMatrix(List, 0, 0, isWhite, Result).

scanMatrix([],_,_,_,[]).
scanMatrix([H|T], X, Y, Predicate, Lista):-
	scanRow(H, X, Y, Predicate, Row),
	X1 is X + 1,
	scanMatrix(T, X1, Y, Predicate, Resultado),
	append(Row, Resultado, Lista).

% percorre uma linha do tabuleiro
% obtém uma lista com as células dessa linha que verificam determinado objetivo
scanRow([],_,_,_,[]).
scanRow([H|T], X, Y, Predicate, [X-Y|Lista]):-
	call(Predicate, H),
	Y1 #= Y + 1,
	scanRow(T, X, Y1, Predicate, Lista).
scanRow([_|T], X, Y, Predicate, Lista):-
	Y1 #= Y + 1,
	scanRow(T, X, Y1, Predicate, Lista).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solution(Blacks,Whites,Options):-

	length(Blacks,BlacksLength),
	length(Whites,WhitesLength),

	make_grid(RetBoard,BlacksLength,WhitesLength),
	flatten(RetBoard, ResultingBoard),
	domain(ResultingBoard, 0, 1),

	write('\nDumping previous statistics...\n'),

	fd_statistics,
	statistics(walltime, [W0|_]),
	statistics(runtime, [T0|_]),

	%1st restriction - the row has the correct number of squares(black or white)
	verifyColumnSizes(Blacks, BlacksLength),
	verifyColumnSizes(Whites, WhitesLength),

	% 2nd restriction - as células da mesma cor devem estar em bloco
	transpose(RetBoard, FlippedBoard),
	verifyBlockWhite(RetBoard, Whites),
	verifyBlock(FlippedBoard, Blacks),
	

	% 3rd restriction - cada linha deve ter um determinado número de blocos das duas cores
	%verifyHead(FlippedBoard,Blacks,BlacksLength),
	restrict_rowsWhite(RetBoard, Whites),
	restrict_rows(FlippedBoard, Blacks),

	%verifyHeadWhite(RetBoard,Whites,WhitesLength),

	
	%r

	%4th restriction - os quadrados brancos devem formar regiões com área igual
	%verifyFirst(RetBoard),

	% calcula tempo decorrido até inicialização das restrições do problema
	statistics(walltime, [W1|_]),
	statistics(runtime, [T1|_]),

	% executa predicado de pesquisa com as definições default
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