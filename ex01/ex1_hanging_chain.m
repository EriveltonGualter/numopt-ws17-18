% ex1_hanging_chain.m
%
%     Author: Fabian Meyer
% Created on: 21 Oct 2017

clc;
clear all;
close all;

GROUND = true;
N = 40;

% variable definitions
y = sdpvar(N,1);
z = sdpvar(N,1);

m = 4/N;
D = 70;
g0 = 9.81;

% define potential energy for springs
Vspr = 0.5 * D * sum((y(1:N-1) - y(2:N)).^2 + (z(1:N-1) - z(2:N)).^2);

% define potential energy for masses
Vmass = g0 * m * sum(z);

% potential energy of whole chain
Vchain = Vspr + Vmass;

% constraints
constr = [
    [y(1) z(1)] == [-2 1];
    [y(N) z(N)] == [ 2 1];
];

if GROUND
    constr = [constr;
              z >= 0.5;
              z - 0.1 * y >= 0.5];
end

% Set options and solve the problem with quadprog:
options = sdpsettings('solver', 'quadprog','verbose',2);
diagn   = optimize(constr, Vchain, options);

% get solution and plot results
Y = double(y); Z = double(z);

figure;
plot(Y,Z,'--or'); hold on;
plot(-2,1,'xg','MarkerSize',10);
plot(2,1,'xg','MarkerSize',10);
xlabel('y'); ylabel('z');
title('Optimal solution hanging chain (without extra constraints)')
