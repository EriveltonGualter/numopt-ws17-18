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

Vchain = 0;
% define potential energy for springs
for i = 1:N-1
    Vchain = Vchain + 0.5 * D * ((y(i) - y(i+1))^2 + (z(i) - z(i+1))^2);
end
% define potential energy for masses
for i = 1:N
    Vchain = Vchain + g0 * m * z(i);
end

% TODO: complete the (equality) constraints HERE
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
