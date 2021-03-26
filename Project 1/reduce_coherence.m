function [Om, Yp] = reduce_coherence(A, y)
Om = (orth(A'))';
Ap = A'*inv(A*A');
Yp = Om*Ap*y;