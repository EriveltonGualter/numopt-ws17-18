function [] = plot_state_controls(figName, x, u)
% Plots states and controls over time in the figure with
% figName

figure('Name', figName);

% Plot control:
subplot(2,1,1); plot(u,'r-.');
title(figName);
ylabel('Control: u');
xlim([1, length(u)]);
grid('on');

% Plot state:
subplot(2,1,2); plot(x,'-.');
ylabel('State: x');
xlabel('# Iter (discrete time)');
xlim([1, length(x)]);
grid('on');

end

