% dir(west,-1,0).
dir(west,-1,0).

% dir(east,1,0).
dir(east,1,0).

% dir(north,0,-1).
dir(north,0,-1).

% dir(south,0,1).
dir(south,0,1).

% dl(west,-1).
dl(west,-1).

% dl(north,-1).
dl(north,-1).

% dl(east,1).
dl(east,1).

% dl(south,1).
dl(south,1).

% dir(west,1).
dir(west,1).

% dir(east,1).
dir(east,1).

% dir(north,-1).
dir(north,-1).

% dir(south,-1).
dir(south,-1).

% robot(R) :- pos(R,_,_).
robot(R) :- pos(R,_,_).

% pos(R,1,I,0) :- pos(R,I,_).
pos_r(R,1,I) :- pos(R,I,_).

% pos(R,-1,J,0) :- pos(R,_,J).
pos_r(R,-1,J) :- pos(R,_,J).

% barrier(I+1,J,west) :- barrier(I,J,east), dim(I),dim(J), dim(I+1).
barrier(I+1,J,west) :- barrier(I,J,east), dim(I), dim(J), dim(I+1).

% barrier(I,J+1,north) :- barrier(I,J,south), dim(I), dim(J), dim(J+1).
barrier(I,J+1,north) :- barrier(I,J,south), dim(I), dim(J), dim(J+1).

% barrier(I-1,J,east) :- barrier(I,J,west), dim(I), dim(J), dim(I-1).
barrier(I-1,J,east) :- barrier(I,J,west), dim(I), dim(J), dim(I-1).

% barrier(I,J-1,south) :- barrier(I,J,north), dim(I), dim(J), dim(J-1).
barrier(I,J-1,south) :- barrier(I,J,north), dim(I), dim(J), dim(J-1).

% conn(D,I,J) :- dir(D,-1), dir(D,_,DJ), not barrier(I,J,D), dim(I), dim(J), dim(J+DJ).
conn(D,I,J) :- dir(D,-1), dir(D,_,DJ), not barrier(I,J,D), dim(I), dim(J), dim(J+DJ).

% conn(D,J,I) :- dir(D,1), dir(D,DI,_), not barrier(I,J,D), dim(I), dim(J), dim(I+DI).
conn(D,J,I) :- dir(D,1), dir(D,DI,_), not barrier(I,J,D), dim(I), dim(J), dim(I+DI).

% #program step(t).
#program dynamic.

% { occurs(some_action,t) }.
{ occurs(some_action) }.

% 1 <= { selectRobot(R,t) : robot(R) } <= 1 :- occurs(some_action,t).
1 <= { selectRobot(R) : _robot(R) } <= 1 :- occurs(some_action).

% 1 <= { selectDir(D,O,t) : dir(D,O) } <= 1 :- occurs(some_action,t).
1 <= { selectDir(D,O) : _dir(D,O) } <= 1 :- occurs(some_action).

% go(R,D,O,t) :- selectRobot(R,t), selectDir(D,O,t).
go(R,D,O) :- selectRobot(R), selectDir(D,O).

% go_(R,O,t)   :- go(R,_,O,t).
go_foo(R,O) :- go(R,_,O).

% go(R,D,t) :- go(R,D,_,t).
go(R,D) :- go(R,D,_).

% sameLine(R,D,O,RR,t)  :- go(R,D,O,t), pos(R,-O,L,t-1), pos(RR,-O,L,t-1), R != RR.
sameLine(R,D,O,RR)  :- go(R,D,O), 'pos_r(R,-O,L), 'pos_r(RR,-O,L), R != RR.

% blocked(R,D,O,I+DI,t) :- go(R,D,O,t), pos(R,-O,L,t-1), not conn(D,L,I), dl(D,DI), dim(I), dim(I+DI).
blocked(R,D,O,I+DI) :- go(R,D,O), 'pos_r(R,-O,L), not _conn(D,L,I), _dl(D,DI), _dim(I), _dim(I+DI).

% blocked(R,D,O,L,t)    :- sameLine(R,D,O,RR,t), pos(RR,O,L,t-1).
blocked(R,D,O,L)    :- sameLine(R,D,O,RR), 'pos_r(RR,O,L).

% reachable(R,D,O,I,t) :- go(R,D,O,t), pos(R,O,I,t-1).
reachable(R,D,O,I) :- go(R,D,O), 'pos_r(R,O,I).

% reachable(R,D,O,I+DI,t) :- reachable(R,D,O,I,t), not blocked(R,D,O,I+DI,t), dl(D,DI), dim(I+DI).
reachable(R,D,O,I+DI) :- reachable(R,D,O,I), not blocked(R,D,O,I+DI), _dl(D,DI), _dim(I+DI).

% :- go(R,D,O,t), pos(R,O,I,t-1), blocked(R,D,O,I+DI,t), dl(D,DI).
:- go(R,D,O), 'pos_r(R,O,I), blocked(R,D,O,I+DI), _dl(D,DI).

% :- go(R,D,O,t), go(R,DD,O,t-1).
:- go(R,D,O), 'go(R,DD,O).

% pos(R,O,I,t) :- reachable(R,D,O,I,t), not reachable(R,D,O,I+DI,t), dl(D,DI).
pos_r(R,O,I) :- reachable(R,D,O,I), not reachable(R,D,O,I+DI), _dl(D,DI).

% pos(R,O,I,t) :- pos(R,O,I,t-1), not go_(R,O,t).
pos_r(R,O,I) :- 'pos_r(R,O,I), not go_foo(R,O).

% #program check(t).
#program final.

%:- target(R,I,_), not pos(R,1,I,t), query(t).
:- _target(R,I,_), not pos_r(R,1,I).

% :- target(R,_,J), not pos(R,-1,J,t), query(t).
:- _target(R,_,J), not pos_r(R,-1,J).
