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

evaluateInteger([], ValueFim, ValueFinal, _):-
	ValueFinal is ValueFim // 10.

evaluateInteger([H|T], InitValue, ReturnValue, NumberLength):-
	NumberLength2 is NumberLength * 10,
	Ret1 is InitValue + (H - 48) * (10 * NumberLength),
	evaluateInteger(T,Ret1,ReturnValue,NumberLength2).

getInt(Input):-
	get_code(TempInput),
	get_code(_),
	Input is TempInput - 48.

getLine(Ret):-
	read_line(B),
	reverse(B, ReverseInput),
	evaluateInteger(ReverseInput, 0, Ret, 1).