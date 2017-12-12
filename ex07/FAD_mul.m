function [F, J] = FAD_mul(c, x, xdot)
% FAD_mul.m
%
%     Author: Fabian Meyer
% Created on: 12 Dec 2017
%
% c: 1x1, constant factor
% x: 2x1, point of jacobian approx
% xdot: 2x1, vector for directional derivative

F = c * x(1) * x(2);
J = c * (x(2) * xdot(1) + x(1) * xdot(2));
end

