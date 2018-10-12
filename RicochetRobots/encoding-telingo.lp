%#const row =  1.
%#const col = -1.
% Problem description: https://www.mat.unical.it/aspcomp2013/RicochetRobot

#project initial.

dir(west, -1, 0).
dir(east,  1, 0).
dir(north, 0,-1).
dir(south, 0, 1).

dl(west, -1).
dl(north,-1).
dl(east,  1).
dl(south, 1).

dir(west, 1).   %dir(west, row).
dir(east, 1).   %dir(east, row).
dir(north, -1). %dir(north,col).
dir(south, -1). %dir(south,col).

dir(D) :- dir(D,_).

robot(R) :- pos(R,_,_).

pos(R,1,I) :- pos(R,I,_).  %pos(R,row,I,0) :- pos(R,I,_).
pos(R,-1,J) :- pos(R,_,J). %pos(R,col,J,0) :- pos(R,_,J).

barrier(I+1,J,west ) :- barrier(I,J,east ), dim(I), dim(J), dim(I+1).
barrier(I,J+1,north) :- barrier(I,J,south), dim(I), dim(J), dim(J+1).
barrier(I-1,J,east ) :- barrier(I,J,west ), dim(I), dim(J), dim(I-1).
barrier(I,J-1,south) :- barrier(I,J,north), dim(I), dim(J), dim(I-1).

conn(D,I,J) :- dir(D,-1), dir(D,_,DJ), not barrier(I,J,D), dim(I), dim(J), dim(J+DJ). %conn(D,I,J) :- dir(D,col), dir(D,_,DJ), not barrier(I,J,D), dim(I), dim(J), dim(J+DJ).
conn(D,J,I) :- dir(D,1), dir(D,DI,_), not barrier(I,J,D), dim(I), dim(J), dim(I+DI).  %conn(D,J,I) :- dir(D,row), dir(D,DI,_), not barrier(I,J,D), dim(I), dim(J), dim(I+DI).

%step(1..X) :- length(X).
%step(1).
%step(X+1) :- step(X), length(L), X < L. 

#program dynamic.

{ occurs(some_action) }.
1 <= { selectRobot(R) : _robot(R) } <= 1 :- occurs(some_action).
1 <= { selectDir(D,O) : _dir(D,O) } <= 1 :- occurs(some_action).

go(R,D,O) :- selectRobot(R), selectDir(D,O).
go_(R,O)   :- go(R,_,O).
go(R,D) :- go(R,D,_).

sameLine(R,D,O,RR)  :- go(R,D,O), 'pos(R,-O,L), 'pos(RR,-O,L), R != RR.
blocked(R,D,O,I+DI) :- go(R,D,O), 'pos(R,-O,L), not _conn(D,L,I), _dl(D,DI), _dim(I), _dim(I+DI).
blocked(R,D,O,L)    :- sameLine(R,D,O,RR), 'pos(RR,O,L).

reachable(R,D,O,I) :- go(R,D,O), 'pos(R,O,I).
reachable(R,D,O,I+DI) :- reachable(R,D,O,I), not blocked(R,D,O,I+DI), _dl(D,DI), _dim(I+DI).

:- go(R,D,O), 'pos(R,O,I), blocked(R,D,O,I+DI), _dl(D,DI).
:- go(R,D,O), 'go(R,DD,O).

pos(R,O,I) :- reachable(R,D,O,I), not reachable(R,D,O,I+DI), _dl(D,DI).
pos(R,O,I) :- 'pos(R,O,I), not go_(R,O).

selectDir(O) :- selectDir(D,O).

#program final.
%:- target(R,I,_), not pos(R,1,I,X), length(X).  
:- _target(R,I,_), not pos(R,1,I).
%:- target(R,_,J), not pos(R,-1,J,X), length(X). 
:- _target(R,_,J), not pos(R,-1,J).
