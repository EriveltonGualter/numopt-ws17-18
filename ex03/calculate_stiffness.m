function [KLMI, K, Le] = calculate_stiffness( D )

% INPUTS
%
% D:    Structure with problem data, created with the load_data.m function
%
% OUTPUTS
%
% KLMI: Components Ki of stiffness matrix stored in a 3D matrix (3nx3nxm) 
%       where n is the number of nodes and m the number of bars.
% K:    The resulting stifness matrix for the cross-sectional areas xi, 
%       stored in field D.A.
% Le:   A vector with the length of each bar, needed for the constraint on
%       the total volume of the structure. 


n = size(D.Re,2);
m = size(D.Con,2);

K    = zeros(3*n);
KLMI = zeros(3*n,3*n,m);
Le   = zeros(m,1);

for i = 1:size(D.Con,2)
    % H: connecting nodes
    H  = D.Con(:,i);
    % e: position index in stiffness matrix
    e = [3*H(1)-2:3*H(1),3*H(2)-2:3*H(2)];
    % C: A - B
    C  = D.Coord(:,H(2)) - D.Coord(:,H(1));
    % Le: ||A-B||_2
    Le(i) = norm(C);

    T  = C/Le(i);
    s  = T*T';
    V  = D.E(i)/Le(i);
    G  = V*D.A(i);
    K(e,e) = K(e,e) + G*[s -s;-s s];
    
    GLMI = V;
    KLMI(e,e,i)  = KLMI(e,e,i) + GLMI*[s -s;-s s];
end

% Keep only the parts of the stifness matrix that correspond to free directions
nfree    = numel(D.Ind);
KLMIfree = zeros(nfree,nfree,m);
for i = 1:size(D.Con,2)
    KLMIfree(:,:,i) = KLMI(D.Ind,D.Ind,i); 
end
KLMI = KLMIfree;
K    = K(D.Ind,D.Ind);

end

% code inspired from:
% http://www.mathworks.com/matlabcentral/fileexchange/14313-truss-analysis
