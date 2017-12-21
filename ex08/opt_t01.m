% opt_t01.m
%
%     Author: Fabian Meyer
% Created on: 21 Dec 2017

clc;
clear;
close all;

w0 = -ones(3,1);
%w0 = [0;-1;1];
% objective of minimization
f = @(x) x(2);
% equality constr function
g = @(x) x(1)^2 + x(2)^2 - 1;
% lagrange
L = @(x,lambda) x(2) - lambda(g(x));
% gradient of lagrange
% w = [x1;x2;lambda]
gL = @(w) [-2 * w(3) * w(1);
            1 - 2 * w(3) * w(2)];

% objective of root finding
F = @(w) [gL(w); g(w)];
F(w0)
% Jacobian of root finding (exact newton)
J = @(w) [-2 * w(3),  0       , -2 * w(1);
           0       , -2 * w(3), -2 * w(2);
           2 * w(1),  2 * w(2),  0       ];
              
wk = newton_opt(w0, F, J);

x_opt = wk(1:2, end);

disp('Optimal solution:')
disp(' ')
disp(x_opt)

ang = 0:0.01:2*pi; 
xp  = cos(ang);
yp  = sin(ang);
plot(xp, yp);
hold on
plot(x_opt(1),x_opt(2),'rx','MarkerSize',10)
axis([-1.1 1.1 -1.1 1.1]);
title('A simple example on equality constrained optimization')
legend('Equality constraint','Optimal solution')