function [phi2_stableRange, phi2_oscilatoryRange] = fun_AR2_phi2bounds(phi1)

    % getPhi2Bounds: Returns the valid ranges for phi2 based on phi1
    
    % Check if phi1 is within the absolute limits of the stationarity triangle
    if phi1 <= -2 || phi1 >= 2
        
        disp('Process is explosive for any phi2, since phi1 is below -2 or above 2');
        
        phi2_stableRange     = NaN;
        phi2_oscilatoryRange = NaN;

    else

        % 1. Bounds for Stability (Stationarity)
        % The triangle is bounded by: phi2 < 1 - abs(phi1) and phi2 > -1
        upperStable = 1 - abs(phi1);
        lowerStable = -1;
        phi2_stableRange = [lowerStable, upperStable];
    
        % 2. Bounds for Oscillatory Behavior
        % Oscillations occur when phi2 < -phi1^2 / 4
        % We only care about the oscillatory range THAT IS ALSO STABLE
        upperOsc = -phi1^2 / 4;
        lowerOsc = -1; 
        
        if upperOsc < lowerStable
            phi2_oscilatoryRange = []; % No part of the stable region is oscillatory
        else
            phi2_oscilatoryRange = [lowerOsc, upperOsc];
        end
    
        end

 
end