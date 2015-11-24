:- use_module(library(clpfd)).

%=======================================%
%           MATRIX OPERATIONS           %
%=======================================%

% gera uma matriz quadrada de comprimento definido
matrix_generate(Length, Initial, List):-
	list_generate(Length, Initial, Row),
	list_generate(Length, Row, List), !.

% altera o elemento presente na posição de coordenadas (X,Y) de uma matriz
matrix_set(1-Y, NewElem, [OldRow|Tail], [NewRow|Tail]):-
	list_set(Y, NewElem, OldRow, NewRow).
matrix_set(X-Y, NewElem, [OldRow|Tail], [OldRow|NewTail]):-
	X > 1,
	X1 is X-1,
	matrix_set(X1, Y, NewElem, Tail, NewTail).

% obtém o elemento presente na posição de coordenadas (X,Y) de uma matriz
matrix_at(X, Y, List, Symbol):-
	X > 0,
	list_at(X, List, Row), !,
	list_at(Y, Row, Symbol), !.

getNumberBlack(Matrix, List):-
	once(list_at(0, Matrix, [_|List])).

getNumberWhite(Row, Matrix, List):-
	once(list_at(Row, Matrix, List)).


getBoardRow(Row, Matrix, Lista]):-
	list_at(Row, Matrix, Lista]).

%=======================================%
%            LIST OPERATIONS            %
%=======================================%

% gera uma lista de comprimento definido
list_generate(0, _, []).
list_generate(Length, Initial, [Initial|Lista]):-
	Length > 0,
	NewLength is Length - 1,
	list_generate(NewLength, Initial, Lista).

% determina o comprimento de uma lista
list_size([], 0).
list_size([_|T], Size):-
	list_size(T, TailSize),
	Size is TailSize + 1.

% altera o elemento presente na posição I de uma lista
list_set(0, Symbol, [_|L], [Symbol|L]).
list_set(I, Symbol, [H|L], [H|Result]):-
	I > 1,
	I1 is I-1, !,
	list_set(I1, Symbol, L, Result).

% obtém o elemento presente na posição I de uma lista
list_at(0, [H|_], H).
list_at(X, [_|T], Symbol):-
	X > 0,
	X1 is X - 1,
	list_at(X1, T, Symbol).