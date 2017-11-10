% l2_fitting.m
%
%     Author: Fabian Meyer
% Created on: 10 Nov 2017

clc;
clear all;
close all;

N = 30;
INT = [0;5];
OUTL = 1;

% create uniformly stepped measurement points
x = linspace(INT(1), INT(2), N)';
% calculate y components with gaussian noise
y = 3 * x + 4 * ones(N,1) + randn(N,1);

% check if we want outliers
if OUTL == 1
    % add 3 outliers to y
    idx = randi(N,1,3);
    y(idx) = y(idx) + (rand(3,1) * 2 - 1) * 150;
end

% calculate linear fitting by formula
J = [ x';
      ones(1,N)]';  
ab = (J' * J)^(-1) * J' * y;
yf = ab(1) * x + ones(N,1) * ab(2);

% calculate linear fitting by optimization
ab2 = sdpvar(2,1);
% define objective function
f = norm(J * ab2 - y)^2;
% run optimization
diagn   = optimize([], f);
yo = double(ab2(1)) * x + ones(N,1) * double(ab2(2));

figure;
plot(x, y, 'bo'); hold on;
plot(x, yo, 'r-s');
plot(x, yf, 'g->');
hold off;