function plot_chain(y, z, param)

% add edges in case they are condensed out
y = [param.xi(1); y; param.xf(1)];
z = [param.xi(2); z; param.xf(2)];

figure(1)
plot(y, z,'b--');hold on;
plot(y, z, 'Or'); hold off;
xlim([-2, 2])
ylim([ -0.5, 1.3])
title('Optimal position of chain')
xlabel('y')
ylabel('z')

end

