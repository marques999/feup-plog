%=======================================%
%             DISPLAY CLASS             %
%=======================================%

:- use_module(library(clpfd)).
:- use_module(library(random)).
%                 ------------- %
% #factos                       %
%                 ------------- %

firstLine(black, 'XXXX').
firstLine(white, '    ').

%                 ------------- %
% #predicados                   %
%                 ------------- %

testBoard([
	[7, [3, 2],[3, 2], [3, 2], [3, 2], [3, 2], [3, 2]],
	[[1, 3], white, black, black, white, white, white],
	[[1, 3], white, black, black, white, white, white],
	[[1, 3], white, black, black, white, white, white],
	[[1, 3], white, black, black, white, white, white],
	[[1, 3], white, black, black, white, white, white],
	[[1, 3], white, black, black, white, white, white]
]).

% imprime no ecr� os delimitadores das c�lulas do tabuleiro
createSeparator(0, _).
createSeparator(N, SS):-
	write(SS),
	N1 is N - 1,
	createSeparator(N1, SS).

% imprime no ecr� uma representa��o do tabuleiro de jogo
printBoard(Board, Length):-
	nl, printFirstRow(Length),
	printRows(Board, Length), nl,
	getNumberBlack(Board, Black),
	printNumberBlack(Black), nl, !.

% imprime no ecr� os n�meros das colunas do tabuleiro
printColumnIdentifiers(Length):-
	printColumnIdentifiers(Length, 0), !.
printColumnIdentifiers(Length, Length).
printColumnIdentifiers(Length, Current):-
	Next is Current + 1,
	write('  '),
	write(Next),
	write('   '),
	printColumnIdentifiers(Length, Next), !.

% imprime no ecr� as linhas do tabuleiro
printRows(Board, Length) :-
	printRows(Board, Length, 1), !.
printRows([], Length, Length).
printRows([H|T], Length, Current):-
	printRow(H, Length, Current),
	Next is Current + 1,
	printRows(T, Length, Next), !.

% imprime no ecr� a primeira linha da representa��o do tabuleiro
printFirstRow(Length):-
	write('     '),
	printColumnIdentifiers(Length), nl,
	write('    +'),
	createSeparator(Length, '-----+'), nl, !.

% imprime no ecr� a �ltima linha do tabuleiro
printRow(Items, Length, Current):-
	list_at(Current, Items, [White|Row]),
	write('    | '),
	printLine(Row), nl,
	write('    | '),
	printLine(Row),
	write('[ '),
	printNumberPieces(White), 
	write('] '), nl,
	write('    | '),
	printLine(Row), nl,
	write('    +'),
	createSeparator(Length, '------+'), nl, !.

% imprime no ecr� uma linha do tabuleiro
printRow(Items, Length, Current):-
	list_at(Current, Items, [White|Row]),
	write('    | '),
	printLine(Row), nl,
	write('    | '),
	printLine(Row),
	printNumberWhite(White), nl,
	write('    | '),
	printLine(Row), nl,
	write('    +'),
	createSeparator(Length, '------+'), nl, !.

% imprime no ecr� a primeira e terceira sec��es de uma linha do tabuleiro
printLine([]).
printLine([H|T]):-
	firstLine(H, Char),
	write(Char),
	write(' | '),
	printLine(T), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printNumberAux([H|T]):-
	T \= [],
	write(H), write(','),
	printNumberAux(T).
printNumberAux([H|_]):-
	write(H).

printNumberPieces(Lista):-
	write('['),
	printNumberAux(Lista), !,
	write(']').

printNumberBlack([H|T]):-
	printNumberPieces(H), !,
	write('   '),
	printNumberBlack(T).

printNumberWhite(White):-
	write(' '),
	printNumberPieces(White), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% imprime no ecr� uma sequ�ncia de 4 * Y espa�os
printTab:-
	format('~*c', [4, 0' ]), !.

generateNumbers(Length, Black, White):-
	HalfLength is Length // 2,
	NumberBlack in 0..Length,
	NumberWhite in 0..Length,
	NumberBlack #\= NumberWhite #/\ abs(NumberBlack - NumberWhite) #= 1
	#\/ NumberBlack #= NumberWhite,
	length(Black, NumberBlack),
	length(White, NumberWhite),
	domain(Black, 1, Length),
	domain(White, 1, Length),
	append(Black, White, All),
	sum(All, #=, Length),
	labeling([], All).