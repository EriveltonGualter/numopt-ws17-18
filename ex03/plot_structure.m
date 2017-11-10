function plot_structure(D, K)

% INPUTS
%
% D:    Structure with problem data, created with the load_data.m function
% K:    Stifness matrix for the optimized cross-sections

close all

% flag to plot the structure deformed or not
PLOT_DEFORMED = 1;

% Calculate deformation U
Utmp = K\D.Fext;
U = zeros(numel(D.Load),1);
U(D.Ind) = Utmp';
U = reshape(U,3,size(D.Coord,2));
disp(' ')
disp('Deformation of nodes:')
disp(U(1:2,:))

Sc = 1/max(max(abs(U)))*5; % scaling factor for deformation shape
if PLOT_DEFORMED
    disp(['NOTE: deformations are scaled with a factor of ' num2str(Sc) ' to become visible' ])
end

C = [D.Coord; D.Coord + Sc*U];
e = D.Con(1,:);
f = D.Con(2,:);

for i=1:6
    M = [C(i,e); C(i,f); NaN(size(e))];
    X(:,i) = M(:);    
end

cmap = 'gray';
cmap = colormap(cmap);
cmap = flip(cmap,1);
A    = D.A;

MAXAREA = 200;
yy = linspace(0,MAXAREA,size(cmap,1)); % generate range of color indices that map to cmap
cm = spline(yy,cmap',A); % find interpolated color values
cm(cm>1) = 1;
cm(cm<0) = 0;

if PLOT_DEFORMED == 1
    DEF = 4;
else
    DEF = 1;
end

% plot resulting structure
for i = 1:length(A)
    h(i) = line([X((i-1)*3+1,DEF) X((i-1)*3+2,DEF)],[X((i-1)*3+1,DEF+1) X((i-1)*3+2,DEF+1)],'color',cm(:,i),'LineWidth',2);
end
% plot initial position and shape of structure
for i = 1:length(A)
    h(i) = line([X((i-1)*3+1,1) X((i-1)*3+2,1)],[X((i-1)*3+1,2) X((i-1)*3+2,2)],'color','cyan','LineStyle',':','LineWidth',1);
end

hold on

% plot nodes with external force applied
ind = find(sum(abs(D.Load))>0);

Coord = D.Coord + PLOT_DEFORMED*Sc*U;
for i=1:length(ind)
   plot(Coord(1,ind(i)),Coord(2,ind(i)),'or','LineWidth',10) 
end

title('Optimized structure')
xlabel('x coordinate')
ylabel('y coordinate')

axis([0 250 -50 150])

end

% code inspired from:
% http://www.mathworks.com/matlabcentral/fileexchange/14313-truss-analysis


