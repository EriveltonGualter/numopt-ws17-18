% newton_method.m
%
%     Author: Fabian Meyer
% Created on: 18 Nov 2017

clc;
clear all;
close all;

N = 1024;
alpha = 0;

% function f
f = @(x) 0.5 * (x(1) - 1)^2 + 0.5 * (10 * (x(2) - x(1)^2))^2 + 0.5 * x(2)^2;

% exact gradient of f(x)
G = @(x) [x(1) - 1 - 200 * x(1) * (x(2) - x(1)^2);
          100 * (x(2) - x(1)^2) + x(2)];
% exact Hessian of f(x)
H = @(x) [ 1 - 200 * x(2) + 600 * x(1)^2, -200 * x(1);
          -200 * x(1),                     101];
% gauss newton Hessian of f(x)
Hgn = @(x) [ 1 + 400 * x(1)^2 + alpha, -200 * x(1);
            -200 * x(1),                101 + alpha];

xk = zeros(2, N);
xk(:,1) = [-1;-1];

% define which hessian is to be used
B = Hgn;

for i = 1:N-1
    % calc current gradient and hessian
    Bk = B(xk(:,i));
    Gk = G(xk(:,i));
    
    if norm(Gk) <= 1e-3
        xk = xk(:,1:i);
        length(xk)
        break 
    end
    
    % calc newton step
    pk = -inv(Bk) * Gk;
    % calc new iterate
    xk(:, i+1) = xk(:,i) + pk;
end

plot_results(xk);
