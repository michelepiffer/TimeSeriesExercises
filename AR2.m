clc
clear
close all

addpath('functions')


% study distibution og vector g conditioning on g and gmi1

% represent the AR(2) scillatory using sin cosine linke ricco 

% existing method, it is all down to the variance. If too tight, it leads
% the prior, if too high, it is driven by the overfit of the data. 

% understand how R and P affect the waves. Given some draws of the shocks,
% which then go to zero for the second half, show alternative processes for
% alternative values of R and P. Then use these simulations to derive the
% simulated Sigma in our approach



seed_number = 100;
% seed_number = 815; % strange, check 
% seed_number = 493; % borderline oscillatory
% seed_number = 491; % irf and acf quite different 
% seed_number = 950; % irf and acf quite different 
% seed_number = 50; % irf and acf identical


% seed_number = 657; % polar coordinates, 

% seed_number = randi([1, 1000], 1, 1)

% seed_number
rng(seed_number)


%% Select parameters

%%% phi 0 %%%

phi0 = 2;


%%% phi 1 %%%

% % % phi1 = 0.4;
% % % phi1 = -2 + (2+2)*rand; % within part that allows for stability
% phi1 = 0 + randn; % within part that allows for stability
% 
% phi1 = abs(phi1);
% 
% %%% phi 2 %%%
% 
% 
% [phi2_stableRange, phi2_oscilRange] = fun_AR2_phi2bounds(phi1);
% 
% % phi2 = 0.2;
% % phi2 = phi2_oscilRange(2) + (phi2_stableRange(2) - phi2_oscilRange(2))*rand; % Stable and not oscillatory
% phi2 = phi2_oscilRange(1) + (phi2_oscilRange(2) - phi2_oscilRange(1))*rand; % Stable but oscillatory
% 
% [P_periodicity, r_lastingtime] = fun_AR2_raw_to_polar(phi1, phi2);


% %%% P,r rather than phi1,phi2: polar coordinates rather than raw coefficients %%%

P_periodicity = 20; 
% P_periodicity = 5; 

% r_lastingtime = 0.95;
% r_lastingtime = 0.90;
r_lastingtime = 0.80;
assert(r_lastingtime > 0)
assert(r_lastingtime < 1)

% lower R makes the waves more erratic
% higher R makes the waves more sinusoidal


[phi1, phi2] = fun_AR2_polar_to_raw(P_periodicity, r_lastingtime);


%%% v %%%

v = 1;


%% Display properties of the process

[x1, x2, isStable, isOscillatory] = fun_AR2_properties(phi1, phi2);


phis     = [phi1, phi2]
theroots = [x1, x2]
polars   = [P_periodicity, r_lastingtime]

isStable
isOscillatory



if isStable
    unconditMean= phi0 / (1 - phi1 - phi2);
end


fun_AR2_plot_phi_space(phi1, phi2, x1, x2)

H = 70;


[acf, irf]  = gem_AR2_show_IRFsandACFs(phi1, phi2, H);

%%% acf and irfs don't just differ up to a constant
% acf./irf
% 
% [irf', acf'*(1-phi2), ]
% 
% phi1/(1-phi2)

%%% Compute periods in which the vector crosses zero

signcrossing_acf = fun_signcrossing(acf)-1;
signcrossing_irf = fun_signcrossing(irf)-1;

signcrossing_acf(2:end) - signcrossing_acf(1:end-1)
signcrossing_irf(2:end) - signcrossing_irf(1:end-1)

% both are on average equal to P/2, irrespective of r


%%% Compute the periods 

cutoff = 0.20;

x_abs    = abs(acf);
is_peak  = [0, diff(sign(diff(x_abs))) < 0, 0];
pks_acf  = x_abs(is_peak==1);
locs_acf = find(is_peak==1)-1;

below_cutoff_acf = find(pks_acf>cutoff == 0, 1, 'first')

x_abs    = abs(irf);
is_peak  = [0, diff(sign(diff(x_abs))) < 0, 0];
pks_irf  = x_abs(is_peak==1);
locs_irf = find(is_peak==1)-1;

below_cutoff_irf = find(pks_irf>cutoff == 0, 1, 'first')




%% Generate data

T = 200;
T_axis = [-1:1:T];


N = 1;


%%% Shocks
% rng(100)
eta_all = sqrt(v)*randn(T,N);
eta_all(5,:) = -3;
eta_all(6,:) = -3;
% eta_all(30,:) = 3;
% eta_all(31,:) = 3;

% eta_all(50:end,:) = 0;

% eta_all = zeros(T,N);
% eta_all(10,:) = 1;


%%% Variables via the AR(1) equation
g0    = 2;
% g0    = phi0 / (1 - phi1 - phi2); % unconditional mean
gmin1 = 1;
% gmin1 = g0;
g_all = NaN(T,N);

noshocks_all = NaN(T,N);

% % % %%% Variables via the alternative equation
% % % f_all      = NaN(T,N);
% % % % % % 
% % % % % % 
% % % %%% First difference 
% % % firstdif_all = NaN(T,N);


% % % %%% Variance of joint distribution
% % % var = NaN(T,1);

% v*1/(1-phi^2)

%%% Computations
for n = 1:N
    for t = 1:T    
    
        %%% Via the AR(1) equation
        if t == 1

            noshocks_all(t,n) = phi0 + phi1*g0 + phi2*gmin1;
            g_all(t,n)        = phi0 + phi1*g0 + phi2*gmin1 + eta_all(t,n);
            % % % firstdif_all(t,n) = g_all(t,n) - g0;

        elseif t == 2

            noshocks_all(t,n) = phi0 + phi1*noshocks_all(t-1,n) + phi2*g0;
            g_all(t,n)        = phi0 + phi1*g_all(t-1,n)        + phi2*g0 + eta_all(t,n);


        else
            
            noshocks_all(t,n) = phi0 + phi1*noshocks_all(t-1,n) + phi2*noshocks_all(t-2,n);
            g_all(t,n)        = phi0 + phi1*g_all(t-1,n)        + phi2*g_all(t-2,n)         + eta_all(t,n);
            % % % firstdif_all(t,n) = g_all(t,n) - g_all(t-1,n);

        end

        % % % %%% Alternative equivalent equation
        % % % temp = 0;
        % % % for tt = 1:t
        % % %     temp = temp + phi^(t-tt)*eta_all(tt,n);
        % % % end
        % % % f_all(t,n) = noshocks_all(t,n) + temp;


        % % % %%% Variance
        % % % temp = 0;
        % % % for tt = 1:t
        % % %     temp = temp + (phi^2)^(t-tt);
        % % % end
        % % % var(t) = v*temp;

    end
end

% % % assert( abs(var(end) - v*1/(1-phi^2) ) < 0.001) 

eta_all      = [NaN(2,N);     eta_all];
g_all        = [g0*ones(2,N); g_all];
noshocks_all = [NaN(2,N); noshocks_all];
% % % firstdif_all = [NaN(1,N);  firstdif_all];
% f_all        = [NaN(1,N);  f_all];


%% Study frequency

% changed = zeros(T,1);
% 
% for t = 2:T
%     if (g_all(t)>unconditMean && g_all(t-1)<unconditMean) || ...
%        (g_all(t)<unconditMean && g_all(t-1)>unconditMean)
% 
%         changed(t) = 1;
%     else
% 
%     end
% end


signcrossing_g = fun_signcrossing(g_all-unconditMean)-1;

signcrossing_g(2:end)' - signcrossing_g(1:end-1)'
mean(signcrossing_g(2:end) - signcrossing_g(1:end-1))


%% Figures

orange = [0.9290, 0.6940, 0.1250];
orange2 = [240 100 10]/256;
purple = [0.4940, 0.1840, 0.5560];
purple2 = [0.5140, 0.2040, 0.6060];

n = 1;

figure(10 + n)

% subplot(3,1,1)
subplot(2,1,1)
hold on; grid on;

    yline(0, ': r')

    % for n = 1:N
        index = plot(T_axis, eta_all(:,n), 'Linewidth', 1);
    % end


    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    set(gca, 'XTick', [0:5:T])
    title('Shocks $\eta_t$', 'interpreter','latex')
    xlim([0 T])


% subplot(3,1,2)
subplot(2,1,2)
hold on; grid on;

    %%% Empty arrays needed for the legend
    legend_index = [];
    legend_names = [];

    yline(0, ': r')

    % % % for t = 1:T
    % % %     temp = sqrt(var(t)); % standard deviation
    % % %     index = line([t t], [noshocks_all(t,n)-2*temp  noshocks_all(t,n)+2*temp], 'Color', orange, 'LineWidth', 2);
    % % % end
    % % % legend_index = [legend_index, index(end)];
    % % % legend_names = [legend_names; cellstr('2 standard deviations of $g_t$')];

    % for n = 1:N
        % index = plot(T_axis, g_all(:,n), 'o b', 'Linewidth', 1);
        index = plot(T_axis, g_all(:,n), 'Linewidth', 1);
    % end
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$g_t = \phi_1 \cdot g_{t-1} + \phi_2 \cdot g_{t-2} + \eta_t$')];

    index = plot(T_axis, noshocks_all(:,n), '-- k', 'Linewidth', 1);
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$l_t$')];

    % % % index = plot(T_axis(2:end), f_all(:,n), '. r', 'Linewidth', 2);
    % % % legend_index = [legend_index, index];
    % % % legend_names = [legend_names; cellstr('$f_t = \phi \cdot g_0 + sum, weighted$')];


    % If stable, add unconditional mean
    if isStable
        yline(unconditMean, ': r', 'LineWidth', 2)
    end

    %%% Check if it moved along the unconditional mean


    % temp = find(changed == 1);
    % for i_t = 1:length(temp)
    %     xline(temp(i_t), '- b')
    % end

    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    % set(gca, 'YTick', [-100:5:500]) % withoutdrift
    % set(gca, 'YTick', [-100:20:500]) % with drift
    set(gca, 'XTick', [0:5:T])
    legend(legend_index, legend_names, 'Location', 'southeast', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('Variable $g_t$ and marginal distributions', 'interpreter','latex')
    xlim([0 T])


% subplot(3,1,3)
% % subplot(2,1,2)
% hold on; grid on;
% 
%     %%% Empty arrays needed for the legend
%     legend_index = [];
%     legend_names = [];
% 
%     for t = 1:T
%         temp = sqrt(v); % standard deviation
%         index = line([t t], [g_all(t,n)-2*temp  g_all(t,n)+2*temp], 'Color', orange, 'LineWidth', 2);
%     end
%     legend_index = [legend_index, index(end)];
%     legend_names = [legend_names; cellstr('2 standard deviations of $g_t | g_{t-1}$')];
% 
%     % for n = 1:N
%         index = plot(T_axis, g_all(:,n), 'o b', 'Linewidth', 1);
%         % index = plot(T_axis, g_all(:,n), 'Linewidth', 1);
%     % end
%     legend_index = [legend_index, index];
%     legend_names = [legend_names; cellstr('$g_t = \phi \cdot g_{t-1} + \eta_t$')];
% 
%     index = plot(T_axis(2:end), noshocks_all(:,n), '-- k', 'Linewidth', 1);
%     legend_index = [legend_index, index];
%     legend_names = [legend_names; cellstr('$l_t = \phi \cdot g_{0}$')];
% 
%     % % % index = plot(T_axis(2:end), f_all(:,n), '. r', 'Linewidth', 2);
%     % % % legend_index = [legend_index, index];
%     % % % legend_names = [legend_names; cellstr('$f_t = \phi \cdot g_0 + sum, weighted$')];
% 
% 
%     %%% Additional items for the figure    
%     xlabel('time', 'interpreter','latex')
%     % set(gca, 'YTick', [-100:5:500]) % withoutdrift
%     % set(gca, 'YTick', [-100:20:500]) % with drift
%     set(gca, 'XTick', [0:5:T])
%     legend(legend_index, legend_names, 'Location', 'north', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
%     title('Variable $g_t$ and conditional distributions', 'interpreter','latex')
%     xlim([0 T])



figures_outputpath = strcat('C:\Users\k1925967\Dropbox\Apps\Overleaf\Time Series Exercises\Figures\'); 

set(gcf,'Position',[0 0 900*.7 900*.7]) % 3 x 1 plot
% set(gcf,'Position',[0 0 1000*.7 400*.7]) % 1 x 1 plot
movegui('northwest')
set(gcf, 'PaperPositionMode', 'auto');

% print(strcat(figures_outputpath, 'AR1_noconstant_a'), '-dpdf')  
% print(strcat(figures_outputpath, 'AR1_noconstant_b'), '-dpdf')  

