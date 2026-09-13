clear; clc; close all;
P = flightparams();

altitudes = 0:1000:10000;
na = numel(altitudes);

[lat, lon, s] = makeroute(P.lhr(1), P.lhr(2), P.jfk(1), P.jfk(2), P.n, P.R);

V=zeros(1,na); P_elec=zeros(1,na); t_tot=zeros(1,na);
E_req=zeros(1,na); SOCmin_l=zeros(1,na); SOCmin_g=zeros(1,na);
surv_l=false(1,na); surv_g=false(1,na);
SOC_l_ref=[]; SOC_g_ref=[]; t_ref=[];

for j = 1:na

    h = altitudes(j);
    [V(j), ~, P_elec(j)] = cruisestate(h, P);

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

    [SOC_l, SOCmin_l(j), surv_l(j)] = battery(t, P_l, P_elec(j), P);
    [SOC_g, SOCmin_g(j), surv_g(j)] = battery(t, P_g, P_elec(j), P);

    if h == 3000
        SOC_l_ref = SOC_l;
        SOC_g_ref = SOC_g;
        t_ref = t;
    end

end

[~, j_energy] = min(E_req);
[~, j_margin] = max(SOCmin_l);

fprintf('\n--- Battery state of charge study ---\n');
fprintf('Battery capacity : %.2f MJ (%.0f Wh)\n\n', P.E_bat/1e6, P.E_bat/3600);
fprintf('  h(m)     V  P_el(W)   t(h)   E_req  SOCmin_lvl  SOCmin_gim\n');
for j = 1:na
    fprintf('%6d %6.2f %8.2f %6.1f %7.2f %11.3f %11.3f\n', ...
        altitudes(j), V(j), P_elec(j), t_tot(j)/3600, E_req(j)/1e6, SOCmin_l(j), SOCmin_g(j));
end

fprintf('\nMinimum ENERGY REQUIRED at %d m (%.2f MJ)\n', altitudes(j_energy), E_req(j_energy)/1e6);
fprintf('Maximum BATTERY MARGIN at %d m (SOC min %.3f)\n', altitudes(j_margin), SOCmin_l(j_margin));
if j_energy ~= j_margin
    fprintf('\nThese are DIFFERENT altitudes. Minimising energy and maximising\n');
    fprintf('battery margin are competing objectives.\n');
end
fprintf('\nAll altitudes survive: level %d, gimbaled %d\n', all(surv_l), all(surv_g));
fprintf('AtlantikSolar published minimum SOC on record flight: 0.39\n');

figure('Name','SOC over the flight');
plot(t_ref/3600, SOC_g_ref, 'b-',  'LineWidth', 2); hold on;
plot(t_ref/3600, SOC_l_ref, 'r--', 'LineWidth', 2);
yline(0, 'k-', 'LineWidth', 1.5);
yline(0.30, 'k:', '30% requirement', 'LineWidth', 1.4);
xlabel('Time [h]');
ylabel('State of charge [-]');
title('Battery State of Charge, 3000m Cruise');
legend('Gimbaled panel','Level panel','Location','best');
ylim([0 1.05]); grid on;
set(gcf,'Color','w');
set(findall(gcf,'Type','axes'),'Color','w','XColor','k','YColor','k');
set(findall(gcf,'Type','text'),'Color','k');
set(findall(gcf,'-property','FontSize'),'FontSize',11);
exportgraphics(gcf,'fig_soc_history_v3.png','Resolution',300,'BackgroundColor','white');

figure('Name','Competing objectives');
yyaxis left
plot(altitudes/1000, E_req/1e6, 'k-o', 'LineWidth', 2);
ylabel('Energy required [MJ]');
yyaxis right
plot(altitudes/1000, SOCmin_l, 'r--s', 'LineWidth', 2); hold on;
plot(altitudes/1000, SOCmin_g, 'b-^',  'LineWidth', 2);
ylabel('Minimum state of charge [-]');
xlabel('Cruise altitude [km]');
title('Energy Required versus Battery Margin');
legend('Energy required','SOC min, level','SOC min, gimbaled','Location','best');
grid on;
set(gcf,'Color','w');
set(findall(gcf,'Type','axes'),'Color','w','XColor','k','YColor','k');
set(findall(gcf,'Type','text'),'Color','k');
set(findall(gcf,'-property','FontSize'),'FontSize',11);
exportgraphics(gcf,'fig_soc_vs_altitude_v3.png','Resolution',300,'BackgroundColor','white');