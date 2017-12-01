% truss_topology.m
%
%     Author: Fabian Meyer
% Created on: 27 Oct 2017

clc;
clear all;
close all;

% init SDPT3
olddir = cd('/opt/MATLAB/R2017b/toolbox/sdpt3/');
startup
cd(olddir)

M02b = 0;
M02C = 1;
MODE = M02b;
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

% calculate stiffness and its components
[KLMI, K, Le] = calculate_stiffness(D);

% define matrix for contraint (schur complement)
B = [s    Fext';
     Fext K];
% define volume of the construction
V = sum(Le .* x);

% set constraints
constr = [x >= 0;
          x <= Xmax;
          V <= Vmax;
          B >= 0];
      
% solve problem with SDPT3
options = sdpsettings('solver', 'SDPT3','verbose',2);
diagn   = optimize(constr, s, options);

plot_structure(D, double(K));