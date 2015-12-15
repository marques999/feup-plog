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

matrix_at(X,Y,List,Symbol):-
	nth0(X,List,Row),
	nth0(Y,Row,Symbol).

flatten([],[]).
flatten([[]|Gs],Fg):-
	flatten(Gs,Fg).
flatten([[G1|G1s]|Gs],[G1|Fg]):-
	flatten([G1s|Gs],Fg).

strip_zeros([],[]).
strip_zeros([Row|A],[Result|B]):-
	delete(Row,0,Temp),
	(Temp = [],	Result = [0] ; Result=Temp), !,
	strip_zeros(A,B).

sum_list(Xs,Sum):-
	sum_list(Xs,0,Sum).
sum_list([],Sum,Sum).
sum_list([X|Xs],Sum0,Sum):-
	Sum1 is Sum0 + X,
	sum_list(Xs,Sum1,Sum).

largest_sublist([],0).
largest_sublist([H|T],N):-
	largest_sublist(T,M1),
	length(H,M2),
	(M1 > M2, N is M1; N is M2), !.

list_at(0,[H|_],H).
list_at(X,[_|T],Symbol):-
	X > 0,
	X1 is X - 1,
	list_at(X1,T,Symbol).

list_subtract([], _, []).
list_subtract([A|C],B,D):-
	member(A,B),
	list_subtract(C,B,D).
list_subtract([A|B],C,[A|D]):-
	list_subtract(B,C,D).

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