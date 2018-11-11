steps(28).
time(0).
time(1).
time(2).
time(3).
time(4).
time(5).
time(6).
time(7).
time(8).
time(9).
time(10).
time(11).
time(12).
time(13).
time(14).
time(15).
time(16).
time(17).
time(18).
time(19).
time(20).
time(21).
time(22).
time(23).
time(24).
time(25).
time(26).
time(27).
time(28).
disk(1).
disk(2).
disk(3).
disk(4).
disk(5).
disk(6).
disk(7).
disk(8).
disk(9).
disk(10).
disk(11).
disk(12).
disk(13).
disk(14).
disk(15).
disk(16).
disk(17).
disk(18).
disk(19).
disk(20).
disk(21).
on0(7,1).
on0(11,2).
on0(12,11).
on0(13,12).
on0(14,13).
on0(15,14).
on0(16,15).
on0(17,16).
on0(18,17).
on0(19,18).
on0(20,19).
on0(21,20).
on0(8,3).
on0(9,8).
on0(10,9).
on0(5,4).
on0(6,5).
ongoal(16,1).
ongoal(17,16).
ongoal(18,17).
ongoal(19,18).
ongoal(20,19).
ongoal(21,20).
ongoal(11,2).
ongoal(12,11).
ongoal(13,12).
ongoal(14,3).
ongoal(15,14).
ongoal(5,4).
ongoal(6,5).
ongoal(7,6).
ongoal(8,7).
ongoal(9,8).
ongoal(10,9).
#include <incmode>.
% The meaning of the time predicate is self-evident. As for the disk
% predicate, there are k disks 1,2,...,k. Disks 1, 2, 3, 4 denote pegs.
% Disks 5, ... are "movable". The larger the number of the disk,
% the "smaller" it is.
%
% The program uses additional predicates:
% on(T,N,M), which is true iff at time T, disk M is on disk N
% move(t,N), which is true iff at time T, it is disk N that will be
% moved
% where(T,N), which is true iff at time T, the disk to be moved is moved
% on top of the disk N.
% goal, which is true iff the goal state is reached at time t
% steps(T), which is the number of time steps T, required to reach the goal (provided part of Input data)

% Read in data
on(0,N1,N) :- on0(N,N1).
%onG(K,N1,N) :- ongoal(N,N1), steps(K).

% Specify valid arrangements of disks
% Basic condition. Smaller disks are on larger ones

#program check(t).
:- t=T, on(T,N1,N), N1>=N.

% Specify a valid move (only for T<t)
% pick a disk to move

#program step(t).
{ occurs(some_action,T) } :- T=t.
1 { move(T,N) : disk(N) } 1 :- occurs(some_action,T), T=t.

% pick a disk onto which to move
1 { where(T,N) : disk(N) }1 :- occurs(some_action,T), T=t.

% pegs cannot be moved
:- move(T,N), N<5, T=t.

% only top disk can be moved
:- on(T-1,N,N1), move(T,N), T=t.

% a disk can be placed on top only.
:- on(T-1,N,N1), where(T,N), T=t.

% no disk is moved in two consecutive moves
:- move(T,N), move(TM1,N), TM1=T-1, T=t.

% Specify effects of a move
on(T,N1,N) :- move(T,N), where(T,N1), T=t.
on(T,N,N1) :- T=t,
              on(T-1,N,N1), not move(T,N1).

put(M,N,T) :- move(T,N), where(T,M), T=t.

%:- t=T, on(T,N1,N), N1>=N.

% Goal description
#program check(t).
:- not on(T,N,N1), ongoal(N1,N), query(T), T=t.
:- on(T,N,N1), not ongoal(N1,N), query(T), T=t.

#show put/3.
% Solution
%#show put(M,N,T) : move(T,N), where(T,M), T=t.
