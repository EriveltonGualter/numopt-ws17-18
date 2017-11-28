function [f] = hc_obj(x, param)

% Implements the nonlinear hanging chain objective
% Note that only intermediate mass points have degree of freedom

% We assume that x =
%  [y1, y2, ..., yN, z1, ..., zN].'

% We reshape x to be easier to evaluate, each row will contain one
% coordinate pair (yi, zi)

N = size(x, 1)/2;
y = x(1:2:2*N);
z = x(2:2:2*N);

L   = param.L;
D   = param.D;
m   = param.m;
g   = param.g;
LoN = L / (N-1);

zi = param.zi;
zf = param.zf;

% Initialize the potential
f = 0;
% Iterate on the points and update the potential
for k = 1 : N - 1
   f = f + 0.5 * D * (sqrt( ( y(k+1) - y(k) ).^2 + ( z(k+1) - z(k) ).^2 ) - LoN)^2 + m * g * z(k);
end
% Add the last gravitational energy
f = f + z(end) * m * g;

% Adding potential of fixed points (we have an unconstrained problem
f = f + 0.5 * D * sum(sqrt( ( zi(1) - y(1) ).^2   + ( zi(2) - z(1) ).^2   ) - LoN)^2;
f = f + 0.5 * D * sum(sqrt( ( zf(1) - y(end) ).^2 + ( zf(2) - z(end) ).^2 ) - LoN)^2;

end
