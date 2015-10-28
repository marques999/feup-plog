generateMatrix(0, [[]]).
generateMatrix(Size, Matrix):-
	generateMatrix(Size, Size, Matrix).

generateMatrix(_, 0, []).
generateMatrix(Size, Current, [Row | Tail]):-
	generateList(Size, Row),
	Next is Current - 1,
	generateMatrix(Size, Next, Tail).

generateList(0, []).
generateList(Size, [0 | Result]):-
	NextIndex is Size - 1,
	generateList(NextIndex, Result).

%===============================%
%		MATRIX OPERATIONS		%
%===============================%

setSymbol(1, Y, NewElem, [OldRow|Tail], [NewRow|Tail]):-
	list_set(Y, NewElem, OldRow, NewRow).

setSymbol(X, Y, NewElem, [OldRow|Tail], [OldRow|NewTail]):-
	X > 1,
	X1 is X-1,
	setSymbol(X1, Y, NewElem, Tail, NewTail).

moveSymbol(FromX, FromY, ToX, ToY, Symbol, Board, NewBoard):-
	setSymbol(ToX, ToY, Symbol, Board, TempBoard),
	setSymbol(FromX, FromY, 0, TempBoard, NewBoard).

getSymbol(X, Y, List, Symbol):-
	X > 0,
	list_at(X, List, Row), !,
	list_at(Y, Row, Symbol).

%===============================%
%		LIST OPERATIONS			%
%===============================%

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
	X1 is X - 1, !,
	list_at(X1, T, Symbol).