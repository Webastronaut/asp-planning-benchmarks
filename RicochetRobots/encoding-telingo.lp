#program initial.

% target(robot, col, row).

dir(west, -1, 0).
dir(east,  1, 0).
dir(north, 0,-1).
dir(south, 0, 1).

dl(west, -1).
dl(north,-1).
dl(east,  1).
dl(south, 1).

dir(west, 1).
dir(east, 1).
dir(north, -1).
dir(south, -1).

robot(R) :- pos(R,_,_).

pos_r(R,1,I) :- pos(R,I,_).
pos_r(R,-1,J) :- pos(R,_,J).

barrier(I+1,J,west ) :- barrier(I,J,east ), dim(I), dim(J), dim(I+1).
barrier(I,J+1,north) :- barrier(I,J,south), dim(I), dim(J), dim(J+1).
barrier(I-1,J,east ) :- barrier(I,J,west ), dim(I), dim(J), dim(I-1).
barrier(I,J-1,south) :- barrier(I,J,north), dim(I), dim(J), dim(J-1).

% connected rows
conn(D,I,J) :- dir(D,-1), dir(D,_,DJ), not barrier(I,J,D), dim(I), dim(J), dim(J+DJ).
% connected cols
conn(D,J,I) :- dir(D,1), dir(D,DI,_), not barrier(I,J,D), dim(I), dim(J), dim(I+DI).

#program dynamic.
{ occurs(some_action) }.
% select robot to move
1 <= { selectRobot(R) : _robot(R) } <= 1 :- occurs(some_action).
% select direction for movement
1 <= { selectDir(D,O) : _dir(D,O) } <= 1 :- occurs(some_action).

% generate go action 
go(R,D,O) :- selectRobot(R), selectDir(D,O).
go_foo(R,O) :- go(R,_,O).
go(R,D) :- go(R,D,_).

% robot R and robot RR share the same row/col L;
sameLine(R,D,O,RR)  :- go(R,D,O), 'pos_r(R,-O,L), 'pos_r(RR,-O,L), R != RR.
blocked(R,D,O,I+DI) :- go(R,D,O), 'pos_r(R,-O,L), not _conn(D,L,I), _dl(D,DI), _dim(I), _dim(I+DI).
blocked(R,D,O,L)    :- sameLine(R,D,O,RR), 'pos_r(RR,O,L).

reachable(R,D,O,I) :- go(R,D,O), 'pos_r(R,O,I).
reachable(R,D,O,I+DI) :- reachable(R,D,O,I), not blocked(R,D,O,I+DI), _dl(D,DI), _dim(I+DI).

:- go(R,D,O), 'pos_r(R,O,I), blocked(R,D,O,I+DI), _dl(D,DI).
:- go(R,D,O), 'go(R,DD,O).

pos_r(R,O,I) :- reachable(R,D,O,I), not reachable(R,D,O,I+DI), _dl(D,DI).
pos_r(R,O,I) :- 'pos_r(R,O,I), not go_foo(R,O).

#program final.
:- _target(R,I,_), not pos_r(R,1,I).
:- _target(R,_,J), not pos_r(R,-1,J).

#show go/2.
%#show selectDir/2.
%#show blocked/4.
