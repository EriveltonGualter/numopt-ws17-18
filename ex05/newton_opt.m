function [xk] = newton_opt(x0, G, B)
% x0: Initial iterate to start netwon opt with, 1xn
% G: gradient of objective function, function of x, 1xm
% B: approx. hessian of objective function, function of x, mxm
% xk: iterates of optimization including x0

N = 4096;

xk = zeros(size(x0,1), N);
xk(:,1) = x0;

for i = 1:N-1
    % calc current gradient and hessian
    Bk = B(xk(:,i));
    Gk = G(xk(:,i));
    
    if norm(Gk) <= 1e-3
        xk = xk(:,1:i);
        break 
    end
    
    % calc newton step
    pk = -inv(Bk) * Gk;
    % calc new iterate
    xk(:, i+1) = xk(:,i) + pk;
end

end

