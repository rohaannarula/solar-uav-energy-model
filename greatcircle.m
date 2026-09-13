function [d, a1, a2, sigma12] = greatcircle(phi1, lam1, phi2, lam2, R)

lam12 = lam2 - lam1;

a1 = atan2( sin(lam12), ...
                cos(phi1)*tan(phi2) - sin(phi1)*cos(lam12) );

a2 = atan2( sin(lam12), ...
               -cos(phi2)*tan(phi1) + sin(phi2)*cos(lam12) );

num = sqrt( (cos(phi1)*sin(phi2) - sin(phi1)*cos(phi2)*cos(lam12))^2 ...
          + (cos(phi2)*sin(lam12))^2 );
den = sin(phi1)*sin(phi2) + cos(phi1)*cos(phi2)*cos(lam12);

sigma12 = atan2(num, den);

d = R * sigma12;

end

