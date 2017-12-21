function [xk] = newton_opt(x0, F, J)
% x0: Initial iterate to start netwon opt with, nx1
% F: objective for root finding, function hnd, mx1
% J: approx. Jacobian of F, function hnd, nxm
% xk: iterates of optimization including x0

% pre init result vector for fast computation
N = 8192;
xk = zeros(size(x0,1), N);
xk(:,1) = x0;

for i = 1:N-1
    % calc current gradient and hessian
    Jk = J(xk(:,i));
    Fk = F(xk(:,i));
    
    if norm(Fk) <= 1e-3
        xk = xk(:,1:i);
        break 
    end
    
    % calc newton step
    pk = -inv(Jk) * Fk;
    % calc new iterate
    xk(:, i+1) = xk(:,i) + pk;
end

end

