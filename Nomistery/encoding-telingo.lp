% truck(T) :- fuel(T,_).
truck(T) :- fuel(T,_).

% package(P) :- at(P,L), not truck(P).
package(P) :- at(P,L), not truck(P).

% location(L) :- fuelcost(_,L,_).
location(L) :- fuelcost(_,L,_).

% location(L) :- fuelcost(_,_,L).
location(L) :- fuelcost(_,_,L).

% locatable(O) :- at(O,L).
locatable(O) :- at(O,L).

% at(O,L,0) :- at(O,L).
at_t(O,L) :- at(O,L).

% fuel(T,F,0) :- fuel(T,F).
fuel_t(T,F) :- fuel(T,F).

% action(unload(P,T,L)) :- package(P), truck(T), location(L).
action(unload(P,T,L)) :- package(P), truck(T), location(L).

% action(load(P,T,L)) :- package(P), truck(T), location(L).
action(load(P,T,L)) :- package(P), truck(T), location(L).

% action(drive(T,L1,L2)) :- fuelcost(Fueldelta,L1,L2), truck(T).
action(drive(T,L1,L2)) :- fuelcost(Fueldelta,L1,L2), truck(T).

% #program step(t).
#program dynamic.

% 1 { occurs(A,t) : action(A) } 1.
1 { occurs(A) : _action(A) } 1.

% unload(P,T,L,t) :- occurs(unload(P,T,L),t).
unload(P,T,L) :- occurs(unload(P,T,L)).

% load(P,T,L,t) :- occurs(load(P,T,L),t).
load(P,T,L) :- occurs(load(P,T,L)).

% drive(T,L1,L2,t) :- occurs(drive(T,L1,L2),t).
drive(T,L1,L2) :- occurs(drive(T,L1,L2)).

% at(P,L,t) :- unload(P,T,L,t).
at_t(P,L) :- unload(P,T,L).

% del(in(P,T),t) :- unload(P,T,L,t).
del(in(P,T)) :- unload(P,T,L).

% del(at(P,L),t) :- load(P,T,L,t).
del(at_t(P,L)) :- load(P,T,L).

% in(P,T,t) :- load(P,T,L,t).
in(P,T) :- load(P,T,L).

% del(at(T,L1),t) :- drive(T,L1,L2,t).
del(at_t(T,L1)) :- drive(T,L1,L2).

% at(T,L2,t) :- drive(T,L1,L2,t).
at_t(T,L2) :- drive(T,L1,L2).

% del(fuel(T,Fuelpre),t) :- drive(T,L1,L2,t), fuel(T,Fuelpre,t-1).
del(fuel_t(T,Fuelpre)) :- drive(T,L1,L2), 'fuel_t(T,Fuelpre).

% fuel(T,Fuelpre - Fueldelta,t) :- drive(T,L1,L2,t), fuelcost(Fueldelta,L1,L2), fuel(T,Fuelpre,t-1), Fuelpre >= Fueldelta.
fuel_t(T,Fuelpre - Fueldelta) :- drive(T,L1,L2), _fuelcost(Fueldelta,L1,L2), 'fuel_t(T,Fuelpre), Fuelpre >= Fueldelta.

% at(O,L,t) :- at(O,L,t-1), not del(at(O,L),t).
at_t(O,L) :- 'at_t(O,L), not del(at_t(O,L)).

% in(P,T,t) :- in(P,T,t-1), not del(in(P,T),t).
in(P,T) :- 'in(P,T), not del(in(P,T)).

% fuel(T,Level,t) :- fuel(T,Level,t-1), not del(fuel(T,Level),t), truck(T).
fuel_t(T,Level) :- 'fuel_t(T,Level), not del(fuel_t(T,Level)), _truck(T).

% :- unload(P,T,L,t), not preconditions_u(P,T,L,t).
:- unload(P,T,L), not preconditions_u(P,T,L).

% preconditions_u(P,T,L,t) :- at(T,L,t-1), in(P,T,t-1), package(P), truck(T).
preconditions_u(P,T,L) :- 'at_t(T,L), 'in(P,T), _package(P), _truck(T).

% :- load(P,T,L,t), not preconditions_l(P,T,L,t).
:- load(P,T,L), not preconditions_l(P,T,L).

% preconditions_l(P,T,L,t) :- at(T,L,t-1), at(P,L,t-1).
preconditions_l(P,T,L) :- 'at_t(T,L), 'at_t(P,L).

% :- drive(T,L1,L2,t), not preconditions_d(T,L1,L2,t).
:- drive(T,L1,L2), not preconditions_d(T,L1,L2).

% preconditions_d(T,L1,L2,t) :- at(T,L1,t-1), fuel(T,Fuelpre,t-1), fuelcost(Fueldelta,L1,L2), Fuelpre >= Fueldelta.
preconditions_d(T,L1,L2) :- 'at_t(T,L1), 'fuel_t(T,Fuelpre), _fuelcost(Fueldelta,L1,L2), Fuelpre >= Fueldelta.

% #program check(t).
#program final.

% :- goal(P,L), not at(P,L,t), query(t).
:- _goal(P,L), not at_t(P,L).