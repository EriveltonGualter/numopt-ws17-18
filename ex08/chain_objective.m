function [F] = chain_objective(x, param)
% chain_objective.m
%
%     Author: Fabian Meyer
% Created on: 21 Dec 2017
%
% x:     input vector, [y1;..;yN;z1;..;zN], 2Nx1
% param: parameters of objective, struct
% F:     value of objective at x, 1x1

N = param.N;
z = x(N+1:2*N);
F = param.m * param.g * sum(z);

end

