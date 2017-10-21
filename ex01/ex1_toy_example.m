clc;
clear all;
close all;
	
% define variables
x = sdpvar(1,1);

% define objective
f = x^2 - 2*x;

% define constraints
C = [];
%C = [C; x >= 1.5];

% define solver
options = sdpsettings('solver', 'quadprog','verbose',2);

% solve optimization problem
diagn = optimize(C, f, options);

% read and print solution
xopt = double(x);

disp(' ')
if diagn.problem == 0
    disp(['Optimal solution found: x = ' num2str(xopt(1))]);
else
    disp('Problem failed')
end