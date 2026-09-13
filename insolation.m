function I = insolation(elev, h)

I0 = 1361;
p0 = 101325;

if elev <= 0
    I = 0;
    return
end

z = 90 - rad2deg(elev);

AM = 1 / ( cosd(z) + 0.50572*(96.07995 - z)^(-1.6364) );

[~, p, ~] = stdatm(h);
AM_eff = AM * p/p0;

I = I0 * 0.7^(AM_eff^0.678);

end