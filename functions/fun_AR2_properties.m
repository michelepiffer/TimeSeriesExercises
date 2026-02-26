function [x1, x2, isStable, isOscillatory] = fun_AR2_properties(phi1, phi2)

    % analyzeAR2 computes the roots of the characteristic equation
    % x^2 - phi1*x - phi2 = 0 and determines process behavior.

    % 1. Compute the roots using the literal quadratic formula
    % complex() ensures the result is complex if the discriminant is negative
    discriminant = phi1^2 + 4*phi2;
    x1 = (phi1 + sqrt(complex(discriminant))) / 2;
    x2 = (phi1 - sqrt(complex(discriminant))) / 2;

    % 2. Stability Logical: Both roots must have a magnitude < 1
    % abs() correctly handles both real and complex numbers
    isStable = abs(x1) < 1 && abs(x2) < 1;

    % 3. Oscillatory Logical: Roots are complex (discriminant < 0)
    isOscillatory = discriminant < 0;
end