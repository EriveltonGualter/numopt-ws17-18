
% Hanging chain problem with BFGS and backtracking

clear all;
close all;
clc;

plotFigures = true;
useBFGS = true;

% Number of mass points
N     = 40;
tol   = 1E-3;
maxit = 2000;

% Definining constants in a structure
param.L = 1;
param.D = (70/40)*N;
param.m = 4/N;
param.g = 9.81;
param.N = N;

% Chain end points
param.zi = [-2 1];  % initial (y1, z1)
param.zf = [ 2 1];  % final   (yN, zN)

% Initial guess: linear interpolation between the tips
y = linspace(param.zi(1), param.zf(1), N+2)';
z = linspace(param.zi(2), param.zf(2), N+2)';

% abbrev for obj func including params already
f = @(x) hc_obj(x, param);

% Eliminate the tips from the decision variables and stack them together
x = reshape([y(2:end-1) z(2:end-1)].',2*N,1);

% Initial Hessian approximation
% steepest descent uses constant hessian approx
B = eye(length(x));

% Get the objective value and the gradient at initial point
[F, J] = finite_difference(f, x);

% A check whether the function you wrote is  correct
if F > 46.67 || F < 46.66 || norm(J) > 6.21 || norm(J) < 6.20  
    error('The outputs from your function finite_difference.m for the given initial point are not correct.')
end

% Printing header: iterate number, gradient norm, objective value, step norm, stepsize
fprintf('It.  \t | ||grad_f||\t | f\t\t | ||dvar||\t | t  \n');

% Main loop
for k = 1 : maxit
    
    % calc search direction (pk)
    dx = - inv(B) * J;
    
    % Parameters for backtracking with Armijo's condition
    t     = 1.0;    % initial step length
    beta  = 0.8;    % shrinking factor
    gamma = 0.1;    % minimal decrease requirement
    
    x_new = x + t * dx; % candidate for the next step

    % backtracking: shrink t until condition is satisfied
    while f(x_new) >= F + gamma * t * J' * dx
        t = t * beta;
        x_new = x + t * dx;
    end
    
    % Assign the step
    [F_new, J_new] = finite_difference(f, x_new);
    
    % calculate new Hessian approximation using BFGS formula
    % script p. 57
    if useBFGS
        s = x_new - x;
        y = J_new - J;
        B = B - (B * s * s' * B) / (s' * B * s) + (y * y') / (s' * y);
    end
    
    % Update variables
    x = x_new;
    J = J_new;
    F = F_new;

    % Every 10 iterations print the header again
    if mod(k,10) == 0
        fprintf('\n');
        fprintf('It.  \t | ||grad_f||\t | f\t\t | ||dvar||\t | t  \n');
    end
    
    % Print some useful information
    fprintf('%d\t | %f\t | %f\t | %f\t | %f \n', k, norm(J), F, norm(dx), t);
    
    % plotting
    if plotFigures
        y = x(1:2:2*N);
        z = x(2:2:2*N);
        % Plotting 
        figure(1)
        subplot(2,1,1), plot(y, z,'b--');hold on;
        subplot(2,1,1), plot(y, z, 'Or'); hold off;
        xlim([-2, 2])
        ylim([ -3, 1])
        title('Position of chain at current iterate')
        subplot(2,1,2), plot(dx)
        title('full step of each optimization variable (dz_i)')
        drawnow;
    end
    if norm(J) < tol
        disp('Convergence achieved.');
        break
    end

end

% Plot optimal solution 
figure(1)
y = x(1:2:2*N);
z = x(2:2:2*N);
subplot(2,1,1), plot(y, z, 'b--');hold on;
title('Position of chain at optimal solution')
subplot(2,1,1), plot(y, z, 'Or'); hold off;
xlim([-2, 2])
ylim([ -3, 1])
