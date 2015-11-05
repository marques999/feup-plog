%=======================================%
%               BOT CLASS               %
%=======================================%

%                 ------------- %
% #factos                       %
%                 ------------- %

botMode(random).
botMode(smart).

%                 ------------- %
% #predicados                   %
%                 ------------- %

generatePosition(Lista, Tamanho, Position):-
	TamanhoExtra is Tamanho + 1,
	random(1, TamanhoExtra, Number),
	list_at(Number, Lista, Position), !.

generateEmptyNeighbour(Board, From, Position):-
	scanEmptyNeighbours(From, Board, Tamanho, Lista),
	Tamanho > 0,
	generatePosition(Lista, Tamanho, Position), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

botSmartMoveDisc(Board, Player, OwnPosition, EnemyPosition):-
	write('trying SMART move disc...'), nl,
	findOwnSingleDisc(Board, Player, OwnPosition),
	scanSingleNeighbours(OwnPosition, Board, Tamanho, Lista),
	Tamanho > 0,
	calculateMoveDisc(Board, OwnPosition, Lista, 0, 0-0, EnemyPosition),
	EnemyPosition \= 0-0.

botSmartMoveDisc(Board, Player, OwnPosition, EnemyPosition):-
	write('SMART move disc failed, trying RANDOM move disc...'), nl,
	botRandomSource(Board, disc, Player, OwnPosition),
	botRandomDestination(OwnPosition, EnemyPosition).

botSmartMoveRing(Board, Player, OwnPosition, EnemyPosition):-
	write('trying SMART move ring...'), nl,
	findOwnSingleRing(Board, Player, OwnPosition),
	scanSingleNeighbours(OwnPosition, Board, Tamanho, Lista),
	Tamanho > 0,
	calculateMoveRing(Board, OwnPosition, Lista, 0, 0-0, EnemyPosition),
	EnemyPosition \= 0-0.

botSmartMoveRing(Board, Player, OwnPosition, EnemyPosition):-
	write('SMART move ring failed, trying RANDOM move ring...'), nl,
	botRandomSource(Board, ring, Player, OwnPosition),
	botRandomDestination(OwnPosition, EnemyPosition).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calculateMoveDisc(_Board, _From, [],  _Score, Position, Position):- !.
calculateMoveDisc(Board, From, [To|T], Score, _Position, FinalPosition):-
	scoreMoveDisc(Board, From, To, NewScore),
	NewScore > Score,
	calculateMoveDisc(Board, From, T, NewScore, To, FinalPosition).
calculateMoveDisc(Board, From, [_|T], Score, Position, FinalPosition):-
	calculateMoveDisc(Board, From, T, Score, Position, FinalPosition).

calculateMoveRing(_Board, _From, [],  _Score, Position, Position):- !.
calculateMoveRing(Board, From, [To|T], Score, _Position, FinalPosition):-
	scoreMoveRing(Board, From, To, NewScore),
	NewScore > Score,
	calculateMoveRing(Board, From, T, NewScore, To, FinalPosition).
calculateMoveRing(Board, From, [_|T], Score, Position, FinalPosition):-
	calculateMoveRing(Board, From, T, Score, Position, FinalPosition).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pontua a jogada com "2" se as pe�as adjacentes s�o diferentes
scoreMoveDisc(Board, From, To, 1):-
	getSymbol(From, Board, Source),
	getSymbol(To, Board, Destination),
	isDisc(Source, Color),
	isRing(Destination, _),
	\+isRing(Destination, Color).

% pontua a jogada com "1" se as pe�as adjacentes pertencem ao mesmo jogador
scoreMoveDisc(Board, From, To, 2):-
	getSymbol(From, Board, Source),
	getSymbol(To, Board, Destination),
	isDisc(Source, Color),
	isRing(Destination, Color).

% pontua a jogada com "0" se a pe�a adjacente � um disco ou encontra-se vazia
scoreMoveDisc(_Board, _From, _To, 0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pontua a jogada com "2" se as pe�as adjacentes s�o diferentes
scoreMoveRing(Board, From, To, 1):-
	getSymbol(From, Board, Source),
	getSymbol(To, Board, Destination),
	isRing(Source, Color),
	isDisc(Destination, _),
	\+isDisc(Destination, Color).

% pontua a jogada com "1" se as pe�as adjacentes pertencem ao mesmo jogador
scoreMoveRing(Board, From, To, 2):-
	getSymbol(From, Board, Source),
	getSymbol(To, Board, Destination),
	isRing(Source, Color),
	isDisc(Destination, Color).

% pontua a jogada com "0" se a pe�a adjacente � um anel ou encontra-se vazia
scoreMoveRing(_Board, _From, _To, 0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obt�m as coordenadas de uma c�lula (simples || dupla) com uma pe�a do jogador
findOwnPiece(Board, Player, Position):-
	getPlayerColor(Player, Color),
	scanPlayerPieces(Board, Color, Tamanho, Lista),
	Tamanho > 0, !,
	generatePosition(Lista, Tamanho, Position).

% obt�m as coordenadas de uma c�lula (simples || dupla) com um disco do jogador
findOwnDisc(Board, Player, Position):-
	getPlayerColor(Player, Color),
	scanPlayerDiscs(Board, Color, Tamanho, Lista),
	Tamanho > 0, !,
	generatePosition(Lista, Tamanho, Position).

% obt�m as coordenadas de uma c�lula (simples || dupla) com um disco do jogador
findOwnSingleDisc(Board, Player, Position):-
	getPlayerColor(Player, Color),
	scanPlayerSingleDiscs(Board, Color, Lista, Tamanho),
	Tamanho > 0,
	generatePosition(Lista, Tamanho, Position).

% obt�m as coordenadas de uma c�lula (simples || dupla) com um anel do jogador
findOwnRing(Board, Player, Position):-
	getPlayerColor(Player, Color),
	scanPlayerRings(Board, Color, Tamanho, Lista),
	Tamanho > 0, !,
	generatePosition(Lista, Tamanho, Position).

% obt�m as coordenadas de uma c�lula (simples || dupla) com um disco do jogador
findOwnSingleRing(Board, Player, Position):-
	getPlayerColor(Player, Color),
	scanPlayerSingleRings(Board, Color, Lista, Tamanho),
	Tamanho > 0,
	generatePosition(Lista, Tamanho, Position).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obt�m as coordenadas de uma c�lula (simples || dupla) com uma pe�a do advers�rio
findOpponentPiece(Board, Player, Position):-
	getEnemyColor(Player, Color),
	scanPlayerPieces(Board, Color, Tamanho, Lista),
	Tamanho > 0, !,
	generatePosition(Lista, Tamanho, Position).

% obt�m as coordenadas de uma c�lula (simples || dupla) com um disco do advers�rio
findOpponentDisc(Board, Player, Position):-
	getEnemyColor(Player, Color),
	scanPlayerDiscs(Board, Color, Tamanho, Lista),
	Tamanho > 0, !,
	generatePosition(Lista, Tamanho, Position).

% obt�m as coordenadas de uma c�lula (simples || dupla) com um anel do advers�rio
findOpponentRing(Board, Player, Position):-
	getEnemyColor(Player, Color),
	scanPlayerRings(Board, Color, Tamanho, Lista),
	Tamanho > 0, !,
	generatePosition(Lista, Tamanho, Position).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obt�m as coordenadas de uma c�lula vizinha da c�lula que cont�m um disco do jogador
botAttackPlaceDisc(Board, Player, Position):-
	findOwnDisc(Board, Player, OwnPosition), !,
	generateEmptyNeighbour(Board, OwnPosition, Position).

% obt�m as coordenadas de uma c�lula vizinha da c�lula que cont�m um anel do jogador
botAttackPlaceRing(Board, Player, Position):-
	findOwnRing(Board, Player, OwnPosition), !,
	generateEmptyNeighbour(Board, OwnPosition, Position).

% obt�m as coordenadas de uma c�lula vizinha da c�lula que cont�m um disco do advers�rio
botDefendPlaceDisc(Board, Player, Position):-
	findOpponentDisc(Board, Player, EnemyPosition), !,
	generateEmptyNeighbour(Board, EnemyPosition, Position).

% obt�m as coordenadas de uma c�lula vizinha da c�lula que cont�m um anel do advers�rio
botDefendPlaceRing(Board, Player, Position):-
	findOpponentRing(Board, Player, EnemyPosition), !,
	generateEmptyNeighbour(Board, EnemyPosition, Position).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% jogada ofensiva (colocar um disco na vizinhan�a
botSmartPlaceRing(Board, Player, Position):-
	random(0, 11, Number),
	Number > 5,
	write('BOT trying to smart attack with rings...'), nl,
	botAttackPlaceRing(Board, Player, Position).
botSmartPlaceRing(Board, Player, Position):-
	write('BOT trying to smart block enemy ring...'), nl,
	botDefendPlaceRing(Board, Player, Position).
botSmartPlaceRing(Board, Player, Position):-
	write('SMART place ring failed, BOT trying random place ring...'), nl,
	botRandomPlace(Board, Player, Position, ring).

botSmartPlaceDisc(Board, Player, Position):-
	random(0, 11, Number),
	Number > 5,
	write('BOT trying to smart attack with discs...'), nl,
	botAttackPlaceDisc(Board, Player, Position).
botSmartPlaceDisc(Board, Player, Position):-
	write('BOT trying to smart block enemy disc...'), nl,
	botDefendPlaceDisc(Board, Player, Position).
botSmartPlaceDisc(Board, Player, Position):-
	write('SMART place disc failed, BOT trying random place disc...'), nl,
	botRandomPlace(Board, Player, Position, disc).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ac��o inicial do computador: colocar um disco
botInitialMove(Board, Player, NewBoard, NewPlayer):-
	random(0, 2, Action),
	Action > 0, !,
	botRandomPlace(Board, Player, Position, disc),
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).

% ac��o inicial do computador: colocar um anel
botInitialMove(Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Board, Player, Position, ring),
	botAction(3, Position, Board, Player, NewBoard, NewPlayer).

% predicado gerador de movimento aleat�rio do computador
botRandomMove(Board, Player, NewBoard, NewPlayer):-
	random(1, 5, Number),
	hasDiscs(Player),
	hasRings(Player), !,
	botRandomAction(Number, Board, Player, NewBoard, NewPlayer).

% predicado gerador de movimento ganancioso do computador
botSmartMove(Board, Player, NewBoard, NewPlayer):-
	random(1, 5, Number),
	hasDiscs(Player),
	hasRings(Player), !,
	botSmartAction(Number, Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ac��o do computador: colocar um disco no tabuleiro
botAction(1, Position, Board, Player, NewBoard, NewPlayer):-
	hasDiscs(Player), !,
	getPlayerColor(Player, Color),
	printPlaceAction(Player, disc, Position),
	placeDisc(Position, Color, Board, NewBoard),
	decrementDiscs(Player, NewPlayer).

% ac��o do computador: colocar um anel no tabuleiro
botAction(3, Position, Board, Player, NewBoard, NewPlayer):-
	hasRings(Player), !,
	getPlayerColor(Player, Color),
	printPlaceAction(Player, ring, Position),
	placeRing(Position, Color, Board, NewBoard),
	decrementRings(Player, NewPlayer).

% ac��o do computador: mover um disco para uma c�lula ocupada por um anel
botAction(2, From, To, Board, Player, NewBoard, Player):-
	botCanMoveDisc(From, To, Board, Player), !,
	printMoveAction(Player, disc, From, To),
	moveDisc(From, To, Board, NewBoard).

% ac��o do computador: mover um anel para uma c�lula ocupada por um disco
botAction(4, From, To, Board, Player, NewBoard, Player):-
	botCanMoveRing(From, To, Board, Player),
	printMoveAction(Player, ring, From, To),
	moveRing(From, To, Board, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% imprime no ecr� informa��es relativas ao movimento "colocar pe�a" do computador
printPlaceAction(Player, Piece, Position):-
	getPlayerName(Player, PlayerName),
	format('~w placed ~w at position ~w\n', [PlayerName, Piece, Position]), nl.

% imprime no ecr� informa��es relativas ao movimento "mover pe�a" do computador
printMoveAction(Player, Piece, From, To):-
	getPlayerName(Player, PlayerName),
	format('~w moving ~w from position ~w to position ~w\n', [PlayerName, Piece, From, To]), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ac��o do computador: realiza um movimento aleat�rio do tipo "colocar disco"
botRandomAction(1, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Board, Player, Position, disc),
	botAction(1, Position, Board, Player, TempBoard, TempPlayer), !,
	botSecondRandom(ring, TempBoard, TempPlayer, NewBoard, NewPlayer).

% ac��o do computador: realiza um movimento aleat�rio do tipo "mover disco"
botRandomAction(2, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, disc, Player, From),
	botRandomDestination(From, To),
	botAction(2, From, To, Board, Player, TempBoard, TempPlayer), !,
	botSecondRandom(ring, TempBoard, TempPlayer, NewBoard, NewPlayer).

% ac��o do computador: realiza um movimento aleat�rio do tipo "colocar anel"
botRandomAction(3, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Board, Player, Position, ring),
	botAction(3, Position, Board, Player,TempBoard,TempPlayer), !,
	botSecondRandom(disc, TempBoard, TempPlayer, NewBoard, NewPlayer).

% ac��o do computador: realiza um movimento aleat�rio do tipo "mover anel"
botRandomAction(4, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, ring, Player, From),
	botRandomDestination(From, To),
	botAction(4, From, To, Board, Player, TempBoard,TempPlayer), !,
	botSecondRandom(disc, TempBoard, TempPlayer, NewBoard, NewPlayer).

% ac��o do computador: fallback
botRandomAction(_, Board, Player, NewBoard, NewPlayer):-
	botRandomMove(Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ac��o do computador: realiza um segundo movimento aleat�rio com um disco
botSecondRandom(disc, Board, Player, NewBoard, NewPlayer):-
	random(1, 11, Action),
	Action > 5, !,
	botRandomPlace(Board, Player, Position, disc),
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).
botSecondRandom(disc, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, disc, Player, From),
	botRandomDestination(From, To),
	botAction(2, From, To, Board, Player, NewBoard, NewPlayer).

% ac��o do computador: realiza um segundo movimento aleat�rio com um anel
botSecondRandom(ring, Board, Player, NewBoard, NewPlayer):-
	random(1, 11, Action),
	Action > 5, !,
	botRandomPlace(Board, Player, Position, ring),
	botAction(3, Position, Board, Player, NewBoard, NewPlayer).
botSecondRandom(ring, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, ring, Player, From),
	botRandomDestination(From, To),
	botAction(4, From, To, Board, Player, NewBoard, NewPlayer).

% ac��o do computador: fallback
botSecondRandom(Piece, Board, Player, NewBoard, NewPlayer):-
	botSecondRandom(Piece, Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ac��o do computador: realiza um segundo movimento ganancioso com um disco
botSecondSmart(disc, Board, Player, NewBoard, NewPlayer):-
	random(1, 11, Action),
	Action > 5,
	botSmartPlaceDisc(Board, Player, Position),
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).
botSecondSmart(disc, Board, Player, NewBoard, NewPlayer):-
	botSmartMoveDisc(Board, Player, From, To),
	botAction(2, From, To, Board, Player, NewBoard, NewPlayer).

% ac��o do computador: realiza um segundo movimento ganancioso com um anel
botSecondSmart(ring, Board, Player, NewBoard, NewPlayer):-
	random(1, 11, Action),
	Action > 5,
	botSmartPlaceRing(Board, Player, Position),
	botAction(3, Position, Board, Player, NewBoard, NewPlayer).
botSecondSmart(ring, Board, Player, NewBoard, NewPlayer):-
	botSmartMoveRing(Board, Player, From, To),
	botAction(4, From, To, Board, Player, NewBoard, NewPlayer).

% ac��o do computador: fallback
botSecondSmart(Piece, Board, Player, NewBoard, NewPlayer):-
	botSecondSmart(Piece, Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ac��o do computador: realiza um movimento ganancioso do tipo "colocar disco"
botSmartAction(1, Board, Player, NewBoard, NewPlayer):-
	botSmartPlaceDisc(Board, Player, Position),
	botAction(1, Position, Board, Player, TempBoard, TempPlayer), !,
	botSecondSmart(ring, TempBoard, TempPlayer, NewBoard, NewPlayer).

% ac��o do computador: realiza um movimento ganancioso do tipo "mover disco"
botSmartAction(2, Board, Player, NewBoard, NewPlayer):-
	botSmartMoveDisc(Board, Player, From, To),
	botAction(2, From, To, Board, Player, TempBoard, TempPlayer), !,
	botSecondSmart(ring, TempBoard, TempPlayer, NewBoard, NewPlayer).

% ac��o do computador: realiza um movimento ganancioso do tipo "colocar anel"
botSmartAction(3, Board, Player, NewBoard, NewPlayer):-
	botSmartPlaceRing(Board, Player, Position),
	botAction(3, Position, Board, Player,TempBoard,TempPlayer), !,
	botSecondSmart(disc, TempBoard, TempPlayer, NewBoard, NewPlayer).

% ac��o do computador: realiza um movimento ganancioso do tipo "mover anel"
botSmartAction(4, Board, Player, NewBoard, NewPlayer):-
	botSmartMoveRing(Board, Player, From, To),
	botAction(4, From, To, Board, Player, TempBoard, TempPlayer), !,
	botSecondSmart(disc, TempBoard, TempPlayer, NewBoard, NewPlayer).

% ac��o do computador: fallback
botSmartAction(_, Board, Player, NewBoard, NewPlayer):-
	botSmartMove(Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verifica se o computador pode mover um anel da posi��o (FromX,FromY) para (ToX,ToY)
botCanMoveRing(FromX-FromY, ToX-ToY, Board, Player):-
	getSymbol(FromX, FromY, Board, Source),
	getSymbol(ToX, ToY, Board, Destination),
	getPlayerColor(Player, Color),
	isRing(Source, Color), !,
	isSingleDisc(Destination).

% verifica se o computador pode mover um disco da posi��o (FromX,FromY) para (ToX,ToY)
botCanMoveDisc(FromX-FromY, ToX-ToY, Board, Player):-
	getSymbol(FromX, FromY, Board, Source),
	getSymbol(ToX, ToY, Board, Destination),
	getPlayerColor(Player, Color),
	isDisc(Source, Color), !,
	isSingleRing(Destination).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gera aleatoriamente uma c�lula de origem v�lida
botRandomSource(Board, Piece, Player, Position):-
	getPlayerColor(Player, Color),
	botScanMatrix(Board, Piece, Color, Lista), !,
	list_size(Lista, Tamanho), !,
	generatePosition(Lista, Tamanho, Position), !.

% gera aleatoriamente uma c�lula de destino v�lida
botRandomDestination(X-Y, Position):-
	scanNeighbors(X-Y, Lista), !,
	list_size(Lista, Tamanho),
	generatePosition(Lista, Tamanho, Position), !.

% verifica se existem jogadas restantes, procurando c�lulas vazias no tabuleiro
botRandomPlace(Board, Player, Position, _Piece):-
	\+isPlayerStuck(Board, Player), !,
	scanEmptyCells(Board, Lista, Tamanho),
	generatePosition(Lista, Tamanho, Position), !.

% caso contr�rio, procura an�is no tabuleiro onde colocar um disco
botRandomPlace(Board, _Player, Position, disc):-
	write('PLAYER IS STUCK'),
	scanSingleRings(Board, Lista, Tamanho),
	Tamanho > 0, !,
	generatePosition(Lista, Tamanho, Position), !.

% caso contr�rio, procura discos no tabuleiro onde colocar um anel
botRandomPlace(Board, _Player, Position, ring):-
	write('PLAYER IS STUCK'),
	scanSingleDiscs(Board, Lista, Tamanho),
	Tamanho > 0, !,
	generatePosition(Lista, Tamanho, Position), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% encontra todas as pe�as do tabuleiro que sejam discos pretos
botScanMatrix(Board, disc, black, Lista):-
	scanMatrix(Board, 1, 1, isSingleBlackDisc, Lista).

% encontra todas as pe�as do tabuleiro que sejam discos brancos
botScanMatrix(Board, disc, white, Lista):-
	scanMatrix(Board, 1, 1, isSingleWhiteDisc, Lista).

% encontra todas as pe�as do tabuleiro que sejam an�is pretos
botScanMatrix(Board, ring, black, Lista):-
	scanMatrix(Board, 1, 1, isSingleBlackRing, Lista).

% encontra todas as pe�as do tabuleiro que sejam an�is brancos
botScanMatrix(Board, ring, white, Lista):-
	scanMatrix(Board, 1, 1, isSingleWhiteRing, Lista).