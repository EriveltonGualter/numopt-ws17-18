function [F, J] = i_trick(f, U, param)
% i_trick.m
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
t = eps; % t at machine precision
J = zeros(1,  N);

for i = 1:N
    % calc directional seed
    p = zeros(N, 1);
    p(i) = 1;
    
    % calc complex input variable
    Uim = U + p * t * 1i;
    J(i) = (imag(f(Uim, param)) / t);
    
end

F = f(U, param);

end

