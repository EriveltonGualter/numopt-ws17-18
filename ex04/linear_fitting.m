% linear_fitting.m
%
%     Author: Fabian Meyer
% Created on: 10 Nov 2017

clc;
clear all;
close all;

N = 30;
INT = [0;5];
OUTL = 1;

% create uniformly stepped measurement points
x = linspace(INT(1), INT(2), N)';
% calculate y components with gaussian noise
y = 3 * x + 4 * ones(N,1) + randn(N,1);

% check if we want outliers
if OUTL ~= 0
    % add 3 outliers to y
    idx = randi(N,1,3);
    y(idx) = y(idx) + (rand(3,1) * 2 - 1) * 50;
end

% ===================================
% calculate linear fitting by formula
% ===================================

J = [ x';
      ones(1,N)]';  
ab = (J' * J)^(-1) * J' * y;
yf = J * ab;

% ===========================================
% calculate linear fitting by l2 optimization
% ===========================================

ab_l2 = sdpvar(2,1);
% define objective function
F_l2 = norm(J * ab_l2 - y)^2;
% run optimization
optimize([], F_l2);
y_l2 = J * double(ab_l2);

% ===========================================
% calculate linear fitting by l1 optimization
% ===========================================

options_l1 = sdpsettings('solver', 'linprog','verbose',2);

% using s variable
% ----------------

ab_l1_s = sdpvar(2,1);
s = sdpvar(N,1);
F_l1_s = sum(s);
constr_l1_s = [ -s - J * ab_l1_s + y <= 0;
                 J * ab_l1_s - y - s <= 0;
                -s <= 0];
% run optimization
optimize(constr_l1_s, F_l1_s, options_l1);
y_l1_s = J * double(ab_l1_s);

% using z variable
% ----------------

z = sdpvar(N+2,1);
f = [0;
     0;
     ones(N,1)];
b = [-y;
      y];
A = [-J, -1 * eye(N);
      J, -1 * eye(N)];
% define objective function
F_l1_z = f' * z;
% define constraints
constr_l1_z = [ A * z - b <= 0;
               -z(3:end) <= 0];
% run optimization
optimize(constr_l1_z, F_l1_z, options_l1);
y_l1_z = J * double(z(1:2));

figure;
plot(x, y, 'bo', 'DisplayName', 'data'); hold on;
plot(x, yf, 'g->', 'DisplayName', 'explicit');
plot(x, y_l2, 'r-s', 'DisplayName', 'L2 fitting');
plot(x, y_l1_s, 'm-^', 'DisplayName', 'L1 fitting s');
plot(x, y_l1_z, 'c-d', 'DisplayName', 'L1 fitting z');
hold off;
xlabel('x');
ylabel('y');
title('Linear Fitting');
legend('Location', 'southeast');
legend('show');