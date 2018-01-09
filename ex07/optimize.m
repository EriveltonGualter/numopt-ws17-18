% optimize.m
%
%     Author: Fabian Meyer
% Created on: 13 Dec 2017

clear all;
close all;
clc;

% set parameters
param.N = 50; %number of discretization steps
param.x0 = 2; % init condition
param.T  = 5; % terminal time
param.q  = 50; % terminal weight

% initial value
U0 = ones(param.N, 1);

% define derication functions for phi
BAD_der = @BAD_Phi;
FAD_der = @FAD_Phi;
fin_der = @(U, param) finite_difference(@Phi, U, param);
itrick_der = @(U, param) i_trick(@Phi, U, param);

% run backwards derivation
[Uk,Fk,X] = bfgs_opt(@Phi, BAD_der, U0, param);
U = Uk(:,end);
disp('BAD len:');
disp(size(Uk,2));
plot_state_controls('BAD', X, U);

% run forward derivation
[Uk,Fk,X] = bfgs_opt(@Phi, FAD_der, U0, param);
U = Uk(:,end);
plot_state_controls('FAD', X, U); 

disp('FAD len:');
disp(size(Uk,2));

% run finit difference
[Uk,Fk,X] = bfgs_opt(@Phi, fin_der, U0, param);
U = Uk(:,end);
plot_state_controls('Finite difference', X, U); 

disp('Fnite difference len:');
disp(size(Uk,2));

% run i-trick
[Uk,Fk,X] = bfgs_opt(@Phi, itrick_der, U0, param);
U = Uk(:,end);
plot_state_controls('i-trick', X, U); 

disp('i-trick len:');
disp(size(Uk,2));