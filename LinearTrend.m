clc
clear
close all


%% Main parameters

mu = 1;
% mu = 0;

sigma = 1;

T = 80;
T_axis = [0:1:T];


N = 10;

%% Generate data

%%% Shocks
rng(100)
u_all = sigma*randn(T,N);
u_all(5,:) = -4;
u_all(6,:) = -4;
u_all(30,:) = 5;
u_all(31,:) = 5;


%%% Variables via the linear trend model
z0 = 5;

z_all      = NaN(T,N);


noshocks_all = NaN(T,N);

%%% A model with an AR component instead of a linear trend model
f_all      = NaN(T,N);
p = 4;

%%% First difference 
firstdif_all = NaN(T,N);

%%% Computations

for n = 1:N

    for t = 1:T    
    
        %%% Via the linear trend model
        z_all(t,n) = z0 + t*mu + u_all(t,n);

        noshocks_all(t,n) = z0 + t*mu;

        if t == 1
            firstdif_all(t,n) = z_all(t,n) - z0;

        else
            firstdif_all(t,n) = z_all(t,n) - z_all(t-1,n);

        end

        %%% Via the alternative equation
        if t > p
            f_all(t,n) = z0 + t*mu + sum(u_all(t-p:t,n));
        end


    end
end

u_all        = [NaN(1,N);  u_all];
z_all        = [z0*ones(1,N);  z_all];
firstdif_all = [NaN(1,N);  firstdif_all];
f_all        = [NaN(1,N);  f_all];


%% Figures

orange = [0.9290, 0.6940, 0.1250];
orange2 = [240 100 10]/256;
purple = [0.4940, 0.1840, 0.5560];
purple2 = [0.5140, 0.2040, 0.6060];

n = 1;

figure(n)

subplot(3,1,1)
% subplot(1,2,1)
hold on; grid on;

    yline(0, ': r')

    % for n = 1:N
        index = plot(T_axis, u_all(:,n), 'Linewidth', 1);
    % end
    % legend_index = [legend_index, index];
    % legend_names = [legend_names; cellstr('$X_t$: level')];

    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    set(gca, 'XTick', [0:5:T])
    % legend(legend_index, legend_names, 'Location', 'Best', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('Shocks $u_t$', 'interpreter','latex')
    xlim([0 T])


subplot(3,1,2)
% subplot(1,2,2)
hold on; grid on;

    %%% Empty arrays needed for the legend
    legend_index = [];
    legend_names = [];

    for t = 1:T
        temp = sqrt(sigma^2); % standard deviation
        index = line([t t], [noshocks_all(t,n)-2*temp  noshocks_all(t,n)+2*temp], 'Color', orange, 'LineWidth', 2);
    end
    legend_index = [legend_index, index(end)];
    legend_names = [legend_names; cellstr('2 standard deviations of $z_t | z_0$')];

    % for n = 1:N
        index = plot(T_axis, z_all(:,n), '. r', 'Linewidth', 2);
    % end
    legend_index = [legend_index, index];
    % legend_names = [legend_names; cellstr('$z_t = \mu + z_{t-1} + u_t$')];
    legend_names = [legend_names; cellstr('$z_t = z_{t-1} + u_t$')];

    % index = plot(T_axis, f_all(:,n), '-- b', 'Linewidth', 1);

    index = plot(T_axis(2:end), noshocks_all(:,n), '-- k', 'Linewidth', 1);
    legend_index = [legend_index, index];
    % legend_names = [legend_names; cellstr('$l_t = z_0 + t \cdot \mu$')];
    legend_names = [legend_names; cellstr('$l_t = z_0 $')];




    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    % set(gca, 'YTick', [-100:5:500]) % withoutdrift
    % set(gca, 'YTick', [-100:20:500]) % with drift
    set(gca, 'XTick', [0:5:T])
    legend(legend_index, legend_names, 'Location', 'Best', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('Variable $z_t$', 'interpreter','latex')
    xlim([0 T])


subplot(3,1,3)
hold on; grid on;

    %%% Empty arrays needed for the legend
    legend_index = [];
    legend_names = [];

    yline(0, ': r')

    index = yline(mu, '-- k');
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$\mu$')];

    % for n = 1:N
        index = plot(T_axis, firstdif_all(:,n), 'Linewidth', 1);
    % end
    % legend_index = [legend_index, index];
    % legend_names = [legend_names; cellstr('$X_t$: level')];

    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    set(gca, 'XTick', [0:5:T])
    legend(legend_index, legend_names, 'Location', 'Best', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('First difference $\Delta_t = z_t - z_{t-1}$', 'interpreter','latex')
    xlim([0 T])


figures_outputpath = strcat('C:\Users\k1925967\Dropbox\Apps\Overleaf\Time Series Exercises\Figures\'); 

set(gcf,'Position',[0 0 900*.7 900*.7]) % 3 x 1 plot
% set(gcf,'Position',[0 0 1000*.7 400*.7]) % 1 x 1 plot
movegui('north')
set(gcf, 'PaperPositionMode', 'auto');

% print(strcat(figures_outputpath, 'LinearTrend_withdrift'), '-dpdf')  
% print(strcat(figures_outputpath, 'LinearTrend_withoutdrift'), '-dpdf')  

