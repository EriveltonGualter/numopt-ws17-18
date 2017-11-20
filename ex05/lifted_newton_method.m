% lifted_newton_method.m
%
%     Author: Fabian Meyer
% Created on: 20 Nov 2017

clc;
clear all;
close all;

x0 = 1;

% residual function
F = @(x) x^16 - 2;
Fa = @(xk) arrayfun(@(i) F(xk(:,i)), 1:length(xk));

% gradient
G = @(x) 16 * x^15;
% hessian
H = @(x) 240 * x^14;
% fixed gradient
Gf = @(x) G(x0);

% calc with fixed approx gradient
xk_f = newton_opt(x0, F, Gf);
Fk_f = Fa(xk_f);

% calc exact newton
xk_ex = newton_opt(x0, G, H);
Fk_ex = Fa(xk_ex);

figure();
title('Ex 05 Nr3a');
plot(1:length(xk_ex), Fk_ex, 'DisplayName', num2str(x0, 'x0 = %.02f'));
legend('show');

figure();
title('Ex 05 Nr3b');
plot(1:length(xk_f), Fk_f, 'DisplayName', num2str(x0, 'x0 = %.02f'));
legend('show');