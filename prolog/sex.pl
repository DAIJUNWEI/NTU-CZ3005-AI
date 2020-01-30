parent(di,yuqing).
parent(keyuan,jianbo).
parent(jianbo,di).

ancestor(X,Y):-parent(X,Y).
ancestor(X,Y):-parent(X,Z),ancestor(Z,Y).
