%=======================================%
%               AKKOY CLASS             %
%=======================================%

%                 ------------- %
% #includes                     %
%                 ------------- %

:- ensure_loaded('display.pl').
:- ensure_loaded('generate.pl').
:- ensure_loaded('solver.pl').

%                 ------------- %
% #factos	                    %
%                 ------------- %

flattenedMatrix([0,0,0,1,1,1,0,0,1,1,0,0,1,0,1,0,1,0,0,1,0,1,0,0,1,1,1,0,1,0,1,0,0,0,1,0,1,1,0,1,1,0,0,0,0,1,0,0,0]).

%                 ------------- %
% #predicados                   %
%                 ------------- %

akkoy:-
	initializeRandomSeed, !,
	mainMenu.

mainMenu:- nl,
	write('+================================+'), nl,
	write('+        ..:: AKKOY ::..         +'), nl,
	write('+================================+'), nl,
	write('|                                |'), nl,
	write('|   1. Solve Random              |'), nl,
	write('|   2. Solve 3x3                 |'), nl,
	write('|   3. Solve 4x4                 |'), nl,
	write('|   4. Solve 5x5                 |'), nl,
	write('|   5. Solve 6x6                 |'), nl,
	write('|                                |'), nl,
	write('|   6. About                     |'), nl,
	write('|                                |'), nl,
	write('|   7. <- Exit                   |'), nl,
	write('|                                |'), nl,
	write('+================================+'), nl, nl,
	write('Please choose an option:'), nl,
	getInt(Input),
	mainMenuAction(Input), !.

mainMenuAction(1):- solveRnd.
mainMenuAction(2):- solve3x3.
mainMenuAction(3):- solve4x4.
mainMenuAction(4):- solve5x5.
mainMenuAction(5):- solve6x6.
mainMenuAction(6):- aboutMenu, !, mainMenu.
mainMenuAction(7).
mainMenuAction(_):- !, mainMenu.

aboutMenu:- nl,
	write('+===============================+'), nl,
	write('+        ..:: ABOUT ::..        +'), nl,
	write('+===============================+'), nl,
	write('|                               |'), nl,
	write('|   FEUP / MIEIC                |'), nl,
	write('|   Ano Letivo 2015-2016        |'), nl,
	write('|                               |'), nl,
	write('|   Authors:                    |'), nl,
	write('|                               |'), nl,
	write('|    > Carlos Samouco           |'), nl,
	write('|      up201305187@fe.up.pt     |'), nl,
	write('|                               |'), nl,
	write('|    > Diogo Marques            |'), nl,
	write('|      up201305642@fe.up.pt     |'), nl,
	write('|                               |'), nl,
	write('+===============================+'), nl,
	nl, pressEnterToContinue, !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solveRnd:-
	askRandom(X, Y), !,
	generateHints(Y, X, Blacks, Whites),
	runSolver(Blacks, Whites), !.

solve3x3:-
	Blacks = [[1,1],[1],[1]],
	Whites = [[1],[1],[1]],
	runSolver(Blacks, Whites), !.

solve4x4:-
	Blacks = [[2],[1],[2],[3]],
	Whites = [[1],[2],[1],[1]],
	runSolver(Blacks, Whites), !.

solve5x5:-
	Blacks = [[1,2],[1,1],[1,1],[1,1],[2,1]],
	Whites = [[5],[1],[3],[3],[1]],
	runSolver(Blacks, Whites), !.

solve6x6:-
Blacks = [[3],[1,1],[2,2],[1,1,1],[1,1,1],[4,1],[1]],
Whites = [ [3,1], [1,2,1], [1,2,1], [2,1], [1,3], [1,1,1] ,[3,3]],
	runSolver(Blacks, Whites), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runSolver(Blacks, Whites):-
	length(Blacks, BlackLength),
	length(Whites, WhiteLength),
	generateEmptyMatrix(Board,BlackLength,WhiteLength),
	printBoard(Board,Blacks,Whites),
	pressEnterToContinue,
	selectLabeling(Options),
	solution(Blacks,Whites,Options),
	pressEnterToContinue.

runSolver(_,_):-
	write('\nERROR: could not find any suitable solution for the given problem!'), nl,
	pressEnterToContinue, nl, fail.

selectLabeling(Options):-
	write('\n> SELECT LABELING OPTIONS:\n'),
	write('\t1. Leftmost / Step\n'),
	write('\t2. Leftmost / Bisect\n'),
	write('\t3. Leftmost / Median\n'),
	write('\t4. First Fail / Step\n'),
	write('\t5. First Fail / Bisect\n'),
	write('\t6. First Fail / Median\n'),
	write('\t7. FFC / Step\n'),
	write('\t8. FFC / Bisect\n'),
	write('\t9. FFC / Median\n'),
	getInt(Choice),
	selectLabeling(Choice, Options).

selectLabeling(1, [leftmost,step]).
selectLabeling(2, [leftmost,bisect]).
selectLabeling(3, [leftmost,median]).
selectLabeling(4, [first_fail,step]).
selectLabeling(5, [first_fail,bisect]).
selectLabeling(6, [first_fail,median]).
selectLabeling(7, [ffc,step]).
selectLabeling(8, [ffc,bisect]).
selectLabeling(9, [ffc,median]).
selectLabeling(_, [ffc,bisect]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askRandom(X, Y):-
	write('\nPlease enter the number of rows and then press <ENTER>:\n'),
	getLine(X), X > 2, X < 100,
	write('\nPlease enter the number of columns and then press <ENTER>:\n'),
	getLine(Y), Y > 2, Y < 100.

askRandom(_, _):-
	write('\nINVALID INPUT!\n'),
	write('Problem size must be an integer between 3 and 100.\n'),
	pressEnterToContinue, nl, fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verifica_pretos(Matriz):-
	matrix_transpose(Matriz, [_|NovaMatriz]),
	verifica_tudo(NovaMatriz, 1).

verifica_brancos([_|NovaMatriz]):-
	verifica_tudo(NovaMatriz, 0).

verifica_tudo([], _).
verifica_tudo([H|T], [Contagem|P], Cor):-
	verifica_linha(H, Contagem, Cor),
	verifica_tudo(T, P, Cor).

verifica_linha(Linha, Contagem, Cor):-
	sequencia(Linha, 0, Cor, Resultado),
	list_contains(Resultado, Contagem).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sequencia([], _, _, []).
sequencia([], Contador, _, [Contador]).
sequencia([H|T], Contador, Peca, Resultado):-
	H #= Peca,
	Next #= Contador + 1,
	sequencia(T, Next, Peca, Resultado).
sequencia([_|T], Contador, Peca, [Contador|Resultado]):-
	Contador #> 0,
	sequencia(T, 0, Peca, Resultado).
sequencia([_|T], Contador, Peca, Resultado):-
	sequencia(T, Contador, Peca, Resultado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verifica se duas células do tabuleiro são adjacentes em conetividade 4

isNeighbour(FromX-FromY, ToX-ToY, Length):-
	ToX #> 0, ToY #>0, ToX #=< Length, ToY #=< Length,
	(ToY #= FromY #/\ abs(FromX - ToX) #= 1) #\/ (ToX #= FromX #/\ abs(FromY - ToY) #= 1).

is_neighbour(From, To, Length):-
	FromX #= From // Length, FromY #= From mod Length,
	ToX #= To // Length, ToY #= To mod Length,
	(ToY #= FromY #/\ abs(FromX - ToX) #= 1) #\/ (ToX #= FromX #/\ abs(FromY - ToY) #= 1).

isConnected(StartX-StartY, EndX-EndY, Length, Board):-
	isNeighbour(StartX-StartY, EndX-EndY, Length),
	matrix_at(StartX, StartY, Board, Source),
	matrix_at(EndX, EndY, Board, Destination),
	StartX-StartY #\= EndX-EndY,
	Source #= 0,
	Destination #= 0,
	labeling([], [EndX, EndY, Source, Destination]).

checkConnected([_], [_], _, _).
checkConnected([X1,X2|A], [Y1,Y2|B], Length, Board):-
	isConnected(X1-Y1, X2-Y2, Length, Board),
	checkConnected(A, B, Length, Board).

flattenConnected([], _).
flattenConnected([H|T], Board):-
	count_equals(T, H, Board, Count),
	Count #> 0,
	flattenConnected([T], Board).

flattenConnectedAux(From, To, Length, List):-
	Start #= From + 1,
	End #= From + Length,
	To in Start..End,
	is_neighbour(From, To, Length),
	element(_, List, From),
	element(_, List, To),
	labeling([], [To]).

count_equals([_], _, _, 0).
count_equals([H|T], From, Board, Count):-
	flattenConnectedAux(From, H, Board) #<=> B,
	count_equals(T, From, Board, Next),
	Count #= Next + B.

newPath(Start, Board, Resultado):-
	%length(ResultadoX, 4),
	length(Resultado, 4),
	%domain(ResultadoX, 1, 7),
	domain(Resultado, 0, 49),
	%element(1, ResultadoX, StartX),
	element(1, Resultado, Start),
	all_distinct(Resultado),
	flattenConnected(Resultado, Board),
	%append(ResultadoX, ResultadoY, Resultado),
	labeling([], Resultado).

checkPath(Start, End, Board, Length, Lista, ListaFim):-
	flattenConnectedAux(Start, Middle, Length, Board),
	#\member(Middle, Lista),
	append(Lista, [Middle], Lista2),
	checkPath(Middle, End, Board, Length, Lista2, ListaFim).

checkPath(Start, End, _Board, Length, Lista, Lista).