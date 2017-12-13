function [F, J] = BAD_Phi(U, param)
% BAD_Phi.m
%
%     Author: Fabian Meyer
% Created on: 12 Dec 2017
%
% More detailed explanations: http://blog.tombowles.me.uk/2015/02/13/algorithmicautomatic-differentiation-part-2-reverse-mode/
%
% U: Nx1, point for Jacobian approx
% param: parameters of function f
% F: 1x1, value of Phi at U
% J: 1xN, Jacobian approx of f at x

M = 1;
N  = length(U);
x0 = param.x0;
h  = param.T/N;
q  = param.q;

tlen = N*3+1;
% preallocate tape with structs
tape = repmat(struct('tag', @(x) x,    ...
                     'x', [0;0],       ...
                     'jin', 0,         ...
                     'outref', [0;0]), ...
              1, tlen);

% values of elementary functions
Fel = zeros(N+1,1);
Fel(1) = x0;

% final derivative
J = zeros(1, N);

% evaluate function and record tape on the way
for k = 1:N
      
    kref = (k-1)*3;
 
    % calculate xk = (1 + h) * xk - h * xk^2 + h * Uk
    % multiplication tmp1 = xk^2
    [Fel(k+1), tape] = BAD_mul(1, [Fel(k);Fel(k)], tape, kref+1, [kref;kref]);
    % addition tmp2 = (1 + h) * xk - h * tmp1
    [Fel(k+1), tape] = BAD_add([(1+h); -h], [Fel(k);Fel(k+1)], tape, kref+2, [kref, kref+1]);
    % addition tmp3 = tmp2 + h * Uk
    [Fel(k+1), tape] = BAD_add([1; h], [Fel(k+1);U(k)], tape, kref+3, [kref+2, -k]);
end

% multiplication q * xN^2
[F, tape] = BAD_mul(q, [Fel(end); Fel(end)], tape, tlen, [tlen-1;tlen-1]);

% evaluate recorded tape
for i = 1:M
    % set all jacobian inputs to 0
    for j = 1:tlen
        s = size(tape(j).jin);
        tape(j).jin = zeros(s);
    end
    
    % create unit vector for each dimension in output space
    Y = zeros(M,1);
    Y(i) = 1;
    
    % set first input of tape to created unit vector
    tape(end).jin = Y;
    
    % tape must be traversed backwards
    for j = length(tape):-1:1
        % auxiliary vars for easier access
        outref = tape(j).outref;
        jin = tape(j).jin;
        
        % compute adjoint jacobian value
        jout = tape(j).tag(jin);
        
        % map outputs to referenced inputs
        for k = 1:length(jout)
            idx = outref(k);

            % ignore those referencing 0
            % their output is not used
            if idx == 0
                continue
            end
            
            if idx < 0
                % if idx is neg, then this is a final output for the
                % derivative
                idx = abs(idx);
                J(idx) = J(idx) + jout(k);
            else
                % if idx is pos, then add the output to the referenced
                % input (is part of chain in tape)
                tape(idx).jin = tape(idx).jin + jout(k);
            end
        end
    end
end

end

