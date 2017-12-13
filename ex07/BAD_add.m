function [F, tape] = BAD_add(c, x, tape, outref)
% BAD_add.m
%
%     Author: Fabian Meyer
% Created on: 12 Dec 2017
%
% c: 2x1, constant factor for each term
% x: 2x1, point of jacobian approx

% evaluate function value
F = c' * x;

elem.tag = @(jin) c * jin; % adjoint jacobian
elem.x = x;                   % input to function
elem.jin = 0;            % input of adjoint jacobian
elem.outref = outref;         % output reference of adjoint jacobian

tape = [tape; elem];

end

