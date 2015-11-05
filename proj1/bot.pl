%===========================%
%		  BOT CLASS			%
%===========================%

%			------- %
% #factos			%
%			------- %

botMode(random).
botMode(smart).

%			------- %
% #predicados       %
%			------- %

bestMove(From, Board, ToX-ToY):-
	scanNeighbors(From, Lista),
	bestMove(From, Board, Lista, ToX-ToY, -1).

bestMove(FromX-FromY, Board, [ToX-ToY], ToX-ToY, Score):-
	getSymbol(FromX, FromY, Board, Source),
	getSymbol(ToX, ToY, Board, Destination),
	scoreMove(Source, Destination, NewScore),
	NewScore > Score.
bestMove(FromX-FromY, Board, [ToX-ToY|T], _ToX-_ToY, Score):-
	getSymbol(FromX, FromY, Board, Source),
	getSymbol(ToX, ToY, Board, Destination),
	scoreMove(Source, Destination, NewScore),
	NewScore > Score,
	bestMove(FromX-FromY, Board, T, ToX-ToY, NewScore).
bestMove(From, Board, [_|T], To, Score):-
	bestMove(From, Board, T, To, Score).

% pontua a jogada com "2" se as peças adjacentes são diferentes
scoreMove(Source, Destination, 2):-
	isDisc(Source, Color),
	isRing(Destination, _),
	\+isRing(Destination, Color).
scoreMove(Source, Destination, 2):-
	isRing(Source, Color),
	isDisc(Destination, _),
	\+isDisc(Destination, Color).

% pontua a jogada com "1" se as peças adjacentes pertencem ao mesmo jogador
scoreMove(Source, Destination, 1):-
	isDisc(Source, Color),
	isRing(Destination, Color).
scoreMove(Source, Destination, 1):-
	isRing(Source, Color),
	isDisc(Destination, Color).

% pontua a jogada com "0" se as peças adjacentes são iguais ou não existem
scoreMove(_Source, _Destination, 0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% acção inicial do computador: colocar um disco
botInitialMove(Board, Player, NewBoard, NewPlayer):-
	random(0, 2, Action),
	Action > 0, !,
	botRandomPlace(Board, Player, Position, disc),
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).

% acção inicial do computador: colocar um anel
botInitialMove(Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Board, Player, Position, ring),
	botAction(3, Position, Board, Player, NewBoard, NewPlayer).

% predicado gerador de movimento aleatório do computador
botRandomMove(Board, Player, NewBoard, NewPlayer):-
	random(1, 5, Number),
	hasDiscs(Player), hasRings(Player), !,
	botRandomAction(Number, Board, Player, NewBoard, NewPlayer).

% predicado gerador de movimento ganancioso do computador
botSmartMove(Board, Player, Board, Player):-
	write('NOT IMPLEMENTED YET!!!').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% acção do computador: colocar um disco no tabuleiro
botAction(1, Position, Board, Player, NewBoard, NewPlayer):-
	hasDiscs(Player), !,
	getPlayerColor(Player, Color),
	printPlaceAction(Player, disc, Position),
	placeDisc(Position, Color, Board, NewBoard),
	decrementDiscs(Player, NewPlayer).

% acção do computador: colocar um anel no tabuleiro
botAction(3, Position, Board, Player, NewBoard, NewPlayer):-
	hasRings(Player), !,
	getPlayerColor(Player, Color),
	printPlaceAction(Player, ring, Position),
	placeRing(Position, Color, Board, NewBoard),
	decrementRings(Player, NewPlayer).

% acção do computador: mover um disco para uma célula ocupada por um anel
botAction(2, From, To, Board, Player, NewBoard, Player):-
	botCanMoveDisc(From, To, Board, Player), !,
	printMoveAction(Player, disc, From, To),
	moveDisc(From, To, Board, NewBoard).

% acção do computador: mover um anel para uma célula ocupada por um disco
botAction(4, From, To, Board, Player, NewBoard, Player):-
	botCanMoveRing(From, To, Board, Player),
	printMoveAction(Player, ring, From, To),
	moveRing(From, To, Board, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% imprime no ecrã informações relativas ao movimento "colocar peça" do computador
printPlaceAction(Player, Piece, Position):-
	getPlayerName(Player, PlayerName),
	format('~w placed ~w at position ~w\n', [PlayerName, Piece, Position]), nl.

% imprime no ecrã informações relativas ao movimento "mover peça" do computador
printMoveAction(Player, Piece, From, To):-
	getPlayerName(Player, PlayerName),
	format('~w moving ~w from position ~w to position ~w\n', [PlayerName, Piece, From, To]), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% acção do computador: realiza um movimento aleatório do tipo "colocar disco"
botRandomAction(1, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Board, Player, Position, disc),
	botAction(1, Position, Board, Player, TempBoard, TempPlayer), !,
	botSecondRandom(ring, TempBoard, TempPlayer, NewBoard, NewPlayer).

% acção do computador: realiza um movimento aleatório do tipo "mover disco"
botRandomAction(2, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, disc, Player, From),
	botRandomDestination(From, To),
	botAction(2, From, To, Board, Player, TempBoard, TempPlayer), !,
	botSecondRandom(ring, TempBoard, TempPlayer, NewBoard, NewPlayer).

% acção do computador: realiza um movimento aleatório do tipo "colocar anel"
botRandomAction(3, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Board, Player, Position, ring),
	botAction(3, Position, Board, Player,TempBoard,TempPlayer), !,
	botSecondRandom(disc, TempBoard, TempPlayer, NewBoard, NewPlayer).

% acção do computador: realiza um movimento aleatório do tipo "mover anel"
botRandomAction(4, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, ring, Player, From),
	botRandomDestination(From, To),
	botAction(4, From, To, Board, Player, TempBoard,TempPlayer), !,
	botSecondRandom(disc, TempBoard, TempPlayer, NewBoard, NewPlayer).

% acção do computador: fallback
botRandomAction(_, Board, Player, NewBoard, NewPlayer):-
	botRandomMove(Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% acção do computador: realiza um segundo movimento aleatório com um disco
botSecondRandom(disc, Board, Player, NewBoard, NewPlayer):-
	random(1, 11, Action),
	Action > 5, !,
	botRandomPlace(Board, Player, Position, disc),
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).
botSecondRandom(disc, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, disc, Player, From),
	botRandomDestination(From, To),
	botAction(2, From, To, Board, Player, NewBoard, NewPlayer).

% acção do computador: realiza um segundo movimento aleatório com um anel
botSecondRandom(ring, Board, Player, NewBoard, NewPlayer):-
	random(1, 11, Action),
	Action > 5, !,
	botRandomPlace(Board, Player, Position, ring),
	botAction(3, Position, Board, Player, NewBoard, NewPlayer).
botSecondRandom(ring, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, ring, Player, From),
	botRandomDestination(From, To),
	botAction(4, From, To, Board, Player, NewBoard, NewPlayer).

% acção do computador: fallback
botSecondRandom(Piece, Board, Player, NewBoard, NewPlayer):-
	botSecondRandom(Piece, Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% acção do computador: realiza um movimento aleatório do tipo "colocar disco"
botSmartAction(1, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Board, Player, Position, disc),
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).

% acção do computador: realiza um movimento aleatório do tipo "mover disco"
botSmartAction(2, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, disc, Player, From),
	botRandomDestination(From, To),
	botAction(2, From, To, Board, Player, NewBoard, NewPlayer).

% acção do computador: realiza um movimento aleatório do tipo "colocar anel"
botSmartAction(3, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Board, Player, Position, ring),
	botAction(3, Position, Board, Player, NewBoard, NewPlayer).

% acção do computador: realiza um movimento aleatório do tipo "mover anel"
botSmartAction(4, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, ring, Player, From),
	botRandomDestination(From, To),
	botAction(4, From, To, Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verifica se o computador pode mover um anel da posição (FromX,FromY) para (ToX,ToY)
botCanMoveRing(FromX-FromY, ToX-ToY, Board, Player):-
	getSymbol(FromX, FromY, Board, Source),
	getSymbol(ToX, ToY, Board, Destination),
	getPlayerColor(Player, Color),
	isRing(Source, Color), !,
	isSingleDisc(Destination).

% verifica se o computador pode mover um disco da posição (FromX,FromY) para (ToX,ToY)
botCanMoveDisc(FromX-FromY, ToX-ToY, Board, Player):-
	getSymbol(FromX, FromY, Board, Source),
	getSymbol(ToX, ToY, Board, Destination),
	getPlayerColor(Player, Color),
	isDisc(Source, Color), !,
	isSingleRing(Destination).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gera aleatoriamente uma célula de origem válida
botRandomSource(Board, Piece, Player, Resultado):-
	getPlayerColor(Player, Color),
	botScanMatrix(Board, Piece, Color, Lista), !,
	list_size(Lista, Tamanho),
	TamanhoExtra is Tamanho + 1,
	random(1, TamanhoExtra, Numero),
	list_at(Numero, Lista, Resultado), !.

% gera aleatoriamente uma célula de destino válida
botRandomDestination(X-Y, Position):-
	scanNeighbors(X-Y, Lista), !,
	list_size(Lista, Tamanho),
	TamanhoExtra is Tamanho + 1,
	random(1, TamanhoExtra, Number),
	list_at(Number, Lista, Position), !.

% verifica se existem jogadas restantes, procurando células vazias no tabuleiro
botRandomPlace(Board, Player, Position, _Piece):-
	\+isPlayerStuck(Board, Player), !,
	scanEmptyCells(Board, Lista, Tamanho),
	TamanhoExtra is Tamanho + 1,
	random(1, TamanhoExtra, Number),
	list_at(Number, Lista, Position), !.

% caso contrário, procura anéis no tabuleiro onde colocar um disco
botRandomPlace(Board, _Player, Position, disc):-
	write('PLAYER IS STUCK'),
	countRings(Board, Lista, Tamanho),
	Tamanho > 0, !,
	TamanhoExtra is Tamanho + 1,
	random(1, TamanhoExtra, Number),
	list_at(Number, Lista, Position), !.

% caso contrário, procura discos no tabuleiro onde colocar um anel
botRandomPlace(Board, _Player, Position, ring):-
	write('PLAYER IS STUCK'),
	countDiscs(Board, Lista, Tamanho),
	Tamanho > 0, !,
	TamanhoExtra is Tamanho + 1,
	random(1, TamanhoExtra, Number),
	list_at(Number, Lista, Position), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% encontra todas as peças do tabuleiro que sejam discos pretos
botScanMatrix(Board, disc, black, Lista):-
	scanMatrix(Board, 1, 1, isSingleBlackDisc, Lista).

% encontra todas as peças do tabuleiro que sejam discos brancos
botScanMatrix(Board, disc, white, Lista):-
	scanMatrix(Board, 1, 1, isSingleWhiteDisc, Lista).

% encontra todas as peças do tabuleiro que sejam anéis pretos
botScanMatrix(Board, ring, black, Lista):-
	scanMatrix(Board, 1, 1, isSingleBlackRing, Lista).

% encontra todas as peças do tabuleiro que sejam anéis brancos
botScanMatrix(Board, ring, white, Lista):-
	scanMatrix(Board, 1, 1, isSingleWhiteRing, Lista).