% chain_fmincon.m
%
%     Author: Fabian Meyer
% Created on: 21 Dec 2017

clc;
clear all;
close all;

N = 23;

param.N = N;        % number of masses
param.L = 5;        % chain length
param.m = 0.2;      % mass of each mass point
param.g = 9.81;     % acceleration of gravity
param.xi = [-2; 1]; % coordinates [y1, z1] of initial point
param.xf = [2; 1];  % coordinates [yN, zN] of final point
param.xm_idx = 7;   % index of any intermediate fixed mass

% initial value
x0 = [linspace(param.xi(1), param.xf(1), N)'; ones(N,1)];

% objective without param arg
obj = @(x) chain_objective(x, param);
% constraints without param arg
constr = @(x) chain_constraints(x, param);

% adjust options for fmincon
opts = optimoptions('fmincon');
options.FunctionTolerance = 1e-6;
options.StepTolerance = 1e-6;
opts.MaxFunEvals = 5000;

% call fmincon
[x_opt,~,~,~,lambdas] = fmincon(obj, x0, [], [], [], [], [], [], constr, opts);

%J = chain_jacobian(x_opt, param);
J = chain_jacobian_sym(x_opt, param);

disp('Optimal value is:')
disp(' ')
disp(x_opt)

disp('Constr jacobian rank is:')
disp(' ')
disp(rank(J))
disp(size(J, 1))

y_opt = x_opt(1:N);
z_opt = x_opt(N+1:2*N);
plot_chain(y_opt, z_opt, param);