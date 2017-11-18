% example_8_1.m
%
%     Author: Fabian Meyer
% Created on: 15 Nov 2017

clc;
clear all;
close all;

EXACT = 0;

N = 50;
wk = zeros(N,1);
wk(1) = 1.0;

if EXACT == 1
    J = @(x) 16 * x^15;
else
    J = @(x) 16;
end

for i = 1:N-1
   wk(i+1) = wk(i) - inv(J(wk(i)))  * (wk(i)^16 - 2);
end

Fwk = wk(N)^16 - 2;

wk
Fwk
