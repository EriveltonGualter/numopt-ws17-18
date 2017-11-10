
function D = load_data(m)

% Nodal Coordinates
Coord = 100*[2 1 0;2 0 0;1 1 0;1 0 0;0 1 0;0 0 0];

% Connectivity
Con = [5 3; 1 3; 6 4; 4 2; 4 3; 2 1; 6 3; 5 4; 4 1; 3 2];

% Definition of Degree of freedom (free=0 & fixed=1) 
% for 2-D trusses the last column is equal to 1
Re = [0 0 1;0 0 1;0 0 1;0 0 1;1 1 1;1 1 1];

% Definition of Nodal loads 
Lext = -1e2;
Loadm = [[0 0    0;0 Lext 0;0 0 0;0 Lext 0;0 0 0;0 0 0];
         [0 Lext 0;0 0    0;0 0 0;0 0    0;0 0 0;0 0 0]];
Load = Loadm(m*6+1:m*6+6, :);

% Definition of Modulus of Elasticity
E = ones(1,size(Con,1))*1e9;

% Initialization of Area (our optimization variable)
A = [27.5 5.1 24.5 17.5 10.1 5.5 7.5 21.5 21.5 2.1];

% Index of free directions for all nodes (x,y,z)
ind = 1:(size(Coord,1)*size(Coord,2));
ind = reshape(ind,3, size(Coord,1));
ind(Re' == 1) = [];

% Vector of external forces, ONLY on free directions
Fext = Load';
Fext = Fext(ind);

% Convert to structure array (NOTE: all matrices are transposed!)
D = struct('Coord', Coord', 'Con', Con', 'Re', Re', 'Load', Load', 'E', E', 'A',A','Ind', ind, 'Fext', Fext');

end

% code inspired from:
% http://www.mathworks.com/matlabcentral/fileexchange/14313-truss-analysis
