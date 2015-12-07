%=======================================%
%             DISPLAY CLASS             %
%=======================================%

%                 ------------- %
% #factos                       %
%                 ------------- %

piece(1, 'XXXX').
piece(0, '    ').

%                 ------------- %
% #predicados                   %
%                 ------------- %

testBoard([
	[7, [3, 2],[3, 2], [3, 2], [3, 2], [3, 2], [3, 2]],
	[[1, 3], 0, 1, 1, 0, 1, 1, 0],
	[[1, 3], 0, 1, 1, 0, 1, 1, 0],
	[[1, 3], 0, 1, 1, 0, 1, 1, 0],
	[[1, 3], 0, 1, 1, 0, 1, 1, 0],
	[[1, 3], 0, 1, 1, 0, 1, 1, 0],
	[[1, 3], 0, 1, 1, 0, 1, 1, 0],
	[[1, 3], 0, 1, 1, 0, 1, 1, 0]
]).

lista_tamanho([Length|_], Length).
lista_pretas([_|Black], Black).
lista_brancas([White|_], White).

% imprime no ecr� os delimitadores das c�lulas do tabuleiro
createSeparator(0, _).
createSeparator(N, SS):-
	write(SS),
	N1 is N - 1,
	createSeparator(N1, SS).

% imprime no ecr� uma representa��o do tabuleiro de jogo
printBoard([First|Matrix]):-
	lista_tamanho(First, Length),
	lista_pretas(First, Pieces),
	printFirstRow(Length),
	printRows(Matrix, Length), nl,
	imprime_pretas(Pieces), nl, !.

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
	list_at(Current, Items, [Pieces|Row]),
	write('    | '),
	printLine(Row), nl,
	write('    | '),
	printLine(Row),
	imprime_brancas(Pieces), nl,
	write('    | '),
	printLine(Row), nl,
	write('    +'),
	createSeparator(Length, '------+'), nl, !.

% imprime no ecr� a primeira e terceira sec��es de uma linha do tabuleiro
printLine([]).
printLine([H|T]):-
	piece(H, Char),
	write(Char),
	write(' | '),
	printLine(T), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imprime_pecas_aux([H|T]):-
	T \= [],
	write(H), write(','),
	imprime_pecas_aux(T).
imprime_pecas_aux([H|_]):-
	write(H).

imprime_pecas(Lista):-
	write('['),
	imprime_pecas_aux(Lista), !,
	write(']').

imprime_pretas([]).
imprime_pretas([H|T]):-
	imprime_pecas(H), !,
	write('   '),
	imprime_pretas(T).

imprime_brancas(Lista):-
	write(' '),
	imprime_pecas(Lista), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% imprime no ecr� uma sequ�ncia de 4 * Y espa�os
printTab:-
	format('~*c', [4, 0' ]), !.

generateNumbers(Length, 1, 0):-
	Number1 in 0..Length,
	Number0 in 0..Length,
	Number1 #\= Number0 #/\ abs(Number1 - Number0) #= 1
	#\/ Number1 #= Number0,
	length(1, Number1),
	length(0, Number0),
	domain(1, 1, Length),
	domain(0, 1, Length),
	append(1, 0, All),
	sum(All, #=, Length),
	labeling([], All).