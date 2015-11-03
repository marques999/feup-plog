%===========================%
%		PLAYER CLASS		%
%===========================%

%		------- %
% #factos		%
%		------- %

player(whitePlayer).
player(blackPlayer).

playerColor(whitePlayer, white).
playerColor(blackPlayer, black).

playerName(whitePlayer, 'WHITE PLAYER').
playerName(blackPlayer, 'BLACK PLAYER').

getPlayerName(playerState(Name, _NumberDiscs, _NumberRings), Name).
getNumberDiscs(playerState(_Name, NumberDiscs, _NumberRings), NumberDiscs).
getNumberRings(playerState(_Name, _NumberDiscs, NumberRings), NumberRings).

%		------- %
% #predicados	%
%		------- %

initializePlayer(Name, playerState(Name, 24, 24)):-
	player(Name).

resetPlayer(playerState(Name, _NumberDiscs, _NumberRings), playerState(Name, 24, 24)):-
	player(Name).

getPlayerColor(playerState(Name, _NumberDiscs, _NumberRings), Color):-
	playerColor(Name, Color).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hasDiscs(playerState(_Name, NumberDiscs, _NumberRings)):-
	NumberDiscs > 0.

hasPieces(playerState(_Name, NumberDiscs, NumberRings)):-
	NumberDiscs > 0, NumberRings > 0.

hasRings(playerState(_Name, _NumberDiscs, NumberRings)):-
	NumberRings > 0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

decrementDiscs(playerState(Name, NumberDiscs, NumberRings),
	playerState(Name, NewDiscs, NumberRings)):-
	NewDiscs is NumberDiscs - 1.

decrementRings(playerState(Name, NumberDiscs, NumberRings),
	playerState(Name, NumberDiscs, NewRings)):-
	NewRings is NumberRings - 1.