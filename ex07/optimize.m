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
tol = 1e-3;
maxit = 2000;

% interval length
h = param.T/param.N;

% choose derivation function for Phi
Phi_der = @BAD_Phi;
%Phi_der = @FAD_Phi;
%Phi_der = @(U, param) finite_differences(@Phi, U, param);
%Phi_der = @(U, param) i_trick(@Phi, U, param);

% define objective function
objective = @(U, param) U' * U + Phi(U, param);

% init sequence of control vectors
Uk = zeros(param.N, maxit+1);
Uk(:, 1) = U0;

% calc first Jacobian and function value
[F, J] = Phi_der(Uk(:, 1), param);
J = 2 * Uk(:, 1) + J';
F = Uk(:, 1)' * Uk(:, 1) + F;

% init sequence of states
Fk = zeros(1, maxit+1);
Fk(:, 1) = F;

% init hessian as Identity
B = eye(param.N);

for k = 1:maxit
    pk = - inv(B) * J;
    
    % Parameters for backtracking with Armijo's condition
    t     = 1.0;    % initial step length
    beta  = 0.8;    % shrinking factor
    gamma = 0.1;    % minimal decrease requirement
    
    U_new = Uk(:, k) + t * pk; % candidate for the next step

    % backtracking: shrink t until condition is satisfied
    while objective(U_new, param) >= Fk(:, k) + gamma * t * J' * pk
        t = t * beta;
        U_new = Uk(:, k) + t * pk;
    end
    
    [F_new, J_new] = Phi_der(U_new, param);
    J_new = 2 * U_new + J_new';
    F_new = U_new' * U_new + F_new;
    
    % calculate new Hessian approximation using BFGS formula
    % script p. 57
    s = U_new - Uk(:,k);
    y = J_new - J;
    B = B - (B * s * s' * B) / (s' * B * s) + (y * y') / (s' * y);
    
    % Update variables
    J = J_new;
    U(:, k+1) = U_new;
    F(:, k+1) = F_new;

    
    if norm(J) < tol
        Fk = Fk(:, 1:k+1);
        Uk = Uk(:, 1:k+1);
        break
    end
end

disp('Done');

t = linspace(1, length(Fk));

figure();
plot(t, Fk);