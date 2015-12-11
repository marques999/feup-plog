%=======================================%
%                GLOBALS                %
%=======================================%

%                 ------------- %
% #includes                     %
%                 ------------- %

:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).

%                 ------------- %
% #predicados                   %
%                 ------------- %

initializeRandomSeed:-
	now(Usec),
	Seed is Usec mod 30269,
	getrand(random(X, Y, Z, _)),
	setrand(random(Seed, X, Y, Z)), !.

pressEnterToContinue:-
	write('Press <Enter> to continue...'), nl,
	get_code(_), !.

getInt(Input):-
	get_code(TempInput),
	get_code(_),
	Input is TempInput - 48.

getCoordinates(X, Y):-
	getInt(X),
	getInt(Y), !.