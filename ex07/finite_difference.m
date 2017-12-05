function [F, J] = finite_difference(f, x, param)
% finite_difference.m
%
%     Author: Fabian Meyer
% Created on: 20 Nov 2017
%
% f: function handle of objective
% x: point for Jacobian approx
% param: parameters of function f
% F: value of f at x
% J: Jacobian approx of f at x

t = sqrt(eps);
F = f(x, param);
J = zeros(length(x), 1);

for i = 1:length(x)
   p = zeros(length(x), 1);
   p(i) = 1;
   J(i) =  (f(x + t * p, param) - F) / t;
end

end

