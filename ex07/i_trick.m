function [F, J] = i_trick(f, x, param)
% i_trick.m
%
%     Author: Fabian Meyer
% Created on: 20 Nov 2017
%
% f: function handle of objective
% x: point for Jacobian approx
% param: parameters of function f
% F: value of f at x
% J: Jacobian approx of f at x

p = ones(size(x,1)); % seed vector
t = eps; % t at machine precision
xim = x + p * t * 1i; % complex input variable

F = f(x, param);
J = (imag(f(xim, param)) / t) + t^2;

end

