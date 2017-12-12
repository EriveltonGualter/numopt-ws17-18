function [F, J] = finite_difference(f, U, param)
% finite_difference.m
%
%     Author: Fabian Meyer
% Created on: 20 Nov 2017
%
% f: function handle of objective
% U: Nx1, point for Jacobian approx
% param: parameters of function f
% F: 1x1, value of f at x
% J: 1xN, Jacobian approx of f at x

N = length(U);
t = sqrt(eps);
F = f(U, param);
J = zeros(1, N);

for i = 1:N
   p = zeros(N, 1);
   p(i) = 1;
   J(i) =  (f(U + t * p, param) - F) / t;
end

end

