function [roll, pitch, elev, azim, sun_up] = panelorient(t_utc, day_of_year, lat, lon, elev_min)

sun_lat = deg2rad(23.44) * sin(2*pi*(284 + day_of_year)/365);
sun_lon = -deg2rad(15) * (t_utc - 12);
sun_lon = atan2(sin(sun_lon), cos(sun_lon));
R = 6371000;
[~, azim, ~, sigma] = greatcircle(lat, lon, sun_lat, sun_lon, R);
elev = pi/2 - sigma;
sun_up = elev > elev_min;

if ~sun_up
    roll  = NaN;
    pitch = NaN;
    return
end

s = [cos(elev)*cos(azim); cos(elev)*sin(azim); -sin(elev)];

roll  = asin(max(-1, min(1, s(2))));
pitch = atan2(-s(1), -s(3));

end
