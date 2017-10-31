% hanging_chain_non_qp.m
%
%     Author: Fabian Meyer
% Created on: 27 Oct 2017

clc;
clear all;
close all;

A = 0;
B = 1;
MODE = B;
N = 40;

Y2 = [-2:.1:2];
Z2 = [];

% variable definitions
y = sdpvar(N,1);
z = sdpvar(N,1);

m = 4/N;
D = 70;
g0 = 9.81;

% define potential energy for springs
Vspr = 0;
for i = 1:N-1
    Vspr = Vspr + ((y(i) - y(i+1))^2 + (z(i) - z(i+1))^2);
end
Vspr = 0.5 * D * Vspr;

% define potential energy for masses
Vmass = 0;
for i = 1:N
    Vmass = Vmass + z(i);
end
Vmass = g0 * m * Vmass;

% potential energy of whole chain
Vchain = Vspr + Vmass;

% constraints
constr = [
    [y(1) z(1)] == [-2 1];
    [y(N) z(N)] == [ 2 1];
];

constra = [];
for i = 1:N
    constra = [constra; z(i) >= -0.2 + 0.1 * y(i)^2];
end

constrb = [];
for i = 1:N
    constrb = [constrb; z(i) >= - y(i)^2];
end


if MODE == A
    constr = [constr; constra];
    Z2 = -0.2 + 0.1 * Y2.^2;
        
elseif MODE == B
    constr = [constr; constrb];
    Z2 = - Y2.^2;
end

% Set options and solve the problem with quadprog:
options = sdpsettings('solver', 'fmincon','verbose',2, 'usex0', 1);
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
plot(Y2, Z2, 'b--');
xlabel('y'); ylabel('z');
axis([-2 2 -1 1]);
title('Optimal solution hanging chain (without extra constraints)')
