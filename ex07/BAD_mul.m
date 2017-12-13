function [F, tape] = BAD_mul(c, x, tape, outref)
% BAD_add.m
%
%     Author: Fabian Meyer
% Created on: 12 Dec 2017
%
% c: 1x1, constant factor for each term
% x: 2x1, point of jacobian approx

% evaluate function value
F = c * x(1) * x(2);

elem.tag = @(jin) c * [x(2); x(1)] * jin; % adjoint jacobian
elem.x = x;                               % input to function
elem.jin = 0;                             % input of adjoint jacobian
elem.outref = outref;                     % output reference of adjoint jacobian

tape = [tape; elem];

end

