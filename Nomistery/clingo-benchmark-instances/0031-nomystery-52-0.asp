fuelcost(4,l0,l1).
fuelcost(16,l0,l2).
fuelcost(20,l0,l3).
fuelcost(4,l1,l0).
fuelcost(9,l1,l2).
fuelcost(14,l1,l3).
fuelcost(16,l2,l0).
fuelcost(9,l2,l1).
fuelcost(21,l2,l3).
fuelcost(20,l3,l0).
fuelcost(14,l3,l1).
fuelcost(21,l3,l2).
at(t0,l2).
fuel(t0,52).
at(p0,l2).
at(p1,l1).
at(p2,l3).
at(p3,l2).
goal(p0,l0).
goal(p1,l0).
goal(p2,l2).
goal(p3,l1).
step(1).
step(2).
step(3).
step(4).
step(5).
step(6).
step(7).
step(8).
step(9).
step(10).
step(11).
step(12).
step(13).
step(14).
step(15).
step(16).
step(17).
step(18).
step(19).
step(20).
step(21).
step(22).
step(23).
step(24).
step(25).
step(26).
step(27).
step(28).
step(29).
step(30).
step(31).
step(32).
step(33).
step(34).
step(35).
step(36).
step(37).
step(38).
step(39).
step(40).
#include <incmode>.

truck(T) :- fuel(T,_).
package(P) :- at(P,L), not truck(P).
location(L) :- fuelcost(_,L,_).
location(L) :- fuelcost(_,_,L).
locatable(O) :- at(O,L).
at(O,L,0) :- at(O,L).
fuel(T,F,0) :- fuel(T,F).

action(unload(P,T,L))  :- package( P ), truck( T ), location( L ).
action(load(P,T,L))    :- package( P ), truck( T ), location( L ).
action(drive(T,L1,L2)) :- fuelcost( Fueldelta,L1,L2 ) , truck( T ).

#program step(t).

{ occurs(A,S) : action(A) } <= 1 :- S=t.

done(S) :- occurs(A,S), S=t.
:- done(S), not done(S-1), 1 < S, S=t.

unload( P,T,L,S )  :- occurs(unload(P,T,L),S), S=t.
load( P,T,L,S )    :- occurs(load(P,T,L),S), S=t.
drive( T,L1,L2,S ) :- occurs(drive(T,L1,L2),S), S=t.

at( P,L,S ) :- unload( P,T,L,S ), S=t.
del( in( P,T ),S ) :- unload( P,T,L,S ), S=t.

del( at( P,L ),S ) :- load( P,T,L,S ), S=t.
in( P,T,S ) :- load( P,T,L,S ), S=t.

del( at( T,L1 ), S ) :- drive( T,L1,L2,S ), S=t.
at( T,L2,S ) :- drive( T,L1,L2,S), S=t.
del( fuel( T,Fuelpre ),S ) :- drive( T,L1,L2,S ), fuel(T, Fuelpre,S-1), S=t.
fuel( T,Fuelpre - Fueldelta,S ) :- drive( T,L1,L2,S ), fuelcost(Fueldelta,L1,L2), fuel(T,Fuelpre,S-1), Fuelpre >= Fueldelta, S=t.
at( O,L,S ) :- at( O,L,S-1 ), not del( at( O,L ),S  ), S=t.
in( P,T,S ) :- in( P,T,S-1 ), not del( in( P,T ),S  ), S=t.
fuel( T,Level,S ) :- fuel( T,Level,S-1 ), not del( fuel( T,Level) ,S ), truck( T ), S=t.


 :- unload( P,T,L,S ), not preconditions_u( P,T,L,S ), S=t.
preconditions_u( P,T,L,S ) :- S=t, at( T,L,S-1 ), in( P,T,S-1 ), package( P ), truck( T ).

 :- load( P,T,L,S ), not preconditions_l( P,T,L,S ), S=t.
preconditions_l( P,T,L,S ) :- S=t, at( T,L,S-1 ), at( P,L,S-1 ).

 :- drive( T,L1,L2,S ), not preconditions_d( T,L1,L2,S ), S=t.
preconditions_d( T,L1,L2,S ) :- S=t, at( T,L1,S-1 ), fuel( T, Fuelpre, S-1), fuelcost(Fueldelta,L1,L2), Fuelpre >= Fueldelta.

#program check(t).
:- goal(P,L), not at(P,L,S), S=t, query(t).

