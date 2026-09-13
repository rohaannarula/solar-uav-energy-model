clear; clc; close all;
P = flightparams();

h_cruise = 3000;

[lat, lon, s] = makeroute(P.lhr(1), P.lhr(2), P.jfk(1), P.jfk(2), P.n, P.R);
[V, D, P_elec] = cruisestate(h_cruise, P);
t = s / V;

P_lvl  = zeros(1,P.n);
P_gim  = zeros(1,P.n);
P_old  = zeros(1,P.n);
I_hist = zeros(1,P.n);
elev   = zeros(1,P.n);
up     = false(1,P.n);

for k = 1:P.n
    t_utc = mod(P.t0_utc + t(k)/3600, 24);
    [~, ~, elev(k), ~, up(k)] = panelorient(t_utc, P.day_of_year, lat(k), lon(k), P.elev_min);

    if ~up(k)
        continue
    end

    I_hist(k) = insolation(elev(k), h_cruise);
    P_gim(k) = I_hist(k) * P.A_panel * P.eta_sm * P.eta_mppt;
    P_lvl(k) = P_gim(k) * sin(elev(k));
    P_old(k) = 1000 * P.A_panel * P.eta_sm * P.eta_mppt;
end

E_lvl = trapz(t, P_lvl);
E_gim = trapz(t, P_gim);
E_old = trapz(t, P_old);
E_req = P_elec * t(end);

fprintf('\n--- Energy over the route, cruise altitude %d m ---\n', h_cruise);
fprintf('Cruise speed      : %.2f m/s\n', V);
fprintf('Flight time       : %.1f h (%.2f days)\n', t(end)/3600, t(end)/86400);
fprintf('Daylight fraction : %.1f %%\n', 100*sum(up)/P.n);
fprintf('Peak insolation   : %.1f W/m^2\n', max(I_hist));
fprintf('Peak power gimbal : %.1f W\n', max(P_gim));
fprintf('Peak power level  : %.1f W\n', max(P_lvl));
fprintf('Energy required   : %.2f MJ\n', E_req/1e6);
fprintf('Harvested level   : %.2f MJ, net %+.2f MJ\n', E_lvl/1e6, (E_lvl-E_req)/1e6);
fprintf('Harvested gimbal  : %.2f MJ, net %+.2f MJ\n', E_gim/1e6, (E_gim-E_req)/1e6);
fprintf('Gain from gimbal  : %.1f %%\n', 100*(E_gim/E_lvl - 1));
fprintf('Old constant model: %.2f MJ, overstates by %.1f %%\n', E_old/1e6, 100*(E_old/E_gim-1));

figure('Name','Energy collected: gimbaled vs level');
plot(t/3600, P_gim, 'b-',  'LineWidth', 2); hold on;
plot(t/3600, P_lvl, 'r--', 'LineWidth', 2);
xlabel('Time [h]');
ylabel('Power collected [W]');
title(sprintf('Solar Power Collected Along the Route (%d m)', h_cruise));
legend('Gimbaled panel','Level panel','Location','best');
grid on;
set(gcf,'Color','w');
set(findall(gcf,'Type','axes'),'Color','w','XColor','k','YColor','k');
set(findall(gcf,'Type','text'),'Color','k');
set(findall(gcf,'-property','FontSize'),'FontSize',11);
exportgraphics(gcf,'fig_energy_comparison.png','Resolution',300,'BackgroundColor','white');

figure('Name','Effect of insolation model');
subplot(2,1,1);
plot(t/3600, I_hist, 'b-','LineWidth',1.5); hold on;
yline(1000,'r--','LineWidth',1.2);
ylabel('Irradiance [W/m^2]');
legend('Kasten-Young model','Old constant assumption','Location','best');
title('Effect of Modelling Atmospheric Attenuation');
grid on;

subplot(2,1,2);
plot(t/3600, P_gim, 'b-', 'LineWidth',2); hold on;
plot(t/3600, P_old, 'r--','LineWidth',1.2);
xlabel('Time [h]'); ylabel('Power, gimbaled [W]');
legend('With insolation','Constant 1000 W/m^2','Location','best');
grid on;
set(gcf,'Color','w');
set(findall(gcf,'Type','axes'),'Color','w','XColor','k','YColor','k');
set(findall(gcf,'Type','text'),'Color','k');
set(findall(gcf,'-property','FontSize'),'FontSize',11);
exportgraphics(gcf,'fig_insolation_effect.png','Resolution',300,'BackgroundColor','white');