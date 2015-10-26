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

mainMenu:-
	printMainMenu,
	getChar(Input),
	mainMenuAction(Input).

mainMenuAction('1'):- gameMenu, mainMenu.
mainMenuAction('2'):- helpMenu, mainMenu.
mainMenuAction('3'):- aboutMenu, mainMenu.
mainMenuAction('4').
mainMenuAction(_):-
	write('ERROR: you have entered an invalid value...'), nl,
	pressEnterToContinue, nl,
	mainMenu.

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

gameMenu:-
	printGameMenu,
	getChar(Input),
	gameMenuAction(Input).

gameMenuAction('1'):- startPvPGame, mainMenu.
gameMenuAction('2'):- startPvBGame, mainMenu.
gameMenuAction('3'):- startBvBGame, mainMenu.
gameMenuAction('4').
gameMenuAction(_):-
	write('ERROR: you have entered an invalid value...'), nl,
	pressEnterToContinue, nl,
	gameMenu.

startPvPGame:-
	createPvPGame(Game),
	playGame(Game).

startPvBGame:-
	createPvBGame(Game),
	playGame(Game).

startBvBGame:-
	createBvBGame(Game),
	playGame(Game).

helpMenu:-
	write('+=================================================================+'), nl,
	write('+                ..:: GAME INSTRUCTIONS ::..                      +'), nl,
	write('+=================================================================+'), nl,
	write('=                                                                 ='), nl,
	write('=   Eximo is a member of the Checkers family.                     ='), nl,
	write('=                                                                 ='), nl,
	write('=   Objective:                                                    ='), nl,
	write('=     Capture all your opponent\'s pieces by jumping over them,    ='), nl,
	write('=     or stalemate the opponent so he has no moves.               ='), nl,
	write('=                                                                 ='), nl,
	write('=   Turn:                                                         ='), nl,
	write('=     In each turn, a player can make one of the two actions:     ='), nl,
	write('=     move or capture.                                            ='), nl,
	write('=                                                                 ='), nl,
	write('=   Move:                                                         ='), nl,
	write('=     A checker can move in 3 directions: forward or diagonally   ='), nl,
	write('=     forward (north, north-east or north-west).                  ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 1 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	nl, pressEnterToContinue, nl,

	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   There are two types of moves:                                 ='), nl,
	write('=     ordinary move and jumping move.                             ='), nl,
	write('=                                                                 ='), nl,
	write('=   Ordinary move: a checker moves to a (forward or diagonally    ='), nl,
	write('=      forward) adjacent and empty square.                        ='), nl,
	write('=                                                                 ='), nl,
	write('=   Jumping move: a checker moves to a (forward or diagonally     ='), nl,
	write('=     forward) adjacent friendly piece if the next square in      ='), nl,
	write('=     the same direction is empty, placing the jumping checker    ='), nl,
	write('=     on the next empty square. If the same player\'s checker      ='), nl,
	write('=     can continue moving by jumping another friendly piece       ='), nl,
	write('=     then it must do so. During the jumping move that checker    ='), nl,
	write('=     cannot capture.                                             ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 2 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	nl, pressEnterToContinue, nl,

	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   When there is more than one way to jump, the player may       ='), nl,
	write('=   choose which piece to jump with, and which jumping option     ='), nl,
	write('=   or sequence of jumps to make. The jumping sequence chosen     ='), nl,
	write('=   is not required to be the one which maximizes the number of   ='), nl,
	write('=   jumps; however, a player must make all available jumps in     ='), nl,
	write('=   the sequence chosen.                                          ='), nl,
	write('=                                                                 ='), nl,
	write('=   Capture:                                                      ='), nl,
	write('=     A checker can capture in 5 directions: forward,             ='), nl,
	write('=     diagonally forward, right or left (north, north-east,       ='), nl,
	write('=     north-west, east or west).                                  ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 3 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	nl, pressEnterToContinue, nl,

	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   A checker jumps over a (forward, diagonally forward, right    ='), nl,
	write('=   or left) adjacent opponent\'s piece if the next square in      ='), nl,
	write('=   the same direction is empty, placing the jumping checker on   ='), nl,
	write('=   the next empty square. The opponent\'s piece is removed from   ='), nl,
	write('=   the board immediately. If the same player\'s checker can       ='), nl,
	write('=   continue capturing by jumping another opponent\'s piece then   ='), nl,
	write('=   it must do so. Capturing is mandatory, and you must keep      ='), nl,
	write('=   capturing as long as it is possible.                          ='), nl,
	write('=                                                                 ='), nl,
	write('=   As in the jumping move, the player chooses freely which       ='), nl,
	write('=   jumping sequence to take.                                     ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 4 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	nl, pressEnterToContinue, nl,

	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   On the last row:                                              ='), nl,
	write('=   When a checker reaches the other end of the board, it is      ='), nl,
	write('=   removed from the board immediately and the player gets two    ='), nl,
	write('=   extra-moves to make instantly: dropping two new checkers in   ='), nl,
	write('=   any empty square in his own first two rows, except in the     ='), nl,
	write('=   four squares on the sides.                                    ='), nl,
	write('=   The drop zone for Black: b1, c1, d1, e1, f1, g1, b2, c2,      ='), nl,
	write('=   d2, e2, f2, g2; for White: b8, c8, d8, e8, f8, g8, b7, c7,    ='), nl,
	write('=   d7, e7, f7, g7).                                              ='), nl,
	write('=                                                                 ='), nl,
	write('=   If a checker reaches the other end of the board and there     ='), nl,
	write('=   isn\'t any empty square in the drop zone, the player loses     ='), nl,
	write('=   that piece. If there is just one empty square in the drop     ='), nl,
	write('=   zone, the player gets only one drop.                          ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 5 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	nl, pressEnterToContinue, nl.

aboutMenu:-
	write('+===============================+'), nl,
	write('+        ..:: ABOUT ::..        +'), nl,
	write('+===============================+'), nl,
	write('=                               ='), nl,
	write('=   FEUP                        ='), nl,
	write('=   MIEIC 2015/2016             ='), nl,
	write('=                               ='), nl,
	write('=   Authors:                    ='), nl,
	write('=    > Carlos Samouco           ='), nl,
	write('=    > Diogo Marques            ='), nl,
	write('=                               ='), nl,
	write('=                               ='), nl,
	write('+===============================+'), nl,
	nl, pressEnterToContinue, nl.