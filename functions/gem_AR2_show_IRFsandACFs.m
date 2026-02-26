function [acf, irf] = gem_AR2_show_IRFsandACFs(phi1, phi2, horizon)

    % Close existing figure to prevent overlap
    figName = 'AR2_IRF_ACF_Comparison';
    existingFig = findall(0, 'Type', 'figure', 'Name', figName);
    if ~isempty(existingFig), close(existingFig); end

    % Initialize arrays
    irf = zeros(1, horizon + 1);
    acf = zeros(1, horizon + 1);
    
    % 1. Calculate IRF (\psi_j)
    % Starting conditions: \psi_0 = 1, \psi_1 = \phi_1
    irf(1) = 1; 
    if horizon >= 1, irf(2) = phi1; end
    for h = 3:horizon+1
        irf(h) = phi1 * irf(h-1) + phi2 * irf(h-2);
    end
    
    % 2. Calculate ACF (\rho_k)
    % Starting conditions: \rho_0 = 1, \rho_1 = \phi_1 / (1 - \phi_2)
    acf(1) = 1;
    if horizon >= 1, acf(2) = phi1 / (1 - phi2); end
    for h = 3:horizon+1
        acf(h) = phi1 * acf(h-1) + phi2 * acf(h-2);
    end
    
    % 3. Plotting
    figure('Color', 'w', 'Name', figName);
    hold on; grid on;
    
    t = 0:horizon;
    
    % Plot IRF as a solid line with markers
    plot(t, irf, '.-', 'LineWidth', 1.5, 'MarkerFaceColor', 'b', 'DisplayName', 'Impulse Response (IRF)');
    
    % Plot ACF as a dashed line with markers
    plot(t, acf, '--', 'LineWidth', 1.5, 'MarkerFaceColor', 'r', 'DisplayName', 'Autocorrelation (ACF)');
    
    % Add a zero line for reference
    line([0 horizon], [0 0], 'Color', 'k', 'LineStyle', ':', 'HandleVisibility', 'off');
    
    % Formatting
    xlabel('Lags / Time (h)');
    ylabel('Amplitude');
    title(sprintf('AR(2) Dynamics: \\phi_1=%.2f, \\phi_2=%.2f', phi1, phi2));
    legend('Location', 'northeast');
    
    % Check for stability to warn user if plot will explode
    if abs(phi2) >= 1 || (phi1 + phi2) >= 1 || (phi2 - phi1) >= 1
        text(horizon*0.1, 0.5, 'NON-STATIONARY', 'Color', 'r', 'FontSize', 14, 'FontWeight', 'bold');
    end
    
    hold off;

    set(gcf,'Position',[0 0 1200*.7 600*.7]) % 3 x 1 plot
    % set(gcf,'Position',[0 0 1000*.7 400*.7]) % 1 x 1 plot
    movegui('east')
    set(gcf, 'PaperPositionMode', 'auto');

end