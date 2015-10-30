%===========================%
%	   	  MENU CLASS		%
%===========================%

%		------- %
% #includes		%
%		------- %

:- include('duplohex.pl').

%		------- %
% #predicados 	%
%		------- %

printMainMenu:- nl,
	write('+================================+'), nl,
	write('+       ..:: DUPLOHEX ::..       +'), nl,
	write('+================================+'), nl,
	write('|                                |'), nl,
	write('|   1. Start                     |'), nl,
	write('|   2. Instructions              |'), nl,
	write('|   3. About                     |'), nl,
	write('|                                |'), nl,
	write('|   4. <- Exit                   |'), nl,
	write('|                                |'), nl,
	write('+================================+'), nl, nl,
	write('Please choose an option:'), nl.

printColorMenu:- nl,
        write('+===============================+'), nl,
        write('+    ..:: SELECT COLOR ::..     +'), nl,
	write('+===============================+'), nl,
	write('|                               |'), nl,
	write('|   1. Black                    |'), nl,
	write('|   2. White                    |'), nl,
	write('|                               |'), nl,
	write('|   3. <- Back                  |'), nl,
	write('|                               |'), nl,
	write('+===============================+'), nl, nl,
	write('Please choose an option:'), nl.

printGameMenu:- nl,
	write('+===============================+'), nl,
	write('+     ..:: SELECT MODE ::..     +'), nl,
	write('+===============================+'), nl,
	write('|                               |'), nl,
	write('|   1. Player vs. Player        |'), nl,
	write('|   2. Player vs. Computer      |'), nl,
	write('|   3. Computer vs. Computer    |'), nl,
	write('|                               |'), nl,
	write('|   4. <- Back                  |'), nl,
	write('|                               |'), nl,
	write('+===============================+'), nl, nl,
	write('Please choose an option:'), nl.

mainMenu:-
	printMainMenu,
	getInt(Input),
	mainMenuAction(Input).

mainMenuAction(1):- colorMenu, mainMenu.
mainMenuAction(2):- helpMenu, mainMenu.
mainMenuAction(3):- aboutMenu, mainMenu.
mainMenuAction(4).
mainMenuAction(_):-
	nl, write('ERROR: you have entered an invalid value...'), nl,
	pressEnterToContinue,
	mainMenu.

colorMenu:-
	printColorMenu,
	getInt(Input),
	colorMenuAction(Input).

colorMenuAction(1):- gameMenu(blackPlayer), mainMenu.
colorMenuAction(2):- gameMenu(whitePlayer), mainMenu.
colorMenuAction(3).
colorMenuAction(_):-
	nl, write('ERROR: you have entered an invalid value...'), nl,
	pressEnterToContinue,
	colorMenu.

gameMenu(Player):-
	printGameMenu,
	getInt(Input),
	gameMenuAction(Input, Player).

gameMenuAction(1, Player):- startPvPGame(Player), mainMenu.
gameMenuAction(2, Player):- startPvBGame(Player), mainMenu.
gameMenuAction(3, Player):- startBvBGame(Player), mainMenu.
gameMenuAction(4, _).
gameMenuAction(_, Player):-
	nl, write('ERROR: you have entered an invalid value...'), nl,
	pressEnterToContinue,
	gameMenu(Player).

startPvPGame(Player):-
        initializePvP(Game, Player),
        getGameMode(Game, Mode), !,
        playGame(Game).

startPvBGame(Player):-
	initializePvB(Game, Player),
        getGameMode(Game, Mode), !,
        playGame(Game).

startBvBGame(Player):-
	initializeBvB(Game, Player),
        getGameMode(Game, Mode), !,
        playGame(Game).

helpMenu:-
	write('+=================================================================+'), nl,
	write('+                ..:: GAME INSTRUCTIONS ::..                      +'), nl,
	write('+=================================================================+'), nl,
	write('|                                                                 |'), nl,
	write('|   DuploHex is a connection game related to Hex that includes    |'), nl,
	write('|   discs and rings. In order to play DuploHex you need an 7x7    |'), nl,
	write('|   Hex board, 25 black and 25 white rings, and 25 black and 25   |'), nl,
	write('|   white discs.                                                  |'), nl,
	write('|                                                                 |'), nl,
	write('|   Objective:                                                    |'), nl,
	write('|     Each player must connect the two opposing sides of the      |'), nl,
	write('|     board marked by their colors either with their discs or     |'), nl,
	write('|     their rings.                                                |'), nl,
	write('|                                                                 |'), nl,
	write('|   Start:                                                        |'), nl,
	write('|     Game starts with an empty board.                            |'), nl,
	write('|     White starts by placing one disc or ring on any cell.       |'), nl,
	write('|                                                                 |'), nl,
	write('|                                                                 |'), nl,
	write('|                                                   Page 1 of 3   |'), nl,
	write('|                                                                 |'), nl,
	write('+=================================================================+'), nl,
	nl, pressEnterToContinue, nl,

	write('+=================================================================+'), nl,
	write('+                ..:: GAME INSTRUCTIONS ::..                      +'), nl,
	write('+=================================================================+'), nl,
	write('|                                                                 |'), nl,
	write('|   Each player in turn must perform two mandatory actions:       |'), nl,
	write('|                                                                 |'), nl,
	write('|   1 : add one of her discs to an empty cell or move one of her  |'), nl,
	write('|       discs on the board into any ring located in a neighbour   |'), nl,
	write('|       cell (must not be already occupied by both)               |'), nl,
	write('|                                                                 |'), nl,
	write('|   2 : one of her rings to an empty cell or move one of her      |'), nl,
	write('|       rings on the board to a neighbour cell occupied by a      |'), nl,
	write('|       disc (must not be already occupied by both)               |'), nl,
	write('|                                                                 |'), nl,
	write('|    The disc-ring pair (a disc inside a ring) cannot be moved    |'), nl,
	write('|    for the rest of the game.                                    |'), nl,
	write('|                                                                 |'), nl,
	write('|                                                                 |'), nl,
	write('|                                                   Page 2 of 3   |'), nl,
	write('|                                                                 |'), nl,
	write('+=================================================================+'), nl,
	nl, pressEnterToContinue, nl,

	write('+=================================================================+'), nl,
	write('+                ..:: GAME INSTRUCTIONS ::..                      +'), nl,
	write('+=================================================================+'), nl,
	write('|                                                                 |'), nl,
	write('|   Players may not pass. Pieces cannot be stacked.               |'), nl,
	write('|                                                                 |'), nl,
	write('|   Finally, if a player cannot perform a legal action, she must  |'), nl,
	write('|   in her turn add one of their discs or rings on any cell of    |'), nl,
	write('|   the board occupied by a ring or a disc, respectively.         |'), nl,
	write('|                                                                 |'), nl,
	write('|   For a shorter game, you can play on a 6x6 board.              |'), nl,
	write('|   To set up such board simply fill two adjacent border rows     |'), nl,
	write('|   with rings and discs of the corresponding colour before the   |'), nl,
	write('|   game starts.                                                  |'), nl,
	write('|                                                                 |'), nl,
	write('|   DuploHex @ BoardGameGeek                                      |'), nl,
	write('|     https://boardgamegeek.com/boardgame/174474/duplohex         |'), nl,
	write('|                                                                 |'), nl,
	write('|                                                                 |'), nl,
	write('|                                                   Page 3 of 3   |'), nl,
	write('|                                                                 |'), nl,
	write('+=================================================================+'), nl,
	nl, pressEnterToContinue.

aboutMenu:- nl,
	write('+===============================+'), nl,
	write('+        ..:: ABOUT ::..        +'), nl,
	write('+===============================+'), nl,
	write('|                               |'), nl,
	write('|   FEUP / MIEIC                |'), nl,
	write('|   Ano Letivo 2015-2016        |'), nl,
	write('|                               |'), nl,
	write('|   Authors:                    |'), nl,
	write('|                               |'), nl,
	write('|    > Carlos Samouco           |'), nl,
	write('|      up201305187@fe.up.pt     |'), nl,
	write('|                               |'), nl,
	write('|    > Diogo Marques            |'), nl,
	write('|      up201305642@fe.up.pt     |'), nl,
	write('|                               |'), nl,
	write('+===============================+'), nl,
	nl, pressEnterToContinue.