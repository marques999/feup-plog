%=======================================%
%             DISPLAY CLASS             %
%=======================================%

%                 ------------- %
% #includes                     %
%                 ------------- %

?- ensure_loaded('globals.pl').
?- ensure_loaded('list.pl').

%                 ------------- %
% #factos                       %
%                 ------------- %

piece(1, 'XXXX').
piece(0, '    ').

finishedGame([
	[0,0,0,1,1,1,0],
	[0,1,1,0,0,1,0],
	[1,0,1,0,0,1,0],
	[1,0,0,1,1,1,0],
	[1,0,1,0,0,0,1],
	[0,1,1,0,1,1,0],
	[0,0,0,1,0,0,0]
]).

finishedBlack([[3],[1,1],[0],[1,1,1],[0],[1,4],[1]]).
finishedWhite([[1,3],[1,2,1],[2,1,1],[1,2],[3,1],[1,1,1],[3,3]]).

%                 ------------- %
% #predicados                   %
%                 ------------- %

printTest:-
	finishedGame(Board),
	finishedBlack(Black),
	finishedWhite(White),
	printBoard(Board, Black, White).

% imprime no ecrã os delimitadores das células do tabuleiro
createSeparator(0, _).
createSeparator(N, SS):-
	write(SS),
	N1 is N - 1,
	createSeparator(N1, SS), !.

% imprime no ecrã uma representação do tabuleiro de jogo
printBoard(Board, Black, White):-
	length(Black, Length),
	imprime_pretas(Black), nl,
	write('    +'),
	createSeparator(Length, '------+'), nl,
	printRows(Board, White), nl, !.

% imprime no ecrã as linhas do tabuleiro
printRows(Board, White):-
	length(White, Length),
	printRows(Board, Length, White), !.

printRows([], _, []).
printRows([H|T], Length, [White|Next]):-
	printRow(H, Length, White),
	printRows(T, Length, Next), !.

% imprime no ecrã a última linha do tabuleiro
printRow(Row, Length, White):-
	write('    | '),
	printLine(Row), nl,
	write('    | '),
	printLine(Row),
	imprime_brancas(White), nl,
	write('    | '),
	printLine(Row), nl,
	write('    +'),
	createSeparator(Length, '------+'), nl, !.

% imprime no ecrã a primeira e terceira secções de uma linha do tabuleiro
printLine([]).
printLine([H|T]):-
	piece(H, Char),
	write(Char),
	write(' | '),
	printLine(T), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imprime_brancas_aux([]).
imprime_brancas_aux([H]):-
	write(H).
imprime_brancas_aux([H|T]):-
	write(H), write(','),
	imprime_brancas_aux(T).

imprime_brancas(Lista):-
	write(' ['),
	imprime_brancas_aux(Lista), !,
	write(']').

imprime_pretas(Lista):-
	largest_sublist(Lista, Tamanho),
	imprime_pretas_aux(Lista, Tamanho), !.

imprime_pretas_aux(_, 0).
imprime_pretas_aux(ColHints, VSpacing):-
	VSpacing > 0,
	imprime_espaco(7),
	imprime_vertical(ColHints, VSpacing), nl,
	NewVSpacing is VSpacing - 1,
	imprime_pretas_aux(ColHints, NewVSpacing), !.

imprime_vertical([],_).
imprime_vertical([H|T],VSpacing):-
	length(H, Size),
	(Size < VSpacing, imprime_espaco(1);
	Position is Size - VSpacing,
	nth0(Position, H, Value),
	write(Value)),
	imprime_espaco(6),
	imprime_vertical(T, VSpacing), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% imprime no ecrã uma sequência de 4 * Y espaços
imprime_espaco(Length):-
	format('~*c', [Length, 0' ]), !.