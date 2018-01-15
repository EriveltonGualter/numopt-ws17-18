% Clean workspace
clear all; close all; clc

addpath('/opt/MATLAB/R2017b/toolbox/casadi-matlabR2014b-v2.4.3');
% Import casadi module 
% (add first casadi folder and subfolders to matlab path) 
import casadi.*

% Simulation parameters
N  = 40;
mi = 4/N;
Di = (70/40)*N;
g0 = 9.81;

% Declare symbolic variables
y = MX.sym('y',N);
z = MX.sym('z',N);
x = [y;z];

% Build objective
f = 0;

% calculate energy of springs
Vspr = 0;
for i=1:N-1
    Vspr = Vspr + (y(i) - y(i+1))^2 + (z(i) - z(i+1))^2;
end
Vspr = 0.5 * Di * Vspr;

% calculate energy of masses
Vmass = 0;
for i=1:N
    Vmass = Vmass + z(i);
end
Vmass = g0 * mi * Vmass;

% final objective
f = Vspr + Vmass;

% Define nonlinear constraints 
g = z + y.^2;

% Create NLP and solver object
%
% ----------------------------
%  min f
%  s.t lbx <= x <= ubx
%      lbg <= g <= ubg
% ----------------------------

nlp    = MXFunction('nlp', nlpIn('x',[y;z]),nlpOut('f',f,'g',g));
solver = NlpSolver('solver','ipopt', nlp);

% Setup bounds on variables and nonlinear constraints
% TODO SETUP BOUNDS (FIXED END POINTS CAN BE EXPRESSED BY APPROPRIATE lbx ubx VALUES)
lbx = -inf(2*N,1);
ubx =  inf(2*N,1);
lbg =  zeros(N,1);
ubg =  inf(N,1);

% y1
lbx(1)   = -2;
ubx(1)   = -2;
% z1
lbx(N+1) =  1;
ubx(N+1) =  1;
% yN
lbx(N)   =  2;
ubx(N)   =  2;
% zN
lbx(2*N) =  2;
ubx(2*N) =  2;

% Setup structure of NLP parameters
arg     = struct;
arg.lbx = lbx; 
arg.ubx = ubx; 
arg.lbg = lbg;
arg.ubg = ubg;

% Solve NLP
res  = solver(arg);
sol  = full(res.x);
ysol = sol(1:N);
zsol = sol(N+1:end);

% Plot chain
figure(1)
plot(ysol, zsol,'b--');hold on;
plot(ysol, zsol, 'Or'); hold off;
title('Optimal position of chain')
xlabel('y')
ylabel('z')

% calculate active set
A = [];
for i=1:N
   h = zsol(i) + ysol(i)^2;
   % if ineq constr is close enough to zero, add it to active set
   if h <= 1e-4
       A = [A; i];
   end
end
%[[1:N]',zsol, ysol.^2]

disp(' ')
disp('Active set:')
disp(A')

% calculate matrix for LICQ
Ma = zeros(4+length(A), N*2);
% eq constr y1
Ma(1,1)   = 1;
% eq constr z1
Ma(2,N+1) = 1;
% eq constr yN
Ma(3,N)   = 1;
% eq constr zN
Ma(4,2*N) = 1;
r = 5;
% add derivations of active set of ineq constr
for j =1:length(A)
   i = A(j);
   Ma(r,i) = 2*ysol(i);
   Ma(r,N+i) = 1;
   r = r+1;
end

disp('LICQ:')
disp(['    rows: ', num2str(size(Ma,1))])
disp(['    rank: ', num2str(rank(Ma))])

% Lagrangian
g = [y(1) + 2;
     z(1) - 1;
     y(N) - 2;
     z(N) - 1];
h = z + y.^2;
mu = MX.sym('mu', 1);
L = f - mu * h;
J = jacobian(L, x);
H = jacobian(J, x);
