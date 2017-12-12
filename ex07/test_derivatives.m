
% testing the different functions
clc;
clear all;
close all;

% set parameters
param.N = 50; %number of discretization steps
param.x0 = 0.6; % init condition
param.T  = 5; % terminal time
param.q  = 20; % terminal weight

% interval length
h = param.T/param.N;

% random control trajectory
Utst = rand(param.N,1);

% finite differences on nonlinear part 
[F1, J1] = finite_difference(@Phi, Utst, param);
% imaginary trick 
[F2, J2] = i_trick(@Phi, Utst, param);
% forward AD
[F3, J3] = FAD_Phi(Utst, param);
% backward AD
%[F4, J4] = Phi_BAD(Utst, param);

% check results
disp('Error between imaginary trick and finite differences:')
disp(' ')
disp(max(max(abs(J2-J1))))

disp('Error between imaginary trick and forward AD:')
disp(' ')
disp(max(max(abs(J2-J3))))

%disp('Error between imaginary trick and backward AD:')
%disp(' ')
%disp(max(max(abs(J2-J4))))
