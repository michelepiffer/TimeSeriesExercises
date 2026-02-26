function fun_AR2_plot_phi_space(phi1, phi2, x1, x2)

    % % plotAR2Space: Visualizes the AR(2) parameter space and the specific input
    % 
    % % 1. Setup the Phi1 range for the boundaries
    % p1_range = linspace(-2, 2, 400);
    % 
    % % 2. Define the Triangle Boundaries
    % upper_bound = 1 - abs(p1_range); % Combines phi2 < 1-phi1 and phi2 < 1+phi1
    % lower_limit = -1;
    % 
    % % 3. Define the Parabola (Oscillatory Boundary)
    % parabola = -(p1_range.^2) / 4;
    % 
    % % 4. Initialize Plot
    % % figure('Color', 'w');
    % hold on; grid on;
    % 
    % % 5. Fill the Regions
    % % Fill Stable & Monotonic (Region between upper triangle and parabola)
    % fill_x = [p1_range, fliplr(p1_range)];
    % fill_y = [upper_bound, fliplr(max(parabola, lower_limit))];
    % fill(fill_x, fill_y, [0.85 0.95 1], 'EdgeColor', 'none', 'DisplayName', 'Stable & Monotonic');
    % 
    % % Fill Stable & Oscillatory (Region between parabola and bottom of triangle)
    % fill_y2 = [max(parabola, lower_limit), fliplr(lower_limit * ones(size(p1_range)))];
    % fill(fill_x, fill_y2, [0.7 0.8 1], 'EdgeColor', 'none', 'DisplayName', 'Stable & Oscillatory');
    % 
    % % 6. Plot the specific boundaries
    % plot(p1_range, upper_bound, 'k-', 'LineWidth', 2, 'HandleVisibility', 'off');
    % plot(p1_range, parabola, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Parabola (\phi_1^2 + 4\phi_2 = 0)');
    % line([-2, 2], [-1, -1], 'Color', 'k', 'LineWidth', 2, 'HandleVisibility', 'off');
    % 
    % % 7. Corrected Stability Logic
    % % Using the standard 3-condition check
    % cond1 = (phi1 + phi2 < 1);
    % cond2 = (phi2 - phi1 < 1);
    % cond3 = (phi2 > -1);
    % isStable = cond1 && cond2 && cond3;
    % 
    % isOsc = (phi1^2 + 4*phi2 < 0);
    % 
    % % 8. Plot the User's Point
    % plot(phi1, phi2, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', 'Current Process');
    % 
    % % 9. Formatting
    % xlabel('\phi_1'); ylabel('\phi_2');
    % title('AR(2) Stability Triangle');
    % axis([-2.2 2.2 -1.2 1.2]);
    % 
    % % Improved status label
    % statusStr = {sprintf('\\phi_1 = %.2f, \\phi_2 = %.2f', phi1, phi2), ...
    %              sprintf('Stable: %s', upper(string(isStable))), ...
    %              sprintf('Oscillatory: %s', upper(string(isOsc)))};
    % annotation('textbox', [0.15, 0.7, 0.2, 0.2], 'String', statusStr, ...
    %            'FitBoxToText', 'on', 'BackgroundColor', 'w');
    % 
    % legend('Location', 'northeast');
    % hold off;

    % plotAR2Space: Visualizes the AR(2) parameter space and the specific input
    
    % Close existing figure with this specific name to prevent overlapping
    figName = 'AR2_Stability_Analysis';
    existingFig = findall(0, 'Type', 'figure', 'Name', figName);
    if ~isempty(existingFig)
        close(existingFig);
    end
    
    % 1. Setup the Phi1 range for the boundaries
    p1_range = linspace(-2, 2, 400);
    
    % 2. Define the Triangle Boundaries
    upper_bound = 1 - abs(p1_range); 
    lower_limit = -1;
    
    % 3. Define the Parabola (Oscillatory Boundary)
    parabola = -(p1_range.^2) / 4;
    
    % 4. Initialize Plot
    figure('Color', 'w', 'Name', figName);
    hold on; grid on;
    
    % 5. Fill the Regions
    fill_x = [p1_range, fliplr(p1_range)];
    fill_y = [upper_bound, fliplr(max(parabola, lower_limit))];
    fill(fill_x, fill_y, [0.85 0.95 1], 'EdgeColor', 'none', 'DisplayName', 'Stable & Monotonic');
    
    fill_y2 = [max(parabola, lower_limit), fliplr(lower_limit * ones(size(p1_range)))];
    fill(fill_x, fill_y2, [0.7 0.8 1], 'EdgeColor', 'none', 'DisplayName', 'Stable & Oscillatory');
    
    % 6. Plot the specific boundaries
    plot(p1_range, upper_bound, 'k-', 'LineWidth', 2, 'HandleVisibility', 'off');
    plot(p1_range, parabola, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Parabola: \phi_1^2 + 4\phi_2 = 0');
    line([-2, 2], [-1, -1], 'Color', 'k', 'LineWidth', 2, 'HandleVisibility', 'off');
    
    % 7. Stability & Logic
    isStable = (phi1 + phi2 < 1) && (phi2 - phi1 < 1) && (phi2 > -1);
    isOsc = (phi1^2 + 4*phi2 < 0);
    
    % 8. Build the Combined Legend String
    % Part A: Parameters
    legStr = sprintf('Param values: \\phi_1=%.2f, \\phi_2=%.2f', phi1, phi2);
    
    % Part B: Roots (only if not NaN)
    if nargin >= 4 && ~any(isnan([x1, x2]))
        if isreal(x1)
            rootStr = sprintf('Implied roots: %.2f, %.2f', x1, x2);
        else
            rootStr = sprintf('Implied roots: %.2f \\pm %.2fi', real(x1), abs(imag(x1)));
        end
        legStr = sprintf('%s\n%s', legStr, rootStr);
    end
    
    % Part C: Status
    statusStr = sprintf('Process is: %s, %s', ...
        ifThenElse(isStable, 'STABLE', 'UNSTABLE'), ...
        ifThenElse(isOsc, 'OSCILLATORY', 'MONOTONIC'));
    legStr = sprintf('%s\n%s', legStr, statusStr);
    
    % 9. Plot the User's Point with the giant legend entry
    plot(phi1, phi2, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', legStr);
    
    % 10. Final Formatting
    xlabel('\phi_1'); ylabel('\phi_2');
    title('AR(2) Parameter Space Analysis');
    axis([-2.2 2.2 -1.2 1.5]); % Increased y-upper slightly for legend room
    
    legend('Location', 'northeast', 'FontSize', 9);
    hold off;
    
    
    set(gcf,'Position',[0 0 1200*.7 600*.7]) % 3 x 1 plot
    % set(gcf,'Position',[0 0 1000*.7 400*.7]) % 1 x 1 plot
    movegui('northwest')
    set(gcf, 'PaperPositionMode', 'auto');


end

% Helper function for inline conditional strings (for cleaner code)
function out = ifThenElse(condition, strTrue, strFalse)
    if condition, out = strTrue; else, out = strFalse; end
end
