function [Periodicity, Rmodulus] = fun_AR2_raw_to_polar(phi1, phi2)

    % 1. Calculate the Modulus
    % Since phi2 = -R^2, R must be the square root of -phi2
    Rmodulus = sqrt(-phi2);
    
    % Validation: For complex roots in AR(2), phi1^2 + 4*phi2 < 0
    % and the modulus must be between 0 and 1 for stability.
    % assert(isreal(Rmodulus), 'Modulus is complex; check if phi2 is positive.');
    % assert(Rmodulus < 1, 'The process is unstable (modulus >= 1).');

    % 2. Calculate the Angle (theta)
    % From phi1 = 2 * R * cos(theta)
    theta = acos(phi1 / (2 * Rmodulus));

    % 3. Calculate Periodicity
    % From theta = 2*pi / Periodicity
    Periodicity = (2 * pi) / theta;
end