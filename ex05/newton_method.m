% newton_method.m
%
%     Author: Fabian Meyer
% Created on: 18 Nov 2017

clc;
clear all;
close all;

alpha = 500;
x0 = [-1;-1];

% function f
f = @(x) 0.5 * (x(1) - 1)^2 + 0.5 * (10 * (x(2) - x(1)^2))^2 + 0.5 * x(2)^2;

% exact gradient of f(x)
G = @(x) [x(1) - 1 - 200 * x(1) * (x(2) - x(1)^2);
          100 * (x(2) - x(1)^2) + x(2)];
% exact Hessian of f(x)
H = @(x) [ 1 - 200 * x(2) + 600 * x(1)^2, -200 * x(1);
          -200 * x(1),                     101];
% gauss newton Hessian
Hgn = @(x) [ 1 + 400 * x(1)^2, -200 * x(1);
            -200 * x(1),        101];
% steepest descent Hessian
Hsd = @(x) alpha * eye(2);

% do exact newton method
xk_ex = newton_opt(x0, G, H);
% do gauss-newton method
xk_gn = newton_opt(x0, G, Hgn);
% do steepest descent method
xk_sd = newton_opt(x0, G, Hsd);

plot_results(xk_ex);
plot_results(xk_gn);
plot_results(xk_sd);
length(xk_sd)

% helpers to calc difference of methods
l = min(length(xk_ex), length(xk_gn));
diff = xk_ex(:,1:l) - xk_gn(:,1:l);
% calc difference of methods
dk = zeros(2, l);
dk(1,:) = [1:length(dk)];
dk(2,:) = sqrt(sum(diff.^2, 1));
%dk(2,:) = arrayfun(@(i) norm(diff(:,i)), 1:length(dk));
% plot difference of methods
figure();
title('Exact Newton vs Gauss Newton');
plot(dk(1,:), dk(2,:));