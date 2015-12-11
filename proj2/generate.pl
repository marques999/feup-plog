%=======================================%
%            BOARD GENERATION           %
%=======================================%

%                 ------------- %
% #predicados                   %
%                 ------------- %

generateHints(Width, Height, Black, White):-
	generateMatrix(Board, Width, Height),
	generate_rows_hints(Board, RH),
	transpose(Board, Columns),
	generate_rows_hints(Columns, CH),
	strip_zeros(RH, White),
	strip_zeros(CH, Black).

generateHintsEmpty(Width, Height, Black, White):-
	generateEmptyMatrix(Board, Width, Height),
	generate_rows_hints(Board, RH),
	transpose(Board, Columns),
	generate_rows_hints(Columns, CH),
	strip_zeros(RH, White),
	strip_zeros(CH, Black).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

strip_zeros([],[]).
strip_zeros([Row|Rest],[Result|Rs]):-
	delete(Row,0,Temp),
	(Temp = [],
	Result = [0] ; Result=Temp), !,
	strip_zeros(Rest,Rs).

make_rows([],_).
make_rows([G|Gs], Width):-
	length(G, Width),
	make_rows(Gs, Width), !.

make_grid(Board, Width, Height):-
	length(Board, Height),
	make_rows(Board, Width), !.

generate_rows_hints([],[]).
generate_rows_hints([Row|Rest],[RH|RHs]):-
	generate_hints_for_row(Row,RH),
	generate_rows_hints(Rest,RHs).

generate_hints_for_row([],[0]).
generate_hints_for_row([0|Rest],[0|RHs]):-
	generate_hints_for_row(Rest,RHs).
generate_hints_for_row([1|Rest],[Head|RHs]):-
	generate_hints_for_row(Rest,[NextHead|RHs]),
	Head is NextHead+1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generateEmptyMatrix([], _, 0).
generateEmptyMatrix([H|T], Width, Height):-
	Height > 0,
	generateEmptyRow(H, Width),
	RemainingHeight is Height - 1,
	generateEmptyMatrix(T, Width, RemainingHeight), !.

generateEmptyRow([], 0).
generateEmptyRow([0|T],Width):-
	Width > 0,
	RemainingWidth is Width - 1,
	generateEmptyRow(T, RemainingWidth), !.

generateMatrix([], _, 0).
generateMatrix([H|T], Width, Height):-
	Height > 0,
	generateRow(H, Width),
	RemainingHeight is Height - 1,
	generateMatrix(T, Width, RemainingHeight), !.

generateRow([], 0).
generateRow([H|T], Width):-
	Width > 0,
	random(0, 2, H),
	RemainingWidth is Width - 1,
	generateRow(T, RemainingWidth), !.