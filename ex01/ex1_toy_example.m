% ex1_toy_example.m
%
%     Author: Fabian Meyer
% Created on: 21 Oct 2017

clc;
clear all;
close all;

% define variables
x = sdpvar(1,1);
y = sdpvar(1,1);

% define objective
%f = x^2 - 2*x;
f = x^2 - 2*x + y^2 + y;

% define constraints
%C = [];
C = [x >= 1.5; x + y >= 0];
% define solver
options = sdpsettings('solver', 'quadprog','verbose',2);

% solve optimization problem
diagn = optimize(C, f, options);

% read variables as double
xopt = double(x);
yopt = double(y);

disp(' ')
if diagn.problem == 0
    disp(['Optimal solution found: x = ' num2str(xopt(1)) ', y = ' num2str(yopt(1))]);
else
    disp('Problem failed')
end
