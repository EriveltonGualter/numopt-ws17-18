function plot_results( zlog )

if size(zlog,2) == 2
    zlog = zlog';
end

% Create figure
figure1 = figure('Position',[1 400 1200 600]);
colormap('gray');
axis square;
R=0:.002:sqrt(2);
TH=2*pi*(0:.002:1); 
X=R'*cos(TH); 
Y=R'*sin(TH); 
Z=log(1+vrosenbrock(X,Y));

% Create subplot
subplot1 = subplot(1,2,1,'Parent',figure1);
view([124 34]);
grid('on');
hold('all');

% Create surface
surf(X,Y,Z,'Parent',subplot1,'LineStyle','none');

% Create contour
contour(X,Y,Z,'Parent',subplot1);

title('Surface and contour plot of the nonlinear function');
xlabel('x')
ylabel('y')
zlabel('f(x,y)')

% Create subplot
subplot2 = subplot(1,2,2,'Parent',figure1);
%view([234 34]);
grid('on');
hold('all');

% Create contour
axis square;
contour(X,Y,Z,'Parent',subplot2);
hold on

title('Convergence of iterates');
xlabel('x')
ylabel('y')

plot(zlog(1,:),zlog(2,:),'r--*')



end

