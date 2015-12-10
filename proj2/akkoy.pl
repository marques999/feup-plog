%=======================================%
%               AKKOY CLASS             %
%=======================================%

%                 ------------- %
% #includes                     %
%                 ------------- %

:- ensure_loaded('globals.pl').
:- ensure_loaded('display.pl').
:- ensure_loaded('generate.pl').
:- ensure_loaded('list.pl').
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
	write('|                                |'), nl,
	write('|   5. About                     |'), nl,
	write('|                                |'), nl,
	write('|   6. <- Exit                   |'), nl,
	write('|                                |'), nl,
	write('+================================+'), nl, nl,
	write('Please choose an option:'), nl,
	getInt(Input),
	mainMenuAction(Input), !.

mainMenuAction(1):- solveRnd, !, mainMenu.
mainMenuAction(2):- solve3x3, !, mainMenu.
mainMenuAction(3):- solve4x4, !, mainMenu.
mainMenuAction(4):- solve5x5, !, mainMenu.
mainMenuAction(5):- aboutMenu, !, mainMenu.
mainMenuAction(6).
mainMenuAction(_):-
	messageInvalidValue, !,
	mainMenu.

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
	askRandom(X, Y),
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runSolver(Blacks, Whites):-
	length(Blacks, BlackLength),
	length(Whites, WhiteLength),
	generateEmptyMatrix(Board,BlackLength,WhiteLength),
	printBoard(Board,Blacks,Whites),
	pressEnterToContinue,
	solution(Blacks,Whites,RetBoard),
	printBoard(RetBoard,Blacks,Whites),
	pressEnterToContinue.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askRandom(X, Y):-
	nl, write('Please enter the problem size (N x N) and then press <ENTER>: '), nl,
	getCoordinates(X, Y), nl,
	X > 2, Y > 2, X =< 100, Y =< 100, !.

askRandom(_, _):-
	write('INVALID INPUT!'), nl,
	write('You have entered an invalid problem size, must be an integer between 3 and 100!'), nl,
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

csgo_xites(List, X, Y, Color, Res):-
	length(List, Factor),	
	csgo_xitesAux(List, Factor, X, Y, Color, [], _, Res), !.
	
csgo_xitesAux(List, Factor, X, Y, Color, PrevExpl, NewExpl, Res):-
	matrix_at(X, Y, List, Color),
	Cords is X + Y * Factor,

	\+member(Cords, PrevExpl),
	append(PrevExpl, [Cords], CurrExpl),
				
	X1 is X + 1,
	X2 is X - 1,
	Y1 is Y + 1,
	Y2 is Y - 1,
		
	csgo_xitesAux(List, Factor, X1, Y, Color, CurrExpl, NewExpl1, Res1),	
	addLists(CurrExpl, NewExpl1, CurrExpl2),	
	csgo_xitesAux(List, Factor, X2, Y, Color, CurrExpl2, NewExpl2, Res2),
	addLists(CurrExpl2, NewExpl2, CurrExpl3),
	csgo_xitesAux(List, Factor, X, Y1, Color, CurrExpl3, NewExpl3, Res3),
	addLists(CurrExpl3, NewExpl3, CurrExpl4),
	csgo_xitesAux(List, Factor, X, Y2, Color, CurrExpl4, NewExpl4, Res4),
	addLists(CurrExpl4, NewExpl4, NewExpl),		
	Res is Res1 + Res2 + Res3 + Res4 + 1.

csgo_xitesAux(List, Factor, X, Y, Color, _, NewExpl, 0):-
	matrix_at(X, Y, List, _),	
	Cords is X + Y * Factor,
	append([], [Cords], NewExpl).
	
csgo_xitesAux(_, _, _, _, _, _,[], 0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addLists(List, [], List).

addLists(List, [H|T], Res):-	
	addLists(List, T, Res1),
	addIfNotIn(H, Res1, Res).

addIfNotIn(Coord, List, Res):-	
	\+member(Coord, List),
	append(List, [Coord], Res).
	
addIfNotIn(Coord, List, List):-
	member(Coord, List).