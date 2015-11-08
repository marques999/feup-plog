%=======================================%
%             DISPLAY CLASS             %
%=======================================%

%                 ------------- %
% #factos                       %
%                 ------------- %

firstLine(8, ' --- ').
firstLine(9, ' --- ').
firstLine(10, ' --- ').
firstLine(4, ' xxx ').
firstLine(5, ' xxx ').
firstLine(6, ' xxx ').
firstLine(_, '     ').

secondLine(1, '  B  ').
secondLine(2, '  W  ').
secondLine(4, 'x   x').
secondLine(5, 'x B x').
secondLine(6, 'x W x').
secondLine(8, '|   |').
secondLine(9, '| B |').
secondLine(10, '| W |').
secondLine(_, '     ').

%                 ------------- %
% #predicados                   %
%                 ------------- %

% imprime no ecr� os delimitadores das c�lulas do tabuleiro
createSeparator(0, _).
createSeparator(N, SS):-
	N1 is N-1,
	write(SS),
	createSeparator(N1, SS), !.

% imprime no ecr� uma sequ�ncia de 4 * Y espa�os
printTab(Y):-
	Y1 is Y * 4,
	format('~*c', [Y1, 0' ]), !.

% imprime no ecr� uma representa��o do tabuleiro de jogo
printBoard(Board):-
	nl, printFirstRow(7),
	printRows(Board, 7), nl, nl, !.

% imprime no ecr� os n�meros das colunas do tabuleiro
printColumnIdentifiers(Length):-
	printColumnIdentifiers(Length, 0), !.

% fun��o auxiliar para imprimir no ecr� os Length n�meros das colunas do tabuleiro
printColumnIdentifiers(Length, Length).
printColumnIdentifiers(Length, Current):-
	Next is Current + 1,
	write('   '),
	write(Next),
	write('    '),
	printColumnIdentifiers(Length, Next), !.

% imprime no ecr� as linhas do tabuleiro
printRows(Board, Length) :-
	printRows(Board, Length, 0), !.

% fun��o auxiliar para imprimir no ecr� as Length linhas do tabuleiro
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
	createSeparator(Length, '-------+'), nl, !.

% imprime no ecr� a �ltima linha do tabuleiro
printRow(Items, Length, Current):-
	Current is Length - 1,
	printRowItems(Items, Current), nl,
	printTab(Current),
	write('    +'),
	createSeparator(Length, '-------+'), !.

% imprime no ecr� uma linha do tabuleiro
printRow(Items, Length, Current):-
	printRowItems(Items, Current), nl,
	printTab(Current),
	write('    +'),
	createSeparator(Length, '-------+'),
	write('---+'), nl, !.

% imprime no ecr� as c�lulas e pe�as de determinada linha do tabuleiro
printRowItems(Items, Current):-
	printTab(Current),
	write('    | '),
	printFirstLine(Items), nl,
	Next is Current + 1,
	write(Next),
	printTab(Current),
	write('   | '),
	printSecondLine(Items), nl,
	printTab(Current),
	write('    | '),
	printFirstLine(Items), !.

% imprime no ecr� a primeira e terceira sec��es de uma linha do tabuleiro
printFirstLine([]).
printFirstLine([H|T]):-
	firstLine(H, Char),
	write(Char),
	write(' | '),
	printFirstLine(T), !.

% imprime no ecr� a segunda sec��o de uma linha do tabuleiro
printSecondLine([]).
printSecondLine([H|T]):-
	secondLine(H, Char),
	write(Char),
	write(' | '),
	printSecondLine(T), !.

% imprime no ecr� informa��es sobre o estado de determinado jogador (nome e n�mero de pe�as)
printPlayerInfo(Player):-
	getPlayerName(Player, PlayerName),
	getNumberRings(Player, NumberRings),
	getNumberDiscs(Player, NumberDiscs),
	format('| ~w | rings : ~w | discs : ~w |', [PlayerName, NumberRings, NumberDiscs]), nl, !.

% imprime no ecr� o nome do pr�ximo jogador a jogar
printTurn(Player):-
	format("> IT'S ~w'S TURN!", Player), nl, !.

% imprime no ecr� todos os elementos do estado do jogo
printState(Game):-
	getGameBoard(Game, Board),
	getPlayer1(Game, Player1),
	getPlayer2(Game, Player2),
	getPlayerTurn(Game, PlayerTurn),
	printBoard(Board),
	write('+---------------------------------------+'), nl,
	printPlayerInfo(Player1),
	printPlayerInfo(Player2),
	write('+---------------------------------------+'), nl, nl,
	printTurn(PlayerTurn), nl,
	pressEnterToContinue, nl, !.