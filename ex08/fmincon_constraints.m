function [ C, Ceq ] = fmincon_constraints(x, param)

% The function returns two arguments: 
% C for C(x) <= 0 (not used in our case)
% Ceq for Ceq(x) == 0 

Ceq = x(1)^2 + x(2)^2 - param.R^2;
C   = [];

end

