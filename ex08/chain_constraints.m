function [C, Ceq] = chain_constraints(x, param)
% chain_constraints.m
%
%     Author: Fabian Meyer
% Created on: 21 Dec 2017
%
% x: input vector, [y1;..;yN;z1;..;zN], 2Nx1
% param:
% C: inequality constraints, C >= 0
% Ceq: equality constraints, Ceq == 0

% define some abbrevs
N = param.N;
L = param.L;
Li = L / (N-1);
% split x into y and z components
y = x(1:N);
z = x(N+1:2*N);

%define constr 3b
x1 = [y(1); z(1)] - param.xi;
% define constr 3c
xN = [y(N); z(N)] - param.xf;
% define constr 3d
d = (y(1:N-1) - y(2:N)).^2 + (z(1:N-1) - z(2:N)).^2 - repmat(Li^2, N-1 ,1);

Ceq = [x1; xN; d];
C = [];

end
