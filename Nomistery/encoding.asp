truck(T) :- fuel(T,_).
package(P) :- at(P,L), not truck(P).
location(L) :- fuelcost(_,L,_).
location(L) :- fuelcost(_,_,L).
locatable(O) :- at(O,L).
at(O,L,0) :- at(O,L).
fuel(T,F,0) :- fuel(T,F).

action(unload(P,T,L)) :- package(P), truck(T), location(L).
action(load(P,T,L)) :- package(P), truck(T), location(L).
action(drive(T,L1,L2)) :- fuelcost(Fueldelta,L1,L2), truck(T).

#program step(t).
1 { occurs(A,t) : action(A) } 1.

unload(P,T,L,t) :- occurs(unload(P,T,L),t).
load(P,T,L,t) :- occurs(load(P,T,L),t).
drive(T,L1,L2,t) :- occurs(drive(T,L1,L2),t).

at(P,L,t) :- unload(P,T,L,t).
del(in(P,T),t) :- unload(P,T,L,t).

del(at(P,L),t) :- load(P,T,L,t).
in(P,T,t) :- load(P,T,L,t).

del(at(T,L1),t) :- drive(T,L1,L2,t).
at(T,L2,t) :- drive(T,L1,L2,t).
del(fuel(T,Fuelpre),t) :- drive(T,L1,L2,t), fuel(T,Fuelpre,t-1).
fuel(T,Fuelpre - Fueldelta,t) :- drive(T,L1,L2,t), fuelcost(Fueldelta,L1,L2), fuel(T,Fuelpre,t-1), Fuelpre >= Fueldelta.

at(O,L,t) :- at(O,L,t-1), not del(at(O,L),t).
in(P,T,t) :- in(P,T,t-1), not del(in(P,T),t).
fuel(T,Level,t) :- fuel(T,Level,t-1), not del(fuel(T,Level),t), truck(T).

 :- unload(P,T,L,t), not preconditions_u(P,T,L,t).
preconditions_u(P,T,L,t) :- at(T,L,t-1), in(P,T,t-1), package(P), truck(T).

 :- load(P,T,L,t), not preconditions_l(P,T,L,t).
preconditions_l(P,T,L,t) :- at(T,L,t-1), at(P,L,t-1).

 :- drive(T,L1,L2,t), not preconditions_d(T,L1,L2,t).
preconditions_d(T,L1,L2,t) :- at(T,L1,t-1), fuel(T,Fuelpre,t-1), fuelcost(Fueldelta,L1,L2), Fuelpre >= Fueldelta.

#program check(t).
:- goal(P,L), not at(P,L,t), query(t).
