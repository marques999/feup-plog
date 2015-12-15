%                 ------------- %
% #includes                     %
%                 ------------- %

?- ensure_loaded('globals.pl').

%                 ------------- %
% #factos                       %
%                 ------------- %

piece(1, 'XXXX').
piece(0, '    ').

pieceSMALL(1, 'X').
pieceSMALL(0, ' ').

testGame([
	[0,0,0,1,1,1,0],
	[0,1,1,0,0,1,0],
	[1,0,1,0,0,1,0],
	[1,0,0,1,1,1,0],
	[1,0,1,0,0,0,1],
	[0,1,1,0,1,1,0],
	[0,0,0,1,0,0,0]
]).

testBlack([[3],[1,1],[0],[1,1,1],[0],[1,4],[1]]).
testWhite([[1,3],[1,2,1],[2,1,1],[1,2],[3,1],[1,1,1],[3,3]]).

%                 ------------- %
% #predicados                   %
%                 ------------- %

% imprime no ecrã os delimitadores das células do tabuleiro
createSeparator(0, _).
createSeparator(N, SS):-
	write(SS),
	N1 is N - 1,
	createSeparator(N1, SS), !.

% escolhe uma das duas representações do tabuleiro com base no tamanho deste
printBoard(Board, Black, White):-
	length(White, Length),
	Length > 11, !,
	printBoardAuxSMALL(Board, Black, White).
printBoard(Board, Black, White):-
	printBoardAux(Board, Black, White).

% imprime no ecrã uma representação do tabuleiro de jogo (tamanho normal)
printBoardAux(Board, Black, White):-
	printBlack(Black),
	write('    +'),
	length(Black, Length),
	createSeparator(Length, '------+'), nl,
	printRows(Board, Length, White), nl, !.

% imprime no ecrã uma representação do tabuleiro de jogo (tamanho pequeno)
printBoardAuxSMALL(Board, Black, White):-
	printBlackSMALL(Black),
	write(' +'),
	length(Black, Length),
	createSeparator(Length, '---+'), nl,
	printRowsSMALL(Board, Length, White), nl, !.

% imprime no ecrã todas as linhas do tabuleiro (tamanho normal)
printRows([], _, []).
printRows([H|T], Length, [White|Next]):-
	printRow(H, Length, White),
	printRows(T, Length, Next), !.

% imprime no ecrã todas as linhas do tabuleiro (tamanho pequeno)
printRowsSMALL([], _, []).
printRowsSMALL([H|T], Length, [White|Next]):-
	printRowSMALL(H, Length, White),
	printRowsSMALL(T, Length, Next), !.

% imprime no ecrã uma linha do tabuleiro (tamanho normal)
printRow(Row, Length, White):-
	write('    | '),
	printLine(Row),
	write('\n    | '),
	printLine(Row),
	printWhite(White),
	write('\n    | '),
	printLine(Row),
	write('\n    +'),
	createSeparator(Length, '------+'), nl, !.

% imprime no ecrã uma linha do tabuleiro (tamanho pequeno)
printRowSMALL(Row, Length, White):-
	write(' | '),
	printLineSMALL(Row),
	printWhite(White), nl,
	write(' +'),
	createSeparator(Length, '---+'), nl, !.

% imprime no ecrã uma linha do tabuleiro (tamanho normal)
printLine([]).
printLine([H|T]):-
	piece(H, Char),
	write(Char),
	write(' | '),
	printLine(T), !.

% imprime no ecrã uma linha do tabuleiro (tamanho pequeno)
printLineSMALL([]).
printLineSMALL([H|T]):-
	pieceSMALL(H, Char),
	write(Char),
	write(' | '),
	printLineSMALL(T), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printWhite(Whites):-
	write('['),
	printWhite_aux(Whites), !,
	write(']').

printWhite_aux([]).
printWhite_aux([H]):-
	write(H).
printWhite_aux([H|T]):-
	write(H), write(','),
	printWhite_aux(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printBlack(Blacks):-
	largest_sublist(Blacks, Tamanho),
	printBlack_aux(Blacks, Tamanho), !.

printBlackSMALL(Blacks):-
	largest_sublist(Blacks, Tamanho),
	printBlack_auxSMALL(Blacks, Tamanho), !.

printBlack_aux(_, 0).
printBlack_aux(Blacks, Length):-
	Length > 0,
	printTab(7),
	printVertical(Blacks, Length), nl,
	Next is Length - 1,
	printBlack_aux(Blacks, Next), !.

printBlack_auxSMALL(_, 0).
printBlack_auxSMALL(Blacks, Length):-
	Length > 0,
	printTab(3),
	printVerticalSMALL(Blacks, Length), nl,
	Next is Length - 1,
	printBlack_auxSMALL(Blacks, Next), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printVertical([], _).
printVertical([H|T], Length):-
	length(H, Size),
	(Size < Length, printTab(1);
	Position is Size - Length,
	nth0(Position, H, Value),
	write(Value)),
	printTab(6),
	printVertical(T, Length), !.

printVerticalSMALL([], _).
printVerticalSMALL([H|T], Length):-
	length(H, Size),
	(Size < Length, printTab(1);
	Position is Size - Length,
	nth0(Position, H, Value),
	write(Value)),
	printTab(3),
	printVerticalSMALL(T, Length), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% imprime no ecrã uma sequência de espaços
printTab(Length):-
	format('~*c', [Length, 0' ]), !.