% time_derivatives.m
%
%     Author: Fabian Meyer
% Created on: 13 Dec 2017

clc;
clear all;
close all;

% set parameters
param.N = 200; %number of discretization steps
param.x0 = 0.6; % init condition
param.T  = 5; % terminal time
param.q  = 200; % terminal weight

% interval length
h = param.T/param.N;

% random control trajectory
Utst = rand(param.N,1);


% finite differences on nonlinear part
disp('Finite Differences:')
tic
[F1, J1] = finite_difference(@Phi, Utst, param);
toc
disp(' ')
% imaginary trick 
disp('Imaginary Trick:')
tic
[F2, J2] = i_trick(@Phi, Utst, param);
toc
disp(' ')
% forward AD
disp('Forward AD:')
tic
[F3, J3] = FAD_Phi(Utst, param);
toc
disp(' ')
% backward AD
disp('Backward AD:')
tic
[F4, J4] = BAD_Phi(Utst, param);
toc