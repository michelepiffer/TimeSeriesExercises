function [phi1, phi2] = fun_AR2_polar_to_raw(Periodicity, Rmodulus)

assert(Rmodulus > 0)
assert(Rmodulus < 1)

theta = 2*pi/Periodicity; 
phi1  = 2*Rmodulus*cos(theta); 
phi2  = -Rmodulus^2;


end