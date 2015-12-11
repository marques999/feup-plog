%=======================================%
%              SOLVER CLASS             %
%=======================================%

%                 ------------- %
% #includes                     %
%                 ------------- %

?- ensure_loaded('globals.pl').
?- ensure_loaded('list.pl').

%                 ------------- %
% #predicados                   %
%                 ------------- %

verifyHead([], [], _).
verifyHead([H|T], [P|C], Tamanho):-
		verifyHead_aux(H, P, Tamanho),
		verifyHead(T, C, Tamanho).

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
		global_cardinality(L,[1-OutrasPecas,0-NumeroDePecas]).

applyDomain([]).
applyDomain([H|T]):-
		domain(H,0,1),
		applyDomain(T).

applyLabeling([]).
applyLabeling([H|T]):-
		labeling([],H),
		applyLabeling(T).

verifyColumnSizes([],_).
verifyColumnSizes([H|T],Size):-
		sum(H,#=,Val),
		length(H,Val2),
		Val4 is Val2 - 1,
		Val3 is Val + Val4,
		Size #>= Val3,
		verifyColumnSizes(T,Size).

adjacentTester([_],[], Color1, Color2).
adjacentTester([X,Y|T] , [B|Bs], Color1, Color2):-
	(X #= Color1 #/\ Y #= Color2) #<=> B,
	adjacentTester([Y|T],Bs,Color1,Color2).

verifyBlock_aux(L,Lacunas, Color1, Color2):-
	Lacunas > 0,
	adjacentTester(L,B,Color1,Color2),
	count(Lacunas,B,#=,1).
verifyBlock_aux(L,_,_,_).

%1. board
%2. black squares
verifyBlock([],[]).
verifyBlock([H|T], [P|C]):-
	length(P,ComprimentoDaLista),
	NumeroDeLacunas #= ComprimentoDaLista - 1,
	verifyBlock_aux(H,NumeroDeLacunas,1,0),
	verifyBlock(T,C).

%1. flipped board
%2. white squares
verifyBlockWhite([],[]).
verifyBlockWhite([H|T], [P|C]):-
	length(P,ComprimentoDaLista),
	NumeroDeLacunas #= ComprimentoDaLista - 1,
	verifyBlock_aux(H,NumeroDeLacunas,0,1),
	verifyBlockWhite(T,C).

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

%verifyAreas_aux([],ListaRet).
%verifyAreas_aux([H|T],ListaRet):-
		%append([H],ListaRet,ListaRet2),
		%verifyAreas_aux(T,ListaRet2).

%verifyAreas([], []).
%verifyAreas(Flatten, [Result|Old]):-
		%scanList(Flatten, Whites),
		%verifyAreas_aux(Whites, Result),
		%verifyAreas(T, Old).

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

create_transitions([], [], FinalState, FinalState,_).
create_transitions([Hint|Hs], Transitions, CurState, FinalState,FirstSquare) :-
	(Hint #= 0, %finished current 'gray' blocks segment
	(FirstSquare =:= 0,
				Transitions = [arc(CurState,0,CurState), arc(CurState,0,NextState) | Ts],
				create_transitions(Hs, Ts, NextState, FinalState,1);
		FirstSquare =:=1,
				Transitions = [arc(CurState,0,CurState)],
				create_transitions(Hs, Ts, CurState, FinalState,1))
		;
		Hint #> 0,
	Transitions = [arc(CurState,1,NextState) | Ts],
	NewHint #= Hint-1,
	create_transitions([NewHint|Hs], Ts, NextState, FinalState,0)).

create_transitionsWhite([], [], FinalState, FinalState,_).
create_transitionsWhite([Hint|Hs], Transitions, CurState, FinalState,FirstSquare) :-
	(Hint #= 1, %finished current 'gray' blocks segment
	(FirstSquare =:=0,
				Transitions = [arc(CurState,1,CurState), arc(CurState,1,NextState) | Ts],
				create_transitionsWhite(Hs, Ts, NextState, FinalState,0);
		FirstSquare =:=1,
				Transitions = [arc(CurState,1,CurState)],
				create_transitionsWhite(Hs, Ts, CurState, FinalState,0))
		;
		Hint #> 0,
	Transitions = [arc(CurState,0,NextState) | Ts],
	NewHint #= Hint-1,
	create_transitionsWhite([NewHint|Hs], Ts, NextState, FinalState,1)).

restrict_rows([],[]).
restrict_rows([R|Rs],[H|Hs]):-
		length(R,MaxSum),
		(
		var(H),
		HintLength is floor((MaxSum+1)/2),
		length(H,HintLength),
		checkHints(H,MaxSum)
		;
		nonvar(H),
		checkHints(H,MaxSum)
		),
		RowSum #=< MaxSum,
		sum(H,#=,RowSum),
		sum(R,#=,RowSum),
		create_transitions(H, Arcs, start, FinalState,1),
		append(R, [0], RowWithExtraZero), %a zero is added to simplify the automaton (every gray block must be followed by at least one blank square, even the last one)
		automaton(RowWithExtraZero, [source(start), sink(FinalState)], [arc(start,0,start) | Arcs]),
		restrict_rows(Rs,Hs).

restrict_rowsWhite([],[]).
restrict_rowsWhite([R|Rs],[H|Hs]):-
		length(R,MaxSum),
		(
		var(H),
		HintLength is floor((MaxSum+1)/2),
		length(H,HintLength),
		checkHintsWhite(H,MaxSum)
		;
		nonvar(H),
		checkHintsWhite(H,MaxSum)
		),
		RowSum #=< MaxSum,
		sum(H,#=,RowSum),
		sum(R,#=,RowSum),
		create_transitionsWhite(H, Arcs, start, FinalState,0),
		append(R, [1], RowWithExtraZero), %a zero is added to simplify the automaton (every gray block must be followed by at least one blank square, even the last one)
		automaton(RowWithExtraZero, [source(start), sink(FinalState)], [arc(start,1,start) | Arcs]),
		restrict_rowsWhite(Rs,Hs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isBlack(Symbol):- Symbol #= 1.
isWhite(Symbol):- Symbol #= 0.

scanBlack(List, Result):-
	scanList(List, 0, isBlack, Result).
scanWhite(List, Result):-
	scanList(List, 0, isWhite, Result).

% percorre uma linha do tabuleiro
% obtém uma lista com as células dessa linha que verificam determinado objetivo
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
	verifyBlock(FlippedBoard, Blacks),
	verifyBlock(RetBoard, Whites),

	% 3rd restriction - cada linha deve ter um determinado número de blocos das duas cores
	verifyHead(FlippedBoard,Blacks,BlacksLength),
	verifyHeadWhite(RetBoard,Whites,WhitesLength),

	restrict_rows(FlippedBoard, Blacks),
	%restrict_rowsWhite(FlippedBoard, Whites),

	%4th restriction - os quadrados brancos devem formar regiões com área igual
	%verifyAreas(RetBoard),

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
	fd_statistics, !.