dir(west,-1,0).
dir(east,1,0).
dir(north,0,-1).
dir(south,0,1).

dl(west,-1).
dl(north,-1).
dl(east,1).
dl(south,1).

dir(west,1).
dir(east,1).
dir(north,-1).
dir(south,-1).

robot(R) :- pos(R,_,_).

pos(R,1,I,0) :- pos(R,I,_).
pos(R,-1,J,0) :- pos(R,_,J).

barrier(I+1,J,west) :- barrier(I,J,east), dim(I),dim(J), dim(I+1).
barrier(I,J+1,north) :- barrier(I,J,south), dim(I), dim(J), dim(J+1).
barrier(I-1,J,east) :- barrier(I,J,west), dim(I), dim(J), dim(I-1).
barrier(I,J-1,south) :- barrier(I,J,north), dim(I), dim(J), dim(J-1). % was dim(I-1)

conn(D,I,J) :- dir(D,-1), dir(D,_,DJ), not barrier(I,J,D), dim(I), dim(J), dim(J+DJ).
conn(D,J,I) :- dir(D,1), dir(D,DI,_), not barrier(I,J,D), dim(I), dim(J), dim(I+DI).

#program step(t).
{ occurs(some_action,t) }.
1 <= { selectRobot(R,t) : robot(R) } <= 1 :- occurs(some_action,t).
1 <= { selectDir(D,O,t) : dir(D,O) } <= 1 :- occurs(some_action,t).

go(R,D,O,t) :- selectRobot(R,t), selectDir(D,O,t).
go_(R,O,t)   :- go(R,_,O,t).
go(R,D,t) :- go(R,D,_,t).

sameLine(R,D,O,RR,t)  :- go(R,D,O,t), pos(R,-O,L,t-1), pos(RR,-O,L,t-1), R != RR.
blocked(R,D,O,I+DI,t) :- go(R,D,O,t), pos(R,-O,L,t-1), not conn(D,L,I), dl(D,DI), dim(I), dim(I+DI).
blocked(R,D,O,L,t)    :- sameLine(R,D,O,RR,t), pos(RR,O,L,t-1).

reachable(R,D,O,I,t) :- go(R,D,O,t), pos(R,O,I,t-1).
reachable(R,D,O,I+DI,t) :- reachable(R,D,O,I,t), not blocked(R,D,O,I+DI,t), dl(D,DI), dim(I+DI).

:- go(R,D,O,t), pos(R,O,I,t-1), blocked(R,D,O,I+DI,t), dl(D,DI).
:- go(R,D,O,t), go(R,DD,O,t-1).

pos(R,O,I,t) :- reachable(R,D,O,I,t), not reachable(R,D,O,I+DI,t), dl(D,DI).
pos(R,O,I,t) :- pos(R,O,I,t-1), not go_(R,O,t).

#program check(t).
:- target(R,I,_), not pos(R,1,I,t), query(t).
:- target(R,_,J), not pos(R,-1,J,t), query(t).
