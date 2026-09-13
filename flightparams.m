function P = flightparams()

P.g  = 9.80665;
P.R  = 6371000;
P.mu = 1.81e-5;

P.b          = 5.65;
P.c          = 0.305;

P.AR         = 18.5;
P.e          = 0.92;
P.V_stall_SL = 8.1;

P.eta_prop = 0.58;
P.eta_sm   = 0.20;
P.eta_mppt = 0.95;
P.f_sm     = 0.94;

P.P_av  = 4.5;
P.e_bat = 874800;

P.batt_scale = 1.0;
P.E_bat = 850 * 3600 * P.batt_scale;
P.m_bat = 3.52 * P.batt_scale;

P.S = P.b * P.c;
P.m = 7.36 - 3.52 + P.m_bat;
P.W = P.m * P.g;

P.A_panel = P.S;

P.a0_2D    = 4.1529;
P.CL0_2D   = 0.6578;
P.alpha_L0 = -9.075;
P.Cd0_2D   = 0.00861;
P.kp_2D    = 0.00578;

P.a_3D = P.a0_2D / (1 + P.a0_2D/(pi*P.e*P.AR));
P.k_i  = 1/(pi*P.e*P.AR);
P.CD0  = P.Cd0_2D;
P.k    = P.kp_2D + P.k_i;

P.CL_maxLD  = sqrt(P.CD0/P.k);
P.CL_minPwr = sqrt(3*P.CD0/P.k);
P.LD_max    = 1/(2*sqrt(P.CD0*P.k));
P.CL_max    = 1.34;

P.day_of_year = 172;
P.t0_utc      = 12;
P.elev_min    = deg2rad(5);
P.n           = 2000;

P.lhr = [deg2rad(51.4700), deg2rad(-0.4543)];
P.jfk = [deg2rad(40.6413), deg2rad(-73.7781)];

end