%===========================%
%		PLAYER CLASS		%
%===========================%

%		------- %
% #factos 		%
%		------- %

player(whitePlayer).
player(blackPlayer).

getPlayerColor(whitePlayer, white).
getPlayerColor(blackPlayer, black).

playerName(whitePlayer, 'WHITE PLAYER').
playerName(blackPlayer, 'BLACK PLAYER').

%		------- %
% #predicados 	%
%		------- %

initializePlayer(Name, NewState):-
	player(Name),
	NewState = playerState(Name, 24, 24).

resetPlayer(playerState(Name, _NumberDiscs, _NumberRings), NewState):-
	player(Name),
	NewState = playerState(Name, 24, 24).

getPlayerName(playerState(Name, _NumberDiscs, _NumberRings), Name).
getNumberDiscs(playerState(_Name, NumberDiscs, _NumberRings), NumberDiscs).
getNumberRings(playerState(_Name, _NumberDiscs, NumberRings), NumberRings).

hasRings(playerState(_Name, _NumberDiscs, NumberRings)):-
	NumberRings > 0.

hasDiscs(playerState(_Name, NumberDiscs, _NumberRings)):-
	NumberDiscs > 0.

decrementDiscs(playerState(Name, NumberDiscs, NumberRings), 
	playerState(Name, NewDiscs, NumberRings)):-
	NewDiscs is NumberDiscs - 1.

decrementRings(playerState(Name, NumberDiscs, NumberRings),
	playerState(Name, NumberDiscs, NewRings)):-
	NewRings is NumberRings - 1.