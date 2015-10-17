

generateMatrix(0, [[]]).
generateMatrix(Size, Matrix):- 
	generateMatrix(Size, Size, Matrix).

generateMatrix(_, 0, []).
generateMatrix(Size, Rows, [Row | Tail]):- 
	generateList(Size, Row), 
	NextRow is Rows - 1, 
	generateMatrix(Size, NextRow, Tail).

generateList(0, []).
generateList(Size, [0 | Result]):- 
	NextIndex is Size - 1, 
	generateList(NextIndex, Result).

%===============================%
%		MATRIX OPERATIONS		%
%===============================%

matrix_clear(X, Y, Board, NewBoard) :-
	matrix_set(X, Y, 0, Board, NewBoard).

matrix_set(1, Y, NewElem, [OldRow|Tail], [NewRow|Tail]):-
	list_set(Y, NewElem, OldRow, NewRow).

matrix_set(X, Y, NewElem, [OldRow|Tail], [OldRow|NewTail]):-
	X > 1,
	X1 is X-1,
	matrix_set(X1, Y, NewElem, Tail, NewTail).

matrix_move(FromX, FromY, ToX, ToY, Symbol, Matrix, NewMatrix):-
	matrix_set(ToX, ToY, Symbol, Matrix, TempMatrix),
	matrix_set(FromX, FromY, 0, TempMatrix, NewMatrix).

matrix_at(X, Y, List, Symbol):-
	X > 0, 
	list_at(X, List, Row),
	list_at(Y, Row, Symbol).

matrix_replace(_, _, [], []).
matrix_replace(A, B, [Line|RL], [ResLine|ResRL]):-
	list_replace(A, B, Line, ResLine),
	matrix_replace(A, B, RL, ResRL).

%===============================%
%		LIST OPERATIONS			%
%===============================%

list_push([], Symbol, [Symbol]).
list_push([H|T], Symbol, [H|NT]):- 
	list_push(T, Symbol, NT).

list_size([], 0).
list_size([_|T], Size):- 
	list_size(T, TailSize), 
	Size is TailSize + 1.

list_set(1, Symbol, [_|L], [Symbol|L]).
list_set(I, Symbol, [H|L], [H|Result]):-
	I > 1,
	I1 is I-1,
	list_set(I1, Symbol, L, Result).

list_at(1, [H|_], H).
list_at(X, [_|T], Symbol):-
	X > 1,
	X1 is X - 1,
	list_at(X1, T, Symbol).

list_replace(_, _, [], []).
list_replace(A, B, [A|L1], [B|L2]):- list_replace(A, B, L1, L2).
list_replace(A, B, [C|L1], [C|L2]):-
	C \= A,
	list_replace(A, B, L1, L2).