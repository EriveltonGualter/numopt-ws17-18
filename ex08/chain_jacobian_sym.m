function [J] = chain_jacobian_sym(x, param)
% chain_jacobian_sym.m
%
%     Author: Fabian Meyer
% Created on: 24 Dec 2017
%
% x:     input vector, [y1;..;yN;z1;..;zN], 2Nx1
% param: parameters of objective, struct
% J:     Jacobian of objective at x, 1x1

N = param.N;
xsym = sym('x', [2*N, 1]);
[~, Csym] = chain_constraints(xsym, param);
J = jacobian(Csym, xsym);
J = subs(J, xsym, x);

end

