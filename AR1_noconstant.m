clc
clear
close all


%% Main parameters

phi = 0.9;
% phi = 0.3;

v = 1;

T = 50;
T_axis = [0:1:T];


N = 10;

%% Generate data

%%% Shocks
rng(100)
eta_all = sqrt(v)*randn(T,N);
eta_all(5,:) = -3;
eta_all(6,:) = -3;
% eta_all(30,:) = 3;
% eta_all(31,:) = 3;
eta_all(7:end,:) = 0;



%%% Variables via the AR(1) equation
g0 = 5;
g_all      = NaN(T,N);

noshocks_all = NaN(T,N);

%%% Variables via the alternative equation
f_all      = NaN(T,N);
% % % 
% % % 
%%% First difference 
firstdif_all = NaN(T,N);


%%% Variance of joint distribution
var = NaN(T,1);

% v*1/(1-phi^2)

%%% Computations
for n = 1:N
    for t = 1:T    
    
        %%% Via the AR(1) equation
        if t == 1
            g_all(t,n)        = phi*g0 + eta_all(t,n);
            firstdif_all(t,n) = g_all(t,n) - g0;

        else
            g_all(t,n)        = phi*g_all(t-1,n) + eta_all(t,n);
            firstdif_all(t,n) = g_all(t,n) - g_all(t-1,n);

        end
        noshocks_all(t,n) = phi^t*g0;

        %%% Alternative equivalent equation
        temp = 0;
        for tt = 1:t
            temp = temp + phi^(t-tt)*eta_all(tt,n);
        end
        f_all(t,n) = noshocks_all(t,n) + temp;


        %%% Variance
        temp = 0;
        for tt = 1:t
            temp = temp + (phi^2)^(t-tt);
        end
        var(t) = v*temp;

    end
end

assert( abs(var(end) - v*1/(1-phi^2) ) < 0.001) 

eta_all      = [NaN(1,N);  eta_all];
g_all        = [g0*ones(1,N);  g_all];
% % % noshocks_all = [NaN(1,N); noshocks_all];
% % % firstdif_all = [NaN(1,N);  firstdif_all];
% f_all        = [NaN(1,N);  f_all];


%% Figures

orange = [0.9290, 0.6940, 0.1250];
orange2 = [240 100 10]/256;
purple = [0.4940, 0.1840, 0.5560];
purple2 = [0.5140, 0.2040, 0.6060];

n = 1;

figure(n)

subplot(3,1,1)
% subplot(2,1,1)
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


subplot(3,1,2)
% subplot(2,1,2)
hold on; grid on;

    %%% Empty arrays needed for the legend
    legend_index = [];
    legend_names = [];


    for t = 1:T
        temp = sqrt(var(t)); % standard deviation
        index = line([t t], [noshocks_all(t,n)-2*temp  noshocks_all(t,n)+2*temp], 'Color', orange, 'LineWidth', 2);
    end
    legend_index = [legend_index, index(end)];
    legend_names = [legend_names; cellstr('2 standard deviations of $g_t$')];

    % for n = 1:N
        index = plot(T_axis, g_all(:,n), 'o b', 'Linewidth', 1);
        % index = plot(T_axis, g_all(:,n), 'Linewidth', 1);
    % end
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$g_t = \phi \cdot g_{t-1} + \eta_t$')];

    index = plot(T_axis(2:end), noshocks_all(:,n), '-- k', 'Linewidth', 1);
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$l_t = \phi \cdot g_{0}$')];

    index = plot(T_axis(2:end), f_all(:,n), '. r', 'Linewidth', 2);
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$f_t = \phi \cdot g_0 + sum, weighted$')];


    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    % set(gca, 'YTick', [-100:5:500]) % withoutdrift
    % set(gca, 'YTick', [-100:20:500]) % with drift
    set(gca, 'XTick', [0:5:T])
    legend(legend_index, legend_names, 'Location', 'southeast', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('Variable $g_t$ and marginal distributions', 'interpreter','latex')
    xlim([0 T])


subplot(3,1,3)
% subplot(2,1,2)
hold on; grid on;

    %%% Empty arrays needed for the legend
    legend_index = [];
    legend_names = [];

    for t = 1:T
        temp = sqrt(v); % standard deviation
        index = line([t t], [g_all(t,n)-2*temp  g_all(t,n)+2*temp], 'Color', orange, 'LineWidth', 2);
    end
    legend_index = [legend_index, index(end)];
    legend_names = [legend_names; cellstr('2 standard deviations of $g_t | g_{t-1}$')];

    % for n = 1:N
        index = plot(T_axis, g_all(:,n), 'o b', 'Linewidth', 1);
        % index = plot(T_axis, g_all(:,n), 'Linewidth', 1);
    % end
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$g_t = \phi \cdot g_{t-1} + \eta_t$')];

    index = plot(T_axis(2:end), noshocks_all(:,n), '-- k', 'Linewidth', 1);
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$l_t = \phi \cdot g_{0}$')];

    % % % index = plot(T_axis(2:end), f_all(:,n), '. r', 'Linewidth', 2);
    % % % legend_index = [legend_index, index];
    % % % legend_names = [legend_names; cellstr('$f_t = \phi \cdot g_0 + sum, weighted$')];


    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    % set(gca, 'YTick', [-100:5:500]) % withoutdrift
    % set(gca, 'YTick', [-100:20:500]) % with drift
    set(gca, 'XTick', [0:5:T])
    legend(legend_index, legend_names, 'Location', 'north', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('Variable $g_t$ and conditional distributions', 'interpreter','latex')
    xlim([0 T])



figures_outputpath = strcat('C:\Users\k1925967\Dropbox\Apps\Overleaf\Time Series Exercises\Figures\'); 

set(gcf,'Position',[0 0 900*.7 900*.7]) % 3 x 1 plot
% set(gcf,'Position',[0 0 1000*.7 400*.7]) % 1 x 1 plot
movegui('north')
set(gcf, 'PaperPositionMode', 'auto');

% print(strcat(figures_outputpath, 'AR1_noconstant_a'), '-dpdf')  
% print(strcat(figures_outputpath, 'AR1_noconstant_b'), '-dpdf')  


