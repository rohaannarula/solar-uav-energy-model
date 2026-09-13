clear; clc; close all;
P = flightparams();

altitudes = 0:1000:10000;
na = numel(altitudes);

[lat, lon, s] = makeroute(P.lhr(1), P.lhr(2), P.jfk(1), P.jfk(2), P.n, P.R);

V=zeros(1,na); D=zeros(1,na); P_elec=zeros(1,na); Vs=zeros(1,na);
t_tot=zeros(1,na); E_req=zeros(1,na); E_lvl=zeros(1,na); E_gim=zeros(1,na);

for j = 1:na

    h = altitudes(j);
    [V(j), D(j), P_elec(j), ~, ~, Vs(j)] = cruisestate(h, P);

    t = s / V(j);
    t_tot(j) = t(end);
    E_req(j) = P_elec(j) * t_tot(j);

    P_l = zeros(1, P.n);
    P_g = zeros(1, P.n);

    for k = 1:P.n
        t_utc = mod(P.t0_utc + t(k)/3600, 24);
        [~, ~, elev, ~, sun_up] = panelorient(t_utc, P.day_of_year, lat(k), lon(k), P.elev_min);
        if ~sun_up
            continue
        end
        I = insolation(elev, h);
        P_g(k) = I * P.A_panel * P.eta_sm * P.eta_mppt;
        P_l(k) = P_g(k) * sin(elev);
    end

    E_lvl(j) = trapz(t, P_l);
    E_gim(j) = trapz(t, P_g);

end

[E_best, jb] = min(E_req);

fprintf('\n--- Altitude study: London Heathrow to JFK ---\n');
fprintf('Route distance : %.1f km\n', s(end)/1000);
fprintf('Panel area     : %.4f m^2\n', P.A_panel);
fprintf('CL = %.3f, L/D = %.1f\n\n', P.CL_maxLD, P.LD_max);
fprintf('  h(m)   V(m/s) Vstall   D(N)   P_el(W)   t(h)   E_req   E_lvl   E_gim\n');
for j = 1:na
    fprintf('%6d %7.2f %6.2f %6.3f %8.2f %7.1f %7.2f %7.2f %7.2f\n', ...
        altitudes(j), V(j), Vs(j), D(j), P_elec(j), t_tot(j)/3600, ...
        E_req(j)/1e6, E_lvl(j)/1e6, E_gim(j)/1e6);
end

fprintf('\nBEST ALTITUDE: %d m\n', altitudes(jb));
fprintf('  Energy required  : %.2f MJ (%.1f kWh)\n', E_best/1e6, E_best/3.6e6);
fprintf('  Cruise speed     : %.2f m/s\n', V(jb));
fprintf('  Flight time      : %.1f h (%.2f days)\n', t_tot(jb)/3600, t_tot(jb)/86400);
fprintf('  Harvest level    : %.2f MJ, net %+.2f MJ\n', E_lvl(jb)/1e6, (E_lvl(jb)-E_best)/1e6);
fprintf('  Harvest gimbaled : %.2f MJ, net %+.2f MJ\n', E_gim(jb)/1e6, (E_gim(jb)-E_best)/1e6);
fprintf('  Gain from gimbal : %.1f %%\n', 100*(E_gim(jb)/E_lvl(jb)-1));
fprintf('  E_req spread     : %.1f %% across altitude range\n', 100*(max(E_req)-min(E_req))/min(E_req));

figure('Name','Energy vs altitude');
plot(altitudes/1000, E_req/1e6, 'k-o', 'LineWidth', 2);  hold on;
plot(altitudes/1000, E_lvl/1e6, 'r--s','LineWidth', 1.5);
plot(altitudes/1000, E_gim/1e6, 'b-^', 'LineWidth', 1.5);
plot(altitudes(jb)/1000, E_req(jb)/1e6, 'kp', 'MarkerSize', 14, 'MarkerFaceColor', 'y');
xlabel('Cruise altitude [km]');
ylabel('Energy over the flight [MJ]');
title('Energy Required and Harvested versus Cruise Altitude');
legend('Required','Harvested, level panel','Harvested, gimbaled','Minimum required','Location','best');
grid on;
set(gcf,'Color','w');
set(findall(gcf,'Type','axes'),'Color','w','XColor','k','YColor','k');
set(findall(gcf,'Type','text'),'Color','k');
set(findall(gcf,'-property','FontSize'),'FontSize',11);
exportgraphics(gcf,'fig_energy_vs_altitude.png','Resolution',300,'BackgroundColor','white');

figure('Name','Cruise state vs altitude');
subplot(3,1,1);
plot(altitudes/1000, V, 'b-o','LineWidth',1.5); hold on;
plot(altitudes/1000, Vs,'r--','LineWidth',1.2);
ylabel('Airspeed [m/s]'); legend('Cruise','Stall','Location','best');
title('Steady Level Cruise State versus Altitude'); grid on;

subplot(3,1,2);
plot(altitudes/1000, D, 'b-o','LineWidth',1.5);
ylabel('Drag [N]'); ylim([0 1.2*max(D)]); grid on;

subplot(3,1,3);
plot(altitudes/1000, P_elec, 'b-o','LineWidth',1.5);
ylabel('Power required [W]'); xlabel('Cruise altitude [km]'); grid on;
set(gcf,'Color','w');
set(findall(gcf,'Type','axes'),'Color','w','XColor','k','YColor','k');
set(findall(gcf,'Type','text'),'Color','k');
set(findall(gcf,'-property','FontSize'),'FontSize',11);
exportgraphics(gcf,'fig_cruise_vs_altitude.png','Resolution',300,'BackgroundColor','white');