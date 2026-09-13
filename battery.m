function [SOC, SOC_min, survives, t_flat] = battery(t, P_in, P_out, P)

n = numel(t);
SOC = zeros(1, n);
SOC(1) = 1.0;

for i = 2:n
    dt = t(i) - t(i-1);
    dSOC = (P_in(i-1) - P_out) * dt / P.E_bat;
    SOC(i) = SOC(i-1) + dSOC;
    if SOC(i) > 1.0
        SOC(i) = 1.0;
    end
    if SOC(i) < 0.0
        SOC(i) = 0.0;
    end
end

SOC_min = min(SOC);
survives = SOC_min > 0;

idx = find(SOC <= 0, 1);
if isempty(idx)
    t_flat = NaN;
else
    t_flat = t(idx);
end

end