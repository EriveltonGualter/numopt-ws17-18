% hanging_chain_real.m
%
%     Author: Fabian Meyer
% Created on: 27 Oct 2017

clc;
clear all;
close all;

L = 1;
N = 40;
Li = L / (N-1);

% variable definitions
y = sdpvar(N,1);
z = sdpvar(N,1);
% slack variable
s = sdpvar(N-1,1);

m = 4/N;
D = 70;
g0 = 9.81;

% define potential energy for springs
% use slack variable to express max(0,d) in constraints
Vspr = 0.5 * D * sum(s.^2);

% define potential energy for masses
Vmass = g0 * m * sum(z);

% potential energy of whole chain
Vchain = Vspr + Vmass;

% calc d
d = sqrt((y(1:N-1) - y(2:N)).^2 + (z(1:N-1) - z(2:N)).^2) - repmat(Li, N-1 ,1);

% constraints
% max(x,d) is same as saying s >= 0 and s >= d
% formulate objective fucntion using constraints
% and slack variable
constr = [
    [y(1) z(1)] == [-2 1];
    [y(N) z(N)] == [ 2 1];
    s - d >= 0;
    s >= 0
];

% Set options and solve the problem with quadprog:
options = sdpsettings('solver', 'fmincon','verbose',2);
diagn   = optimize(constr, Vchain, options);

% get solution and plot results
Y = double(y); Z = double(z);

disp(' ')
if diagn.problem == 0
    disp('Optimal solution found: ')
    disp(Y)
    disp(Z)
else
    disp('Problem failed')
end

figure;
plot(Y,Z,'--or'); hold on;
plot(-2,1,'xg','MarkerSize',10);
plot(2,1,'xg','MarkerSize',10);
xlabel('y'); ylabel('z');
title('Optimal solution hanging chain (without extra constraints)')
