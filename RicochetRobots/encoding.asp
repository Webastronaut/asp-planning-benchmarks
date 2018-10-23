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

pos(R,1,I,0) :- pos(R,I,_).
pos(R,-1,J,0) :- pos(R,_,J).

barrier(I+1,J,west ) :- barrier(I,J,east ), dim(I), dim(J), dim(I+1).
barrier(I,J+1,north) :- barrier(I,J,south), dim(I), dim(J), dim(J+1).
barrier(I-1,J,east ) :- barrier(I,J,west ), dim(I), dim(J), dim(I-1).
barrier(I,J-1,south) :- barrier(I,J,north), dim(I), dim(J), dim(J-1). % was dim(I-1)

conn(D,I,J) :- dir(D,-1), dir(D,_,DJ), not barrier(I,J,D), dim(I), dim(J), dim(J+DJ).
conn(D,J,I) :- dir(D,1), dir(D,DI,_), not barrier(I,J,D), dim(I), dim(J), dim(I+DI).

#program step(t).
{ occurs(some_action,t) }.
1 <= { selectRobot(R,T) : robot(R) } <= 1 :- T=t, occurs(some_action,T).
1 <= { selectDir(D,O,T) : dir(D,O) } <= 1 :- T=t, occurs(some_action,T).

go(R,D,O,T) :- selectRobot(R,T), selectDir(D,O,T), T=t.
go_(R,O,T)   :- go(R,_,O,T), T=t.
go(R,D,T) :- go(R,D,_,T), T=t.

sameLine(R,D,O,RR,T)  :- go(R,D,O,T), pos(R,-O,L,T-1), pos(RR,-O,L,T-1), R != RR, T=t.
blocked(R,D,O,I+DI,T) :- go(R,D,O,T), pos(R,-O,L,T-1), not conn(D,L,I), dl(D,DI), dim(I), dim(I+DI), T=t.
blocked(R,D,O,L,T)    :- sameLine(R,D,O,RR,T), pos(RR,O,L,T-1), T=t.

reachable(R,D,O,I,   T) :- go(R,D,O,T), pos(R,O,I,T-1), T=t.
reachable(R,D,O,I+DI,T) :- reachable(R,D,O,I,T), not blocked(R,D,O,I+DI,T), dl(D,DI), dim(I+DI), T=t.

:- go(R,D,O,T), pos(R,O,I,T-1), blocked(R,D,O,I+DI,T), dl(D,DI), T=t.
:- go(R,D,O,T), go(R,DD,O,T-1), T=t.

pos(R,O,I,T) :- reachable(R,D,O,I,T), not reachable(R,D,O,I+DI,T), dl(D,DI), T=t.
pos(R,O,I,T) :- pos(R,O,I,T-1), not go_(R,O,T), T=t.

#program check(t).
:- target(R,I,_), not pos(R,1,I,X), query(X), X=t.
:- target(R,_,J), not pos(R,-1,J,X), query(X), X=t.

#show go/3.
#show selectDir/3.
#show blocked/5.
