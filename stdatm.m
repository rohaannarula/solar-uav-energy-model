function [T, p, rho] = stdatm(h)

g  = 9.80665;
R  = 287.053;
p0 = 101325;
T0 = 288.15;
L  = -0.0065;

if any(h(:) < 0) || any(h(:) > 11000)
    error('Altitude must be 0 to 11000 m.');
end

T   = T0 + L*h;
p   = p0 * (T/T0).^(-g/(R*L));
rho = p ./ (R*T);

end

