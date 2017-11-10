% l2_fitting.m
%
%     Author: Fabian Meyer
% Created on: 10 Nov 2017

clc;
clear all;
close all;

N = 30;
INT = [0;5];

% create uniformly stepped measurement points
x = linspace(INT(1), INT(2), N)';
% calculate y components with gaussian noise
y = 3 * x + 4 * ones(N,1) + randn(N,1);


% calculate linear fitting by formula
J = [ x';
      ones(1,N)]';  
ab = (J' * J)^(-1) * J' * y;
yf = ab(1) * x + ones(N,1) * ab(2);
  
figure;
plot(x, y, 'bo');
hold on;
plot(x, yf, 'g-');
hold off;