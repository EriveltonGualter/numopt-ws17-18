function [Uk, Fk, X] = bfgs_opt(f, f_der, U0, param)

N = param.N;
T = param.T;
x0 = param.x0;
h = T/N;

tol = 1e-3;
maxit = 2000;

Uk = zeros(param.N, maxit+1);
Fk = zeros(1, maxit+1);

% init sequence of control vectors
Uk(:, 1) = U0;

% calc first Jacobian and function value
[F, J] = f_der(Uk(:, 1), param);
J = 2 * Uk(:, 1) + J';
F = Uk(:, 1)' * Uk(:, 1) + F;

% init sequence of states
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
    while f(U_new, param) >= Fk(:, k) + gamma * t * J' * pk
        t = t * beta;
        U_new = Uk(:, k) + t * pk;
    end
    
    [F_new, J_new] = f_der(U_new, param);
    J_new = 2 * U_new + J_new';
    F_new = U_new' * U_new + F_new;
    
    % calculate new Hessian approximation using BFGS formula
    % script p. 57
    s = U_new - Uk(:,k);
    y = J_new - J;
    B = B - (B * (s * s') * B) / (s' * B * s) + (y * y') / (s' * y);
    
    % Update variables
    J = J_new;
    Uk(:, k+1) = U_new;
    Fk(:, k+1) = F_new;

    if norm(J) < tol
        Fk = Fk(:, 1:k+1);
        Uk = Uk(:, 1:k+1);
        break
    end
end

U = Uk(:,end);
X = zeros(N+1,1);
X(1) = x0;
for k = 1:N
    X(k+1) = X(k) + h*( (1 - X(k))*X(k) + U(k));
end

end

