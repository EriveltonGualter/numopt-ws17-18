function [J] = chain_jacobian(x, param)
% chain_jacobian.m
%
%     Author: Fabian Meyer
% Created on: 24 Dec 2017
%
% x:     input vector, [y1;..;yN;z1;..;zN], 2Nx1
% param: parameters of objective, struct
% F:     value of objective at x, 1x1

N = param.N;

y = x(1:N);
z = x(N+1:2*N);

J = zeros(4 + N-1, 2*N);
% equality constraints 3b
J(1,1)    = 1;
J(2,N+1)  = 1;
% equality constraints 3c
J(3, N)   = 1;
J(4, 2*N) = 1;
% equality constraints 3d
for i=1:N-1
   r = 4+i;
   J(r,i)   =  2 * (y(i) - y(i+1));
   J(r,i+1) = -2 * (y(i) - y(i+1));
   
   J(r,N+i) =  2 * (z(i) - z(i+1));
   J(r,N+i) = -2 * (z(i) - z(i+1));
end

end

