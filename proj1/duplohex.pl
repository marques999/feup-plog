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

messageInvalidChoice:-
	write('INVALID INPUT!'), nl,
	write('Please enter a valid number'), nl,
	pressEnterToContinue, nl.

messageSameCoordinates:-
	write('INVALID INPUT!'), nl,
	write('Source and destination cell coordinates must be different'), nl,
	pressEnterToContinue, nl, fail.

messageInvalidCoordinates:-
	write('INVALID INPUT!'), nl,
	write('Cell coordinates must be an integer between 0 and 7'), nl,
	pressEnterToContinue, nl, fail.

messageNoRings:-
	write('INVALID MOVE!'), nl,
	write('Player has no rings left to be played'), nl,
	pressEnterToContinue, nl, fail.

messageNoDiscs:-
	write('INVALID MOVE!'), nl,
	write('Player has no discs left to be played'), nl,
	pressEnterToContinue, nl, fail.

messageRingExists:-
	write('INVALID MOVE!'), nl,
	write('Destination cell should not be already occupied by a ring'), nl,
	pressEnterToContinue, nl, fail.

messageDiscExists:-
	write('INVALID MOVE!'), nl,
	write('Destination cell should not be already occupied by a disc'), nl,
	pressEnterToContinue, nl, fail.

messageSourceTwopiece:-
	write('INVALID MOVE!'), nl,
	write('Source cell is full and can\'t be moved (already occupied by two pieces)'), nl,
	pressEnterToContinue, nl, fail.

messageDestinationTwopiece:-
	write('INVALID MOVE!'), nl,
	write('Destination cell is full and can\'t be moved (already occupied by two pieces)'), nl,
	pressEnterToContinue, nl, fail.

messageNotOwned:-
	write('INVALID MOVE!'), nl,
	write('A player can only move his/her own pieces'), nl,
	pressEnterToContinue, nl, fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validateCoordinates(X, Y):- 
	X > 0, Y > 0,
	X < 8, Y < 8.
validateCoordinates(_X, _Y):-
	messageInvalidCoordinates.

askSourceCell(X, Y):-
	write('Please insert the source cell coordinates and press <ENTER>:'), nl,
	getCoordinates(X, Y), validateCoordinates(X, Y), nl, !.

askDestinationCell(X, Y):-
	write('Please insert the destination cell coordinates and press <ENTER>:'), nl,
	getCoordinates(X, Y), validateCoordinates(X, Y), nl, !.

validateBothCoordinates(FromX, FromY, FromX, FromY):-
	messageSameCoordinates.
validateBothCoordinates(_FromX, _FromY, _ToX, _ToY).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validateSource(X, Y, Board):-
	getSymbol(X, Y, Board, Symbol),
	isTwopiece(Symbol),
	messageSourceTwopiece.
validateSource(_X, _Y, _Board).

validateDestination(X, Y, Board):-
	getSymbol(X, Y, Board, Symbol),
	isTwopiece(Symbol),
	messageDestinationTwopiece.
validateDestination(_X, _Y, _Board).

invalidMove:-
	write('INVALID MOVE!'), nl,
	write('A checker can only move to a forward or a diagonally forward (north, north-east or north-west) adjacent empty cell.'), nl,
	write('A checker can jump over a friendly checker if the next cell in the same direction of the jump is empty.'), nl,
	write('Finally, a checker can capture an oponent\'s checker by jumping over them, similarly to the jumping move.'), nl,
	write('In addition to the three possible move/jumping directions, a capture can also occur to the sides (left or right).'), nl,
	pressEnterToContinue, nl,
	fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validateMoveDisc(FromX, FromY, _ToX, _ToY, Board, Player):-
	\+playerOwnsDisc(FromX, FromY, Board, Player),
	messageNotOwned.
validateMoveDisc(FromX, FromY, ToX, ToY, Board, _Player):-
	canMoveDisc(FromX, FromY, ToX, ToY, Board).
validateMoveDisc(_FromX, _FromY, _ToX, _ToY, _Board, _player):-
	invalidMove.

validateMoveRing(FromX, FromY, _ToX, _ToY, Board, Player):-
	\+playerOwnsRing(FromX, FromY, Board, Player),
	messageNotOwned.
validateMoveRing(FromX, FromY, ToX, ToY, Board, _Player):-
	canMoveRing(FromX, FromY, ToX, ToY, Board).
validateMoveRing(_FromX, _FromY, _ToX, _ToY, _Board, _Player):-
	invalidMove.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askMoveRing(Board, Player, NewBoard):-
	askSourceCell(FromX, FromY),
	validateSource(FromX, FromY, Board),
	askDestinationCell(ToX, ToY),
	validateDestination(ToX, ToY, Board),
	validateBothCoordinates(FromX, FromY, ToX, ToY),
	validateMoveRing(FromX, FromY, ToX, ToY, Board, Player),
	moveRing(FromX, FromY, ToX, ToY, Board, NewBoard).

askMoveDisc(Board, Player, NewBoard):-
	askSourceCell(FromX, FromY),
	vaidateSource(FromX, FromY, Board),
	askDestinationCell(ToX, ToY),
	validateDestination(ToX, ToY, Board),
	validateBothCoordinates(FromX, FromY, ToX, ToY),
	validateMoveDisc(FromX, FromY, ToX, ToY, Board, Player),
	moveDisc(FromX, FromY, ToX, ToY, Board, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askPlaceRing(Board, Player, NewBoard, NewPlayer):-
	askDestinationCell(X, Y),
	validatePlaceRing(X, Y, Board, Player), !,
	getPlayerName(Player, Name),
	getPlayerColor(Name, Color),
	placeRing(X, Y, Color, Board, NewBoard),
	decrementRings(Player, NewPlayer).

askPlaceDisc(Board, Player, NewBoard, NewPlayer):-
	askDestinationCell(X, Y),
	validatePlaceDisc(X, Y, Board, Player), !,
	getPlayerName(Player, Name),
	getPlayerColor(Name, Color),
	placeDisc(X, Y, Color, Board, NewBoard),
	decrementDiscs(Player, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askMoves(Game, NewGame):-
	getGameBoard(Game, Board),
	getCurrentPlayer(Game, Player),
	printTurn(Player),
	askFirstMove(Board, Player, NewBoard, NewPlayer), !,
	setGameBoard(Game, NewBoard, TempGame),
	setCurrentPlayer(TempGame, NewPlayer, NewGame),
	printBoard(NewBoard).

askFirstMove(Board, Player, NewBoard, NewPlayer):-
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
	Choice > 0, Choice =< 2, !,
	askFirstMove(Board, Player, NewBoard, NewPlayer).
askMoveAction(Board, Player, _Choice, NewBoard, NewPlayer):-
	messageInvalidChoice, !,
	askFirstMove(Board, Player, NewBoard, NewPlayer).

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