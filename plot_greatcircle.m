
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



hdg = zeros(1, P.n);

for k = 1:P.n-1
    [~, hdg(k)] = greatcircle( ...
        lat(k), lon(k), ...
        P.jfk(1), P.jfk(2), ...
        P.R);
end


hdg(P.n) = hdg(P.n-1);


fprintf('\n--- Great circle route ---\n');
fprintf('Distance        : %.1f km\n', s(end)/1000);
fprintf('Flight time     : %.2f h (%.2f days)\n', t(end)/3600, t(end)/86400);
fprintf('Initial heading : %.2f deg\n', mod(rad2deg(hdg(1)),   360));
fprintf('Final heading   : %.2f deg\n', mod(rad2deg(hdg(end)), 360));
fprintf('Heading change  : %.2f deg\n', ...
    mod(rad2deg(hdg(1)),360) - mod(rad2deg(hdg(end)),360));
fprintf('Max latitude    : %.2f deg\n', max(rad2deg(lat)));



figure('Name','Great circle path');

plot(rad2deg(lon), rad2deg(lat), 'b-', 'LineWidth', 2);
hold on;


plot(rad2deg([P.lhr(2) P.jfk(2)]), rad2deg([P.lhr(1) P.jfk(1)]), ...
    'r--', 'LineWidth', 1.2);


plot(rad2deg([P.lhr(2) P.jfk(2)]), rad2deg([P.lhr(1) P.jfk(1)]), ...
    'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);

text(rad2deg(P.lhr(2))+1.5, rad2deg(P.lhr(1)), 'LHR');
text(rad2deg(P.jfk(2))+1.5, rad2deg(P.jfk(1)), 'JFK');

xlabel('Longitude [deg]');
ylabel('Latitude [deg]');
title('Great Circle Route: London Heathrow to JFK');
legend('Great circle', 'Straight line in lat/lon', 'Location', 'best');
grid on;
axis equal;

prettyfig(gcf);
exportgraphics(gcf, 'fig_route_path.png', ...
    'Resolution', 300, 'BackgroundColor', 'white');



figure('Name','Route state vs time');

subplot(3,1,1);
plot(t/3600, rad2deg(lat), 'b-', 'LineWidth', 1.5);
ylabel('Latitude [deg]');
title('Great Circle Route State Histories');
grid on;

subplot(3,1,2);
plot(t/3600, rad2deg(lon), 'b-', 'LineWidth', 1.5);
ylabel('Longitude [deg]');
grid on;

subplot(3,1,3);
plot(t/3600, mod(rad2deg(hdg), 360), 'b-', 'LineWidth', 1.5);
ylabel('Heading [deg]');
xlabel('Time [h]');
grid on;

prettyfig(gcf);
exportgraphics(gcf, 'fig_route_states.png', ...
    'Resolution', 300, 'BackgroundColor', 'white');
