clc;
clear all;
close all;

N = 40;

% TODO: complete the definition of variables HERE
y = ... ;
z = ... ;

m = 4/N;
D = 70;
g0 = 9.81;

Vchain = 0;
for i = 1:N
    % TODO: complete the objective function (i.e. potential energy) HERE
    Vchain = Vchain + ...;
end

% TODO: complete the (equality) constraints HERE
constr = [  ... ];

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

