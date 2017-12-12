function [F, J] = i_trick(f, U, param)
% i_trick.m
%
%     Author: Fabian Meyer
% Created on: 20 Nov 2017
%
% f: function handle of objective
% U: point for Jacobian approx
% param: parameters of function f
% F: value of f at x
% J: Jacobian approx of f at x

p = U; % seed vector
t = eps; % t at machine precision
Uim = U + p * t * 1i; % complex input variable

F = f(U, param);
J = (imag(f(Uim, param)) / t) + t^2;

end

