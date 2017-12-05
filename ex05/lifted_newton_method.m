% lifted_newton_method.m
%
%     Author: Fabian Meyer
% Created on: 20 Nov 2017

clc;
clear all;
close all;

x0 = 1 * [1 1 1 1]';

% residual function
% converges only for 2 not for -2
F = @(x) [x(2) - x(1)^2;
          x(3) - x(2)^2;
          x(4) - x(3)^2;
          2    - x(4)^2];

% Jacobian
G = @(x) [-2*x(1),   1,       0,       0;
           0,       -2*x(2),  1,       0;
           0,        0,      -2*x(3),  1;
           0,        0,       0,      -2*x(4)];
% transposed Jacobian  
Gt = @(x) [-2*x(1)   0       0       0;
            1       -2*x(2)  0       0;
            0        1      -2*x(3)  0;
            0        0       1      -2*x(4)];

% calc root using newton method
xk = newton_opt(x0, F, G);
Fk = zeros(1,length(xk));
for i = 1:length(Fk)
    Fk(:,i) = norm(F(xk(:,i)));
end
length(xk)

figure();
title('Ex 05 Nr3c');
plot(1:length(xk), Fk, 'DisplayName', 'Lifted Newton');
legend('show');