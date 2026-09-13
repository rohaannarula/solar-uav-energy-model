clear; clc; close all;
P = flightparams();

CL = linspace(0, P.CL_max, 200);
CD = P.CD0 + P.k*CL.^2;
LD = CL ./ CD;

fprintf('\n--- NACA 4415 drag polar, Re = 200,000 ---\n');
fprintf('CD0          : %.5f\n', P.CD0);
fprintf('k            : %.5f\n', P.k);
fprintf('Max L/D      : %.1f at CL = %.3f\n', P.LD_max, P.CL_maxLD);
fprintf('CL min power : %.3f\n', P.CL_minPwr);
fprintf('CL max       : %.3f\n', P.CL_max);

figure('Name','Drag polar');
subplot(1,2,1);
plot(CD, CL, 'b-', 'LineWidth', 2); hold on;
plot(P.CD0 + P.k*P.CL_maxLD^2,  P.CL_maxLD,  'ro', 'MarkerFaceColor','r','MarkerSize',8);
plot(P.CD0 + P.k*P.CL_minPwr^2, P.CL_minPwr, 'gs', 'MarkerFaceColor','g','MarkerSize',8);
xlabel('C_D'); ylabel('C_L');
title('Drag Polar');
legend('CD = CD0 + kCL^2','Max L/D','Min power','Location','best');
grid on;

subplot(1,2,2);
plot(CL, LD, 'b-', 'LineWidth', 2); hold on;
plot(P.CL_maxLD, P.LD_max, 'ro','MarkerFaceColor','r','MarkerSize',8);
xline(P.CL_max, 'k--', 'C_{L,max}');
xlabel('C_L'); ylabel('L/D');
title('Lift-to-Drag Ratio');
grid on;

set(gcf,'Color','w');
set(findall(gcf,'Type','axes'),'Color','w','XColor','k','YColor','k');
set(findall(gcf,'Type','text'),'Color','k');
set(findall(gcf,'-property','FontSize'),'FontSize',11);
exportgraphics(gcf,'fig_drag_polar.png','Resolution',300,'BackgroundColor','white');