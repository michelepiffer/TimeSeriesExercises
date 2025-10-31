clc
clear
close all


%% Main parameters

% mu = 1;
mu = 0;

sigma = 1;

T = 80;
T_axis = [0:1:T];


N = 4;

%% Generate data

%%% Shocks
u_all = sigma*randn(T,N);
u_all(5,:) = -4;
u_all(6,:) = -4;
u_all(30,:) = 5;
u_all(31,:) = 5;


%%% Variables via the random walk equation
z0 = 5;
z_all      = NaN(T,N);
z_all(1,:) = z0;

noshocks_all = NaN(T,N);

%%% Variables via the alternative equation
f_all      = NaN(T,N);



for n = 1:N

    for t = 1:T    
    
        %%% Via the random walk equation
        if t == 1
            z_all(t,n) =  mu + z0 + u_all(t,n);
        else
            z_all(t,n) =  mu + z_all(t-1,n) + u_all(t,n);
        end

        %%% Via the alternative equation
        f_all(t,n) = z0 + t*mu + sum(u_all(1:t,n));

        noshocks_all(t,n) = z0 + t*mu;

    end
end

u_all = [NaN(1,N);  u_all];
z_all = [z0*ones(1,N);  z_all];


%% Figures

orange = [0.9290, 0.6940, 0.1250];
orange2 = [240 100 10]/256;
purple = [0.4940, 0.1840, 0.5560];
purple2 = [0.5140, 0.2040, 0.6060];

n = 1;

figure(n)

subplot(2,1,1)
hold on; grid on;

    yline(0, ': r')

    index = plot(T_axis, u_all(:,n), 'Linewidth', 1);
    % legend_index = [legend_index, index];
    % legend_names = [legend_names; cellstr('$X_t$: level')];

    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    set(gca, 'XTick', [0:5:T])
    % legend(legend_index, legend_names, 'Location', 'Best', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('Shocks $u_t$', 'interpreter','latex')
    xlim([0 T])

subplot(2,1,2)
hold on; grid on;

    %%% Empty arrays needed for the legend
    legend_index = [];
    legend_names = [];


    for t = 1:T
        temp = sqrt(t*sigma^2); % standard deviation
        index = line([t t], [noshocks_all(t,n)-2*temp  noshocks_all(t,n)+2*temp], 'Color', orange, 'LineWidth', 2);
    end
    legend_index = [legend_index, index(end)];
    legend_names = [legend_names; cellstr('2 standard deviations of $z_t | z_0$')];

    index = plot(T_axis, z_all(:,n), 'o b', 'Linewidth', 1);
    legend_index = [legend_index, index];
    % legend_names = [legend_names; cellstr('$z_t = \mu + z_{t-1} + u_t$')];
    legend_names = [legend_names; cellstr('$z_t =  z_{t-1} + u_t$')];


    index = plot(T_axis(2:end), f_all(:,n), '. r', 'Linewidth', 2);
    legend_index = [legend_index, index];
    % legend_names = [legend_names; cellstr('$f_t = z_0 + t \cdot \mu + sum(u_{1:t})$')];
    legend_names = [legend_names; cellstr('$f_t = z_0 + sum(u_{1:t})$')];


    index = plot(T_axis(2:end), noshocks_all(:,n), '-- k', 'Linewidth', 1);
    legend_index = [legend_index, index];
    % legend_names = [legend_names; cellstr('$l_t = z_0 + t \cdot \mu$')];
    legend_names = [legend_names; cellstr('$l_t = z_0 $')];




    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    set(gca, 'YTick', [-100:5:500])
    % set(gca, 'YTick', [-100:20:500])
    set(gca, 'XTick', [0:5:T])
    legend(legend_index, legend_names, 'Location', 'Best', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('Variable $y_t$', 'interpreter','latex')
    xlim([0 T])


figures_outputpath = strcat('C:\Users\k1925967\Dropbox\Apps\Overleaf\Time Series Exercises\Figures\'); 

set(gcf,'Position',[0 0 900*.7 600*.7])
movegui('north')
set(gcf, 'PaperPositionMode', 'auto');

% print(strcat(figures_outputpath, 'RandomWalk_withdrift'), '-dpdf')  
% print(strcat(figures_outputpath, 'RandomWalk_withoutdrift'), '-dpdf')  

