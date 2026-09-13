% makeroute.m

function [lat, lon, s] = makeroute(phi1, lam1, phi2, lam2, n, R)

[d, ~, ~, sigma12] = greatcircle(phi1, lam1, phi2, lam2, R);

lat = zeros(1,n);
lon = zeros(1,n);
s   = zeros(1,n);

for k = 1:n

    f = (k-1)/(n-1);

    A = sin((1-f)*sigma12) / sin(sigma12);
    B = sin(f*sigma12) / sin(sigma12);

    x = A*cos(phi1)*cos(lam1) + ...
        B*cos(phi2)*cos(lam2);

    y = A*cos(phi1)*sin(lam1) + ...
        B*cos(phi2)*sin(lam2);

    z = A*sin(phi1) + B*sin(phi2);

    lat(k) = atan2(z, sqrt(x^2 + y^2));
    lon(k) = atan2(y, x);

    s(k) = f*d;

end

end