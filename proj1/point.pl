%===========================%
%		  POINT CLASS		%
%===========================%

%		------- %
% #predicados 	%
%		------- %

createPoint(0-0).
createPoint(X, Y, X-Y).

getX(X-_Y, X).
getY(_X-Y, Y).

setX(_X-Y, NewX, NewX-Y).
setY(X-_Y, NewY, X-NewY).