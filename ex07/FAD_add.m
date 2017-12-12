function [F, J] = FAD_add(c, x, xdot)
% FAD_add.m
%
%     Author: Fabian Meyer
% Created on: 12 Dec 2017
%
% c: 2x1, constant factor for each term
% x: 2x1, point of jacobian approx
% xdot: 2x1, vector for directional derivative

F = c' * x;    % c(1) * x(1) + c(2) * x(2);
J = c' * xdot; % c(1) * xdot(1) + c(2) * xdot(2);
end

