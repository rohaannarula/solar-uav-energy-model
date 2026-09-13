function [V, D, P_elec, CL, CD, V_stall] = cruisestate(h, P)

[~, ~, rho] = stdatm(h);

CL = sqrt(P.CD0 / P.k);
CD = P.CD0 + P.k*CL^2;

V = sqrt( 2*P.W / (rho*P.S*CL) );
D = 0.5*rho*V^2*P.S*CD;

P_elec = D*V/P.eta_prop + P.P_av;

V_stall = sqrt( 2*P.W / (rho*P.S*P.CL_max) );

end