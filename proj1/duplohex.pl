%===========================%
%		  GAME CLASS		%
%===========================%

%		------- %
% #includes		%
%		------- %

:- include('player.pl').
:- include('board.pl').
:- include('globals.pl').
:- include('display.pl').

%		------- %
% #factos 		%
%		------- %

testMatrix([
	[0, 1, 2, 1, 0, 0, 0],
	[0, 1, 2, 8, 9, 0, 5],
	[0, 1, 2, 4, 2, 5, 0],
	[6, 4, 1, 1, 2, 0, 0],
	[0, 2, 2, 1, 10, 0, 6],
	[0, 1, 2, 10, 5, 0, 0],
	[5, 1, 9, 1, 2, 5, 6]
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
% #predicados 	%
%		------- %

initializePvP(Game, Player1Color, Player2Color):-
	testMatrix(Board),
	Player1Color \= Player2Color,
	initializePlayer(Player1Color, Player1),
	initializePlayer(Player2Color, Player2),
	Game = Board-pvp-whitePlayer-Player1-Player2, !.

initializePvB(Game, Player1Color, Player2Color):-
	testMatrix(Board),
	Player1Color \= Player2Color,
	initializePlayer(Player1Color, Player1),
	initializePlayer(Player2Color, Player2),
	Game = Board-pvb-whitePlayer-Player1-Player2, !.

initializeBvB(Game, Player1Color, Player2Color):-
	testMatrix(Board),
	Player1Color \= Player2Color,
	initializePlayer(Player1Color, Player1),
	initializePlayer(Player2Color, Player2),
	Game = Board-bvb-whitePlayer-Player1-Player2, !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getGameBoard(Board-_Mode-_PlayerTurn-_Player1-_Player2, Board).
setGameBoard(_Board-Mode-PlayerTurn-Player1-Player2,
	NewBoard, NewBoard-Mode-PlayerTurn-Player1-Player2).

getGameMode(_Board-Mode-_PlayerTurn-_Player1-_Player2, Mode).
setGameMode(Board-_-PlayerTurn-Player1-Player2, 
	NewMode, Board-NewMode-PlayerTurn-Player1-Player2):-
	gameMode(NewMode).

getPlayerTurn(_Board-_Mode-PlayerTurn-_Player1-_Player2, PlayerTurn).
setPlayerTurn(Board-Mode-_PlayerTurn-Player1-Player2, 
	NewTurn, Board-Mode-NewTurn-Player1-Player2):-
	player(NewTurn).

getPlayer1(_Board-_Mode-_PlayerTurn-Player1-_Player2, Player1).
setPlayer1(Board-Mode-PlayerTurn-_Player1-Player2, 
	NewPlayer, Board-Mode-PlayerTurn-NewPlayer-Player2).

getPlayer2(_Board-_Mode-_PlayerTurn-_Player1-Player2, Player2).
setPlayer2(Board-Mode-PlayerTurn-Player1-_Player2, 
	NewPlayer, Board-Mode-PlayerTurn-Player1-NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

changePlayerTurn(Game, NewGame):-
	getPlayerTurn(Game, PlayerTurn),
	PlayerTurn == whitePlayer,
	setPlayerTurn(Game, blackPlayer, NewGame).

changePlayerTurn(Game, NewGame):-
	getPlayerTurn(Game, PlayerTurn),
	PlayerTurn == blackPlayer,
	setPlayerTurn(Game, whitePlayer, NewGame).

getCurrentPlayer(_Board-_Mode-PlayerTurn-Player1-_Player2, Player1):-
	getPlayerName(Player1, PlayerName),
	PlayerName == PlayerTurn.

getCurrentPlayer(_Board-_Mode-PlayerTurn-_Player1-Player2, Player2):-
	getPlayerName(Player2, PlayerName),
	PlayerName == PlayerTurn.

setCurrentPlayer(Board-Mode-PlayerTurn-Player1-Player2, NewPlayer,
	Board-Mode-PlayerTurn-NewPlayer-Player2):-
	getPlayerName(Player1, Player1Name),
	PlayerTurn == Player1Name.

setCurrentPlayer(Board-Mode-PlayerTurn-Player1-Player2, NewPlayer,
	Board-Mode-PlayerTurn-Player1-NewPlayer):-
	getPlayerName(Player2, Player2Name),
	PlayerTurn == Player2Name.

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
	getPlayerName(Player, PlayerName),
	getPlayerColor(PlayerName, Color),
	isDisc(Symbol, Color).
validateDiscOwnership(_X, _Y, _Board, _Player):-
	messageNotOwned.

validateRingOwnership(Symbol, Player):-
	getPlayerName(Player, PlayerName),
	getPlayerColor(PlayerName, Color),
	isRing(Symbol, Color).
validateRingOwnership(_X, _Y, _Board, _Player):-
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
	moveDisc(FromX, FromY, ToX, ToY, Board, NewBoard).

askMoveRing(Board, Player, NewBoard):-
	askSourceCell(FromX, FromY),
	getSymbol(FromX, FromY, Board, Source),
	validateSource(Source, ring), !,
	validateRingOwnership(Source, Player), !,
	askDestinationCell(ToX, ToY),
	validateBothCoordinates(FromX, FromY, ToX, ToY),
	getSymbol(ToX, ToY, Board, Destination),
	validateDestination(Destination, disc), !,
	moveRing(FromX, FromY, ToX, ToY, Board, NewBoard).

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
	messageDiscExists.
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
	messageRingExists.
validatePlaceRing(_X, _Y, _Board, _Player).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askPlaceDisc(Board, Player, NewBoard, NewPlayer):-
	askDestinationCell(X, Y),
	validatePlaceDisc(X, Y, Board, Player), !,
	getPlayerName(Player, Name),
	getPlayerColor(Name, Color),
	placeDisc(X, Y, Color, Board, NewBoard),
	decrementDiscs(Player, NewPlayer).

askPlaceRing(Board, Player, NewBoard, NewPlayer):-
	askDestinationCell(X, Y),
	validatePlaceRing(X, Y, Board, Player), !,
	getPlayerName(Player, Name),
	getPlayerColor(Name, Color),
	placeRing(X, Y, Color, Board, NewBoard),
	decrementRings(Player, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

playGame:-
        initializePvP(Game, whitePlayer, blackPlayer),    
        getGameBoard(Game, Board),
        getCurrentPlayer(Game, Player),
        printState(Game),
        askInitialMove(Board, Player, NewBoard, NewPlayer), !,
        move(Game, NewBoard, NewPlayer, NewGame), !,
        playGame(NewGame).

playGame(Game):-
        getGameBoard(Game, Board),
        getCurrentPlayer(Game, Player),
        printState(Game),
        askMove(Board, Player, NewBoard, NewPlayer), !,
        move(Game, NewBoard, NewPlayer, NewGame), !, 
        playGame(NewGame).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

move(Game, Board, Player, NewGame):-
        setGameBoard(Game, Board, TempGame),
        setCurrentPlayer(TempGame, Player, TempGame2),
        changePlayerTurn(TempGame2, NewGame).
        
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

askMove(Board, Player, NewBoard, NewPlayer):-
	printBoard(Board),
	write('> SELECT FIRST MOVE:\t1. Place Disc'), nl,
	write('\t\t\t2. Place Ring'), nl,
	write('\t\t\t3. Move Disc'), nl,
	write('\t\t\t4. Move Ring'), nl,
	getInt(Choice),
	askMoveAction(Board, Player, Choice, NewBoard, NewPlayer).

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
	askMove(Board, Player, NewBoard, NewPlayer).
askMoveAction(Board, Player, _Choice, NewBoard, NewPlayer):-
	messageInvalidChoice, !,
	askMove(Board, Player, NewBoard, NewPlayer).

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