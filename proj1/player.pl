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

hasRings(playerState(Name, _NumberDiscs, NumberRings)):-
	player(Name),
	NumberRings > 0.

hasDiscs(playerState(Name, NumberDiscs, _NumberRings)):-
	player(Name),
	NumberDiscs > 0.

decrementDiscs(playerState(Name, NumberDiscs, _NumberRings), 
	playerState(Name, NewDiscs, _NumberRings)):-
	player(Name),
	NewDiscs is NumberDiscs - 1.

decrementRings(playerState(Name, _NumberDiscs, NumberRings),
	playerState(Name, _NumberDiscs, NewRings)):-
	player(Name),
	NewRings is NumberRings - 1.