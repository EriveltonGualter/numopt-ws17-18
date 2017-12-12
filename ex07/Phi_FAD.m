function [F, J] = Phi_FAD(U, param)
% Phi_FAD.m
%
%     Author: Fabian Meyer
% Created on: 20 Nov 2017
%
% x: point for Jacobian approx
% param: parameters of function f
% F: value of f at x
% J: Jacobian approx of f at x

% Phi
N  = length(U);
x0 = param.x0;
h  = param.T/N;
q  = param.q;
%M = 5 * N + 2;
M = N - 1;

% define dot quantities
Udot = zeros(N, N + M);
Udot(1:N,1:N) = eye(N, N);

% calc partial derivates for each elementary function
J = zeros(N+M,M);
J(1:2, 1) = h;
J(3:N, 2:M) = h * eye(M-1);
J(N+1:N+M-1, 2:M) = eye(M-1);

for i=1:M 
    Udot(:,N+i) = Udot(:,N+i-1) * J(:,i)';
end

% calc phi 
X = zeros(N+1,1);
X(1) = x0;
for k = 1:N
    X(k+1) = X(k) + h * (1 - X(k)) * X(k) + h * U(k);
end

F = q*X(end).^2;
J = J(1:N,end);

end

