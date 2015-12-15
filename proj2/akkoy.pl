%                 ------------- %
% #includes                     %
%                 ------------- %

:- ensure_loaded('display.pl').
:- ensure_loaded('solver.pl').

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
	write('|   1. Solve Random (full hints) |'), nl,
	write('|   2. Solve Random (some hints) |'), nl,
	write('|                                |'), nl,
	write('|   3. Solve 3x3                 |'), nl,
	write('|   4. Solve 4x4                 |'), nl,
	write('|   5. Solve 5x5                 |'), nl,
	write('|   6. Solve 6x6                 |'), nl,
	write('|   7. Solve 7x7                 |'), nl,
	write('|                                |'), nl,
	write('|   8. About                     |'), nl,
	write('|                                |'), nl,
	write('|   9. <- Exit                   |'), nl,
	write('|                                |'), nl,
	write('+================================+'), nl, nl,
	write('Please choose an option:'), nl,
	getInt(Input),
	mainMenuAction(Input), !.

mainMenuAction(1):- solveFullRnd.
mainMenuAction(2):- solveRnd.
mainMenuAction(3):- solve3x3.
mainMenuAction(4):- solve4x4.
mainMenuAction(5):- solve5x5.
mainMenuAction(6):- solve6x6.
mainMenuAction(7):- solve7x7.
mainMenuAction(8):- aboutMenu, !, mainMenu.
mainMenuAction(9).
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

solveFullRnd:-
	askRandom(X, Y),
	generateFullHints(Y, X, Blacks, Whites), !,
	runFastSolver(Blacks, Whites), !.

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
	Blacks = [[3,1],[2],[4],[1,1,1],[1],[3]],
	Whites = [[1],[1,1],[2],[1],[3],[2]],
	runFastSolver(Blacks, Whites), !.

solve7x7:-
	Blacks = [[3],[1,1],[2,2],[1,1,1],[1,1,1],[4,1],[1]],
	Whites = [[3,1],[1,2,1],[1,2,1],[2,1],[1,3],[1,1,1],[3,3]],
	runFastSolver(Blacks, Whites), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runSolver(Blacks, Whites):-
	length(Blacks, BlackLength),
	length(Whites, WhiteLength),
	generateEmptyMatrix(Board, BlackLength, WhiteLength),
	printBoard(Board, Blacks, Whites),
	pressEnterToContinue,
	selectLabeling(Options),
	solution(Blacks, Whites, Options), !,
	pressEnterToContinue.

runSolver(_,_):-
	write('\nERROR: could not find any suitable solution for the given problem!'), nl,
	pressEnterToContinue, nl, fail.

runFastSolver(Blacks, Whites):-
	length(Blacks, BlackLength),
	length(Whites, WhiteLength),
	generateEmptyMatrix(Board, BlackLength, WhiteLength),
	printBoard(Board, Blacks, Whites),
	pressEnterToContinue,
	selectLabeling(Options),
	fast_solution(Blacks, Whites, Options), !,
	pressEnterToContinue.

runFastSolver(_,_):-
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

generateFullHints(Width, Height, Black, White):-
	generateMatrix(Board, Width, Height),
	transpose(Board, Columns),
	rowFullHints(Board, 0, White),
	rowFullHints(Columns, 1, Black).

rowFullHints([], _, []).
rowFullHints([H|T], Color, [ResultRow|Result]):-
	sequencia(H, 0, Color, ResultRow),
	rowFullHints(T, Color, Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generateHints(Width, Height, Black, White):-
	generateMatrix(Board, Width, Height),
	generate_rows_hints(Board, RH),
	transpose(Board, Columns),
	generate_rows_hints(Columns, CH),
	flatten(CH, CHF),
	flatten(RH, RHF),
	sum_list(CHF, NumberBlack),
	sum_list(RHF, NumberWhite),
	Total is Width * Height,
	Total >= NumberBlack + NumberWhite, !,
	strip_zeros(RH, White),
	strip_zeros(CH, Black).

generateHints(Width, Height, Black, White):-
	generateHints(Width, Height, Black, White).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sequencia([], 0, _, []).
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

make_rows([],_).
make_rows([G|Gs], Width):-
	length(G, Width),
	make_rows(Gs, Width), !.

make_grid(Board, Width, Height):-
	length(Board, Height),
	make_rows(Board, Width), !.

generate_rows_hints([],[]).
generate_rows_hints([Row|Rest],[RH|RHs]):-
	generate_hints_row(Row,RH),
	generate_rows_hints(Rest,RHs).

generate_hints_row([],[0]).
generate_hints_row([0|Rest],[0|RHs]):-
	generate_hints_row(Rest,RHs).
generate_hints_row([1|Rest],[Head|RHs]):-
	generate_hints_row(Rest,[NextHead|RHs]),
	Head is NextHead + 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generateEmptyMatrix([], _, 0).
generateEmptyMatrix([H|T], Width, Height):-
	Height > 0,
	generateEmptyRow(H, Width),
	RemainingHeight is Height - 1,
	generateEmptyMatrix(T, Width, RemainingHeight), !.

generateEmptyRow([], 0).
generateEmptyRow([0|T],Width):-
	Width > 0,
	RemainingWidth is Width - 1,
	generateEmptyRow(T, RemainingWidth), !.

generateMatrix([], _, 0).
generateMatrix([H|T], Width, Height):-
	Height > 0,
	generateRow(H, Width),
	RemainingHeight is Height - 1,
	generateMatrix(T, Width, RemainingHeight), !.

generateRow([], 0).
generateRow([H|T], Width):-
	Width > 0,
	random(0, 2, H),
	RemainingWidth is Width - 1,
	generateRow(T, RemainingWidth), !.