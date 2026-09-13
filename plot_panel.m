

clear;
clc;
close all;

P = flightparams();



[lat, lon, s] = makeroute( ...
    P.lhr(1), P.lhr(2), ...
    P.jfk(1), P.jfk(2), ...
    P.n, P.R);

h_cruise = 3000;
[V, ~, ~] = cruisestate(h_cruise, P);
t = s / V;



roll   = zeros(1, P.n);
pitch  = zeros(1, P.n);
elev   = zeros(1, P.n);
azim   = zeros(1, P.n);
sun_up = false(1, P.n);

for k = 1:P.n

    
    t_utc = mod(P.t0_utc + t(k)/3600, 24);

    [roll(k), pitch(k), elev(k), azim(k), sun_up(k)] = ...
        panelorient( ...
        t_utc, ...
        P.day_of_year, ...
        lat(k), lon(k), ...
        P.elev_min);

end



fprintf('\n--- Sun and panel orientation ---\n');
fprintf('Flight time       : %.2f h\n', t(end)/3600);
fprintf('Daylight fraction : %.1f %%\n', 100*sum(sun_up)/P.n);
fprintf('Peak elevation    : %.2f deg\n', max(rad2deg(elev)));
fprintf('Min elevation     : %.2f deg\n', min(rad2deg(elev)));

k_set = find(diff(sun_up) == -1, 1);
k_ris = find(diff(sun_up) ==  1, 1);
if ~isempty(k_set)
    fprintf('Sunset at         : %.2f h\n', t(k_set)/3600);
end
if ~isempty(k_ris)
    fprintf('Sunrise at        : %.2f h\n', t(k_ris)/3600);
end


figure('Name','Sun and panel orientation');

subplot(4,1,1);
plot(t/3600, rad2deg(roll), 'b-', 'LineWidth', 1.5);
ylabel('Panel roll [deg]');
title('Ideal Solar Panel Orientation Along the Route');
grid on;

subplot(4,1,2);
plot(t/3600, rad2deg(pitch), 'b-', 'LineWidth', 1.5);
ylabel('Panel pitch [deg]');
grid on;

subplot(4,1,3);
plot(t/3600, rad2deg(elev), 'b-', 'LineWidth', 1.5);
hold on;
yline(0, 'k--');                    % the horizon
ylabel('Sun elevation [deg]');
grid on;

subplot(4,1,4);
plot(t/3600, mod(rad2deg(azim), 360), 'b-', 'LineWidth', 1.5);
ylabel('Sun azimuth [deg]');
xlabel('Time [h]');
grid on;

prettyfig(gcf);
exportgraphics(gcf, 'fig_panel_orientation.png', ...
    'Resolution', 300, 'BackgroundColor', 'white');
