%===========================%
%		  GAME CLASS		%
%===========================%

%		------- %
% #includes		%
%		------- %

:- include('player.pl').
:- include('board.pl').
:- include('display.pl').
:- include('globals.pl').

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

getGameBoard(Board-_-_-_-_, Board).
setGameBoard(_-Mode-PlayerTurn-Player1-Player2,
	NewBoard, NewBoard-Mode-PlayerTurn-Player1-Player2).

getGameMode(_-Mode-_-_-_, Mode).
setGameMode(Board-_-PlayerTurn-Player1-Player2, 
	NewMode, Board-NewMode-PlayerTurn-Player1-Player2):-
	gameMode(NewMode).

getPlayerTurn(_-_-PlayerTurn-_-_, PlayerTurn).
setPlayerTurn(Board-Mode-_-Player1-Player2, 
	NewTurn, Board-Mode-NewTurn-Player1-Player2):-
	player(NewTurn).

changePlayerTurn(Game, NewGame):-
	getPlayerTurn(Game, PlayerTurn),
	PlayerTurn == whitePlayer, !,
	setPlayerTurn(Game, blackPlayer, NewGame).

changePlayerTurn(Game, NewGame):-
	getPlayerTurn(Game, PlayerTurn),
	PlayerTurn == blackPlayer, !,
	setPlayerTurn(Game, whitePlayer, NewGame).

getPlayer1(_-_-_-Player1-_, Player1).
setPlayer1(Board-Mode-PlayerTurn-_-Player2, 
	NewPlayer, Board-Mode-PlayerTurn-NewPlayer-Player2).

getPlayer2(_-_-_-_-Player2, Player2).
setPlayer2(Board-Mode-PlayerTurn-Player1-_, 
	NewPlayer, Board-Mode-PlayerTurn-Player1-NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

validateBothCoordinates(FromX, FromY, FromX, FromY):- !, 
	messageSameCoordinates.
validateBothCoordinates(_, _, _, _).

validateCoordinates(X, Y):- 
	X > 0, X < 8,
	Y > 0, Y < 8.
validateCoordinates(_, _):-
	messageInvalidCoordinates.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validateMove(FromX, FromY, _, _, Board, _):-
	getSymbol(FromX, FromY, Board, Symbol),
	isTwopiece(Symbol),
	messageSourceTwopiece.

validateMove(_, _, ToX, ToY, Board, _):-
	getSymbol(ToX, ToY, Board, Symbol),
	isTwopiece(Symbol),
	messageDestinationTwopiece.

validateMove(FromX, FromY, ToX, ToY, Board, Player):-
	playerOwnsBoth(FromX, FromY, Board, Player), !,
	write('Player owns both pieces, please choose one:'), nl.

validateMove(FromX, FromY, ToX, ToY, Board, Player):-
	playerOwnsDisc(FromX, FromY, Board, Player), !,
	validateMoveDisc(FromX, FromY, ToX, ToY, Board).

validateMove(FromX, FromY, ToX, ToY, Board, Player):-
	playerOwnsRing(FromX, FromY, Board, Player), !,
	validateMoveRing(FromX, FromY, ToX, ToY, Board).

validateMove(_, _, _, _, _, _):- 
	messageNotOwned.

invalidMove:-
	write('INVALID MOVE!'), nl,
	write('A checker can only move to a forward or a diagonally forward (north, north-east or north-west) adjacent empty cell.'), nl,
	write('A checker can jump over a friendly checker if the next cell in the same direction of the jump is empty.'), nl,
	write('Finally, a checker can capture an oponent\'s checker by jumping over them, similarly to the jumping move.'), nl,
	write('In addition to the three possible move/jumping directions, a capture can also occur to the sides (left or right).'), nl,
	pressEnterToContinue, nl,
	fail.

validateMoveDisc(FromX, FromY, ToX, ToY, Board):-
	canMoveDisc(FromX, FromY, ToX, ToY, Board), !.
validateMoveDisc(_, _, _, _, _):-
	invalidMove.

validateMoveRing(FromX, FromY, ToX, ToY, Board):-
	canMoveRing(FromX, FromY, ToX, ToY, Board), !.
validateMoveRing(_, _, _, _, _):-
	invalidMove.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validatePlace(FromX, FromY, Board, _):-
	getSymbol(FromX, FromY, Board, Symbol),
	isTwopiece(Symbol),
	messageTwopiece.

validatePlaceRing(_X, _Y, _Board, Player):-
	\+hasRings(Player),
	messageNoRings.
validatePlaceRing(X, Y, Board, _):-
	canPlaceRing(Board, X, Y).
validatePlaceRing(_X, _Y, _Board, _Player):-
	messageRingExists.

validatePlaceDisc(_, _, _, Player):-
	\+hasDiscs(Player),
	messageNoDiscs.
validatePlaceDisc(X, Y, Board, _):-
	canPlaceDisc(Board, X, Y).
validatePlaceDisc(_X, _Y, _Board, _Player):-
	messageDiscExists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askMove(Game, NewGame):-
	getPlayerTurn(Game, Player),
	printTurn(Player),
	write('> SELECT MOVE:\t1. Place Disc'), nl,
	write('\t\t2. Place Ring'), nl,
	write('\t\t3. Move Disc'), nl,
	write('\t\t4. Move Ring'), nl,
	getInt(Type), nl,
	askMoveAction(Type).

askMoveAction(1).
askMoveAction(2).
askMoveAction(3).
askMoveAction(4).
askMoveAction(_):- fail.

askBothCoordinates(FromX, FromY, ToX, ToY):-
	askSourceCell(FromX, FromY), !,
	askDestinationCell(ToX, ToY), !,
	validateBothCoordinates(FromX, FromY, ToX, ToY).

askSourceCell(X, Y):-
	write('Please insert the source cell coordinates and press <ENTER>:'), nl,
	getCoordinates(X, Y), nl, !,
	validateCoordinates(X, Y).

askDestinationCell(X, Y):-
	write('Please insert the destination cell coordinates and press <ENTER>:'), nl,
	getCoordinates(X, Y), nl, !,
	validateCoordinates(X, Y).