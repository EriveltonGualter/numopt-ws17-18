function [F, J] = FAD_Phi(U, param)
% FAD_Phi.m
%
%     Author: Fabian Meyer
% Created on: 12 Dec 2017
%
% More detailed explanations: http://blog.tombowles.me.uk/2014/09/10/ad-algorithmicautomatic-differentiation/
%
% U: Nx1, point for Jacobian approx
% param: parameters of function f
% F: 1x1, value of Phi at U
% J: 1xN, Jacobian approx of f at x

N  = length(U);
x0 = param.x0;
h  = param.T/N;
q  = param.q;

% values of elementary functions
Fel = zeros(N+1,1);
% derivatives of elementary functions
Jel = zeros(N+1,1);

% final derivative
J = zeros(1,N);

for i = 1:N
    % initial value
    Fel(1) = x0;
    % its derivation is 0 (constant)
    Jel(1) = 0;

    % directional seed vector
    Udot = zeros(N,1);
    Udot(i) = 1;

    for k = 1:N
        % calculate xk = (1 + h) * xk - h * xk^2 + h * Uk

        % multiplication tmp1 = xk^2
        [Fel(k+1), Jel(k+1)] = FAD_mul(1, [Fel(k);Fel(k)], [Jel(k);Jel(k)]);
        % addition tmp2 = (1 + h) * xk - h * tmp1
        [Fel(k+1), Jel(k+1)] = FAD_add([(1+h); -h], [Fel(k);Fel(k+1)], [Jel(k);Jel(k+1)]);
        % addition tmp3 = tmp2 + h * Uk
        [Fel(k+1), Jel(k+1)] = FAD_add([1; h], [Fel(k+1);U(k)], [Jel(k+1);Udot(k)]);
    end

    % multiplication q * xN^2
    [F, J(i)] = FAD_mul(q, [Fel(end); Fel(end)], [Jel(end); Jel(end)]);
end

end

