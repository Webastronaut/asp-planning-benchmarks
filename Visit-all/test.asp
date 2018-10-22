connected(x1y1,x2y1). connected(x2y1,x1y1).
connected(x2y1,x3y1). connected(x3y1,x2y1).

connected(x2y2,x3y2). connected(x3y2,x2y2).

connected(x1y3,x2y3). connected(x2y3,x1y3).
connected(x2y3,x3y3). connected(x3y3,x2y3).

connected(x2y1,x2y2). connected(x2y2,x2y1).
connected(x2y2,x2y3). connected(x2y3,x2y2).

connected(x3y1,x3y2). connected(x3y2,x3y1).
connected(x3y2,x3y3). connected(x3y3,x3y2).

at(x2y2).

visit(x1y1). visit(x2y1). visit(x3y1).
visit(x2y2). visit(x3y2).
visit(x1y3). visit(x2y3).

step(1). step(2). step(3).
step(4). step(5). step(6).
step(7). step(8).
