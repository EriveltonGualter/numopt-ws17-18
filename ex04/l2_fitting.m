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

figure;
plot(x,y,'bo');