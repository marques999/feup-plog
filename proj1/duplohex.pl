%===========================%
%		  GAME CLASS		%
%===========================%

%		------- %
% #includes		%
%		------- %

:- include('player.pl').
:- include('board.pl').
:- include('bot.pl').
:- include('globals.pl').
:- include('display.pl').

%		------- %
% #factos		%
%		------- %

testMatrix([
	[0, 1, 2, 1, 0, 0, 0],
	[0, 1, 2, 8, 9, 0, 5],
	[0, 1, 1, 4, 2, 5, 0],
	[6, 4, 1, 1, 2, 0, 0],
	[0, 2, 1, 1, 10, 0, 6],
	[0, 1, 2, 10, 5, 0, 0],
	[5, 1, 9, 1, 2, 5, 6]
]).

emptyMatrix([
	[0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0]
]).

empty6x6Matrix([
	[1, 4, 4, 1, 4, 1, 1],
	[2, 0, 0, 0, 0, 0, 2],
	[8, 0, 0, 0, 0, 0, 8],
	[2, 0, 0, 0, 0, 0, 8],
	[8, 0, 0, 0, 0, 0, 2],
	[2, 0, 0, 0, 0, 0, 2],
	[1, 4, 1, 4, 1, 4, 8]
]).

testPath([
	[0, 1, 8, 1, 0, 0, 0],
	[0, 1, 8, 8, 9, 0, 5],
	[0, 1, 8, 4, 2, 5, 0],
	[6, 4, 8, 2, 2, 0, 0],
	[0, 2, 8, 1, 2, 0, 6],
	[0, 1, 8, 8, 8, 0, 0],
	[5, 1, 9, 8, 1, 5, 6]
]).

gameMode(pvp).
gameMode(pvb).
gameMode(bvb).

%		------- %
% #predicados	%
%		------- %

initializePvP(Game, Board, blackPlayer):-
	initializePlayer(blackPlayer, Player1),
	initializePlayer(whitePlayer, Player2),
	Game = Board-pvp-random-whitePlayer-Player1-Player2, !.
initializePvP(Game, Board, whitePlayer):-
	initializePlayer(whitePlayer, Player1),
	initializePlayer(blackPlayer, Player2),
	Game = Board-pvp-random-whitePlayer-Player1-Player2, !.

initializePvB(Game, Board, blackPlayer, BotMode):-
	initializePlayer(blackPlayer, Player1),
	initializePlayer(whitePlayer, Player2),
	Game = Board-pvb-BotMode-whitePlayer-Player1-Player2, !.
initializePvB(Game, Board, whitePlayer, BotMode):-
	initializePlayer(whitePlayer, Player1),
	initializePlayer(blackPlayer, Player2),
	Game = Board-pvb-BotMode-whitePlayer-Player1-Player2, !.

initializeBvB(Game, Board, blackPlayer, BotMode):-
	initializePlayer(blackPlayer, Player1),
	initializePlayer(whitePlayer, Player2),
	Game = Board-bvb-BotMode-whitePlayer-Player1-Player2, !.
initializeBvB(Game, Board, whitePlayer, BotMode):-
	initializePlayer(whitePlayer, Player1),
	initializePlayer(blackPlayer, Player2),
	Game = Board-bvb-BotMode-whitePlayer-Player1-Player2, !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getGameBoard(Board-_Mode-_BotMode-_PlayerTurn-_Player1-_Player2, Board).
setGameBoard(_Board-Mode-BotMode-PlayerTurn-Player1-Player2,
	NewBoard, NewBoard-Mode-BotMode-PlayerTurn-Player1-Player2).

getGameMode(_Board-Mode-_BotMode-_PlayerTurn-_Player1-_Player2, Mode).
setGameMode(Board-_Mode-BotMode-PlayerTurn-Player1-Player2,
	NewMode, Board-NewMode-BotMode-PlayerTurn-Player1-Player2):-
	gameMode(NewMode).

getBotMode(_Board-_Mode-BotMode-_PlayerTurn-_Player1-_Player2, BotMode).
setBotMode(Board-Mode-_BotMode-PlayerTurn-Player1-Player2,
	NewMode, Board-Mode-NewMode-PlayerTurn-Player1-Player2):-
	botMode(NewMode).

getPlayerTurn(_Board-_Mode-_BotMode-PlayerTurn-_Player1-_Player2, PlayerTurn).
setPlayerTurn(Board-Mode-BotMode-_PlayerTurn-Player1-Player2,
	NewTurn, Board-Mode-BotMode-NewTurn-Player1-Player2):-
	player(NewTurn).

getPlayer1(_Board-_Mode-_BotMode-_PlayerTurn-Player1-_Player2, Player1).
setPlayer1(Board-Mode-BotMode-PlayerTurn-_Player1-Player2,
	NewPlayer, Board-Mode-BotMode-PlayerTurn-NewPlayer-Player2).

getPlayer2(_Board-_Mode-_BotMode-_PlayerTurn-_Player1-Player2, Player2).
setPlayer2(Board-Mode-BotMode-PlayerTurn-Player1-_Player2,
	NewPlayer, Board-Mode-BotMode-PlayerTurn-Player1-NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

changePlayerTurn(Game, NewGame):-
	getPlayerTurn(Game, whitePlayer),
	setPlayerTurn(Game, blackPlayer, NewGame).

changePlayerTurn(Game, NewGame):-
	getPlayerTurn(Game, blackPlayer),
	setPlayerTurn(Game, whitePlayer, NewGame).

getCurrentPlayer(_Board-_Mode-_BotMode-PlayerTurn-Player1-_Player2, Player1):-
	getPlayerName(Player1, PlayerTurn).

getCurrentPlayer(_Board-_Mode-_BotMode-PlayerTurn-_Player1-Player2, Player2):-
	getPlayerName(Player2, PlayerTurn).

setCurrentPlayer(Board-Mode-BotMode-PlayerTurn-Player1-Player2, NewPlayer,
	Board-Mode-BotMode-PlayerTurn-NewPlayer-Player2):-
	getPlayerName(Player1, PlayerTurn).

setCurrentPlayer(Board-Mode-BotMode-PlayerTurn-Player1-Player2, NewPlayer,
	Board-Mode-BotMode-PlayerTurn-Player1-NewPlayer):-
	getPlayerName(Player2, PlayerTurn).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askSourceCell(X, Y):-
	write('Please insert the source cell coordinates and press <ENTER>:'), nl,
	getCoordinates(X, Y), validateCoordinates(X, Y), nl, !.

askDestinationCell(X, Y):-
	write('Please insert the destination cell coordinates and press <ENTER>:'), nl,
	getCoordinates(X, Y), validateCoordinates(X, Y), nl, !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validateSource(Symbol, _Piece):-
	isTwopiece(Symbol), !,
	messageSourceTwopiece.
validateSource(Symbol, disc):-
	isDisc(Symbol, _).
validateSource(_Symbol, disc):- !,
	messageSourceNotDisc.
validateSource(Symbol, ring):-
	isRing(Symbol, _).
validateSource(_Symbol, ring):- !,
	messageSourceNotRing.

validateDestination(Symbol, _Piece):-
	isTwopiece(Symbol), !,
	messageDestinationTwopiece.
validateDestination(Symbol, disc):-
	isDisc(Symbol, _).
validateDestination(_Symbol, disc):- !,
	messageDestinationNotDisc.
validateDestination(Symbol, ring):-
	isRing(Symbol, _).
validateDestination(_Symbol, ring):- !,
	messageDestinationNotRing.

validateCoordinates(X, Y):-
	X > 0, Y > 0,
	X < 8, Y < 8.
validateCoordinates(_X, _Y):-
	messageInvalidCoordinates.

validateBothCoordinates(FromX, FromY, FromX, FromY):-
	messageSameCoordinates.
validateBothCoordinates(FromX, FromY, ToX, ToY):-
	isNeighbour(FromX, FromY, ToX, ToY).
validateBothCoordinates(_FromX, _FromY, _ToX, _ToY):-
	messageNotNeighbours.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validateDiscOwnership(Symbol, Player):-
	getPlayerColor(Player, Color),
	isDisc(Symbol, Color).
validateDiscOwnership(_X, _Y):-
	messageNotOwned.

validateRingOwnership(Symbol, Player):-
	getPlayerColor(Player, Color),
	isRing(Symbol, Color).
validateRingOwnership(_X, _Y):-
	messageNotOwned.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askMoveDisc(Board, Player, NewBoard):-
	askSourceCell(FromX, FromY),
	getSymbol(FromX, FromY, Board, Source),
	validateSource(Source, disc), !,
	validateDiscOwnership(Source, Player), !,
	askDestinationCell(ToX, ToY),
	validateBothCoordinates(FromX, FromY, ToX, ToY),
	getSymbol(ToX, ToY, Board, Destination),
	validateDestination(Destination, ring), !,
	moveDisc(FromX-FromY, ToX-ToY, Board, NewBoard).

askMoveRing(Board, Player, NewBoard):-
	askSourceCell(FromX, FromY),
	getSymbol(FromX, FromY, Board, Source),
	validateSource(Source, ring), !,
	validateRingOwnership(Source, Player), !,
	askDestinationCell(ToX, ToY),
	validateBothCoordinates(FromX, FromY, ToX, ToY),
	getSymbol(ToX, ToY, Board, Destination),
	validateDestination(Destination, disc), !,
	moveRing(FromX-FromY, ToX-ToY, Board, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validatePlaceDisc(X, Y, Board, _Player):-
	getSymbol(X, Y, Board, Symbol),
	isTwopiece(Symbol), !,
	messageDestinationTwopiece.
validatePlaceDisc(_X, _Y, _Board, Player):-
	\+hasDiscs(Player), !,
	messageNoDiscs.
validatePlaceDisc(X, Y, Board, _Player):-
	\+canPlaceDisc(Board, X, Y), !,
	messagePieceExists.
validatePlaceDisc(_X, _Y, _Board, _Player).

validatePlaceRing(X, Y, Board, _Player):-
	getSymbol(X, Y, Board, Symbol),
	isTwopiece(Symbol), !,
	messageDestinationTwopiece.
validatePlaceRing(_X, _Y, _Board, Player):-
	\+hasRings(Player), !,
	messageNoRings.
validatePlaceRing(X, Y, Board, _Player):-
	\+canPlaceRing(Board, X, Y), !,
        messagePieceExists.
validatePlaceRing(_X, _Y, _Board, _Player).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askPlaceDisc(Board, Player, NewBoard, NewPlayer):-
	askDestinationCell(X, Y),
	validatePlaceDisc(X, Y, Board, Player), !,
	getPlayerColor(Player, Color),
	placeDisc(X-Y, Color, Board, NewBoard),
	decrementDiscs(Player, NewPlayer).

askPlaceRing(Board, Player, NewBoard, NewPlayer):-
	askDestinationCell(X, Y),
	validatePlaceRing(X, Y, Board, Player), !,
	getPlayerColor(Player, Color),
	placeRing(X-Y, Color, Board, NewBoard),
	decrementRings(Player, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startGame(Game, pvp):-
	getGameBoard(Game, Board),
	getCurrentPlayer(Game, Player),
	printState(Game),
	askInitialMove(Board, Player, NewBoard, NewPlayer), !,
	move(Game, NewBoard, NewPlayer, NewGame), !,
	playGame(NewGame, pvp).

startGame(Game, bvb):-
	getGameBoard(Game, Board),
	getCurrentPlayer(Game, Player),
	botInitialMove(Board, Player, NewBoard, NewPlayer), !,
	move(Game, NewBoard, NewPlayer, NewGame), !,
	printState(NewGame),
	pressEnterToContinue, nl,
	playGame(NewGame, bvb).

playGame(Game, _):-
	getCurrentPlayer(Game, Player),
	\+hasPieces(Player),
	gameOver(Player).

playGame(Game, pvp):-
	getGameBoard(Game, Board),
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	getCurrentPlayer(Game, Player),
	getPlayerTurn(Game, PlayerTurn),
	printState(Game),
	letHumanPlay(Board, Player, NewBoard, NewPlayer), !,
	move(Game, NewBoard, NewPlayer, NewGame), !,
	\+hasPlayerWon(NewBoard, PlayerTurn),
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	playGame(NewGame, pvp).

playGame(Game, pvb):-
	getGameBoard(Game, Board),
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	getCurrentPlayer(Game, Player1),
	letHumanPlay(Board, Player1, FirstBoard, FirstPlayer), !,
	move(Game, FirstBoard, FirstPlayer, FirstGame), !,
	printState(FirstGame),
	\+hasPlayerWon(FirstBoard, Player1),
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	getCurrentPlayer(Game, Player2),
	letBotPlay(FirstBoard, Player2, randomBot, SecondBoard, SecondPlayer), !,
	move(FirstGame, SecondBoard, SecondPlayer, SecondGame), !,
	printState(SecondGame),
	\+hasPlayerWon(FirstBoard, Player2),
	playGame(SecondGame, pvb).

playGame(Game, bvb):-
	getGameBoard(Game, Board),
	getBotMode(Game, BotMode),
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	getCurrentPlayer(Game, Player),
	letBotPlay(Board, Player, BotMode, NewBoard, NewPlayer), !,
	move(Game, NewBoard, NewPlayer, NewGame), !,
	printState(NewGame),
	pressEnterToContinue, nl,
	\+hasPlayerWon(NewBoard, Player),
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	playGame(NewGame, bvb).

playGame(Game, _):-
	getGameBoard(Game, Board),
	getPlayer1(Game, Player1),
	getPlayer2(Game, Player2),
	hasPlayerWon(Board, Player1), !,
	gameOver(Player2).

playGame(Game, _):-
	getGameBoard(Game, Board),
	getPlayer1(Game, Player1),
	getPlayer2(Game, Player2),
	hasPlayerWon(Board, Player2), !,
	gameOver(Player1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

move(Game, Board, Player, NewGame):-
	setGameBoard(Game, Board, TempGame),
	setCurrentPlayer(TempGame, Player, TempGame2),
	changePlayerTurn(TempGame2, NewGame).

gameOver(Player):-
	write('GAME OVER'),
	getPlayerName(Player, PlayerName),
	write(PlayerName),
	write(' WINS!!!'), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

letHumanPlay(Board, Player, NewBoard, NewPlayer):-
	write('> SELECT FIRST MOVE:\t1. Place Disc'), nl,
	write('\t\t\t2. Place Ring'), nl,
	write('\t\t\t3. Move Disc'), nl,
	write('\t\t\t4. Move Ring'), nl,
	getInt(Choice),
	askMoveAction(Board, Player, Choice, NewBoard, NewPlayer).

letBotPlay(Board, Player, random, NewBoard, NewPlayer):-
	botRandomMove(Board, Player, NewBoard, NewPlayer).

letBotPlay(Board, Player, smart, NewBoard, NewPlayer):-
	botSmartMove(Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askInitialMove(Board, Player, NewBoard, NewPlayer):-
	write('> SELECT INITIAL MOVE:\t1. Place Disc'), nl,
	write('\t\t\t2. Place Ring'), nl,
	getInt(Choice),
	askInitialAction(Board, Player, Choice, NewBoard, NewPlayer).

askInitialAction(Board, Player, 1, NewBoard, NewPlayer):-
	askPlaceDisc(Board, Player, NewBoard, NewPlayer).
askInitialAction(Board, Player, 2, NewBoard, NewPlayer):-
	askPlaceRing(Board, Player, NewBoard, NewPlayer).
askInitialAction(Board, Player, Choice, NewBoard, NewPlayer):-
	Choice > 0, Choice =< 2, !,
	askInitialMove(Board, Player, NewBoard, NewPlayer).
askInitialAction(Board, Player, _Choice, NewBoard, NewPlayer):-
	messageInvalidChoice, !,
	askInitialMove(Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askSecondMove(Board, Player, disc, NewBoard, NewPlayer):-
	printBoard(Board),
	write('> SELECT SECOND MOVE:\t1. Place Disc'), nl,
	write('\t\t\t2. Move Disc'), nl,
	getInt(Choice),
	askDiscAction(Board, Player, Choice, NewBoard, NewPlayer).

askSecondMove(Board, Player, ring, NewBoard, NewPlayer):-
	printBoard(Board),
	write('> SELECT SECOND MOVE:\t1. Place Ring'), nl,
	write('\t\t\t2. Move Ring'), nl,
	getInt(Choice),
	askRingAction(Board, Player, Choice, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askMoveAction(Board, Player, 1, NewBoard, NewPlayer):-
	askPlaceDisc(Board, Player, TempBoard, TempPlayer), !,
	askSecondMove(TempBoard, TempPlayer, ring, NewBoard, NewPlayer).
askMoveAction(Board, Player, 2, NewBoard, NewPlayer):-
	askPlaceRing(Board, Player, TempBoard, TempPlayer), !,
	askSecondMove(TempBoard, TempPlayer, disc, NewBoard, NewPlayer).
askMoveAction(Board, Player, 3, NewBoard, NewPlayer):-
	askMoveDisc(Board, Player, TempBoard), !,
	askSecondMove(TempBoard, Player, ring, NewBoard,  NewPlayer).
askMoveAction(Board, Player, 4, NewBoard, NewPlayer):-
	askMoveRing(Board, Player, TempBoard), !,
	askSecondMove(TempBoard, Player, disc, NewBoard, NewPlayer).
askMoveAction(Board, Player, Choice, NewBoard, NewPlayer):-
	Choice > 0, Choice =< 4, !,
	letHumanPlay(Board, Player, NewBoard, NewPlayer).
askMoveAction(Board, Player, _Choice, NewBoard, NewPlayer):-
	messageInvalidChoice, !,
	letHumanPlay(Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askDiscAction(Board, Player, 1, NewBoard, NewPlayer):-
	askPlaceDisc(Board, Player, NewBoard, NewPlayer).
askDiscAction(Board, Player, 2, NewBoard, _NewPlayer):-
	askMoveDisc(Board, Player, NewBoard).
askDiscAction(Board, Player, Choice, NewBoard, NewPlayer):-
	Choice > 0, Choice =< 2, !,
	askSecondMove(Board, Player, disc, NewBoard, NewPlayer).
askDiscAction(Board, Player, _Choice, NewBoard, NewPlayer):-
	messageInvalidChoice, !,
	askSecondMove(Board, Player, disc, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askRingAction(Board, Player, 1, NewBoard, NewPlayer):-
	askPlaceRing(Board, Player, NewBoard, NewPlayer).
askRingAction(Board, Player, 2, NewBoard, _NewPlayer):-
	askMoveRing(Board, Player, NewBoard).
askRingAction(Board, Player, Choice, NewBoard, NewPlayer):-
	Choice > 0, Choice =< 2, !,
	askSecondMove(Board, Player, ring, NewBoard, NewPlayer).
askRingAction(Board, Player, _Choice, NewBoard, NewPlayer):-
	messageInvalidChoice, !,
	askSecondMove(Board, Player, disc, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%