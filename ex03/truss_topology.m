% truss_topology.m
%
%     Author: Fabian Meyer
% Created on: 27 Oct 2017

clc;
clear all;
close all;

MODE = 1;
N = 6; % number of nodes
M = 10; % number of edges
Xmax = 200; % max cross-sectional area
Vmax = 1e5; % max volume of structure

% unpack data
D = load_data(MODE);
Coord = D.Coord'.'; % coordinates of nodes
Con = D.Con'.'; % connections (edges) between nodes
E = D.E'.'; % elasticity of edges
Fext = D.Fext'.'; % external forces

% variable definitions
x = sdpvar(M,1);
% slack variable
s = sdpvar(1,1);

[KLMI, K, Le] = calculate_stiffness(D);

Kx = zeros(size(KLMI(:,:,1)));
for i = 1:M
    Kx = Kx + KLMI(:,:,i) * x(i);
end

B = [s    Fext';
     Fext Kx];
V = sum(Le .* x);
 
constr = [x >= 0;
          x <= Xmax;
          V <= Vmax;
          B >= 0];
      
% solve problem with SDPT3
options = sdpsettings('solver', 'SDPT3','verbose',2);
diagn   = optimize(constr, s, options);

plot_structure(D, double(Kx));