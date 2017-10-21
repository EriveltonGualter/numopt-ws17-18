clc;
clear all;
close all;

N = 40;

% TODO: complete the definition of variables HERE
y = sdpvar(N,1);
z = sdpvar(N,1);

m = 4/N;
D = 70;
g0 = 9.81;

% define potential energy for springs
Vspr = 0;
for i = 1:N-1
    Vspr = Vspr + ((y(i) - y(i+1))^2 + (z(i) - z(i+1))^2);
end
Vspr = 0.5 * D * Vspr;

% define potential energy for masses
Vmass = 0;
for i = 1:N
    Vmass = Vmass + z(i);
end
Vmass = g0 * m * Vmass;

% potential energy of whole chain
Vchain = Vspr + Vmass;

% constraints
constr = [
    [y(1) z(1)] == [-2 1];
    [y(N) z(N)] == [ 2 1]
];

% Set options and solve the problem with quadprog:
options = sdpsettings('solver', 'quadprog','verbose',2);
diagn   = optimize(constr, Vchain, options);

% get solution and plot results
Y = double(y); Z = double(z);

figure;
plot(Y,Z,'--or'); hold on;
plot(-2,1,'xg','MarkerSize',10);
plot(2,1,'xg','MarkerSize',10);
xlabel('y'); ylabel('z');
title('Optimal solution hanging chain (without extra constraints)')
