clc
clear
close all




% model a decreasing growth rate, then estimate the random walk, estimate a
% single mu, plot the fitted value, show that it inmposes that you are
% growing at a constant rate when actually you are not


%% Preliminary steps

nfig = 0;

rng(100)

T = 100;
T_axis = [1:1:T];


%% Growth Rate of X

mu = 0.03;
% mu = unifrnd(-0.1,0.5)

%%% Constant growth rate
% G = mu*ones(T,1);

%%% Random growth rate
sigma1 = 0.025;
G = mu*ones(T,1) + sigma1*randn(T,1);
% G(30) = -0.1;
% G(31) = -0.1;

%%% Random walk without drift
% G = NaN(T,1);
% G = mu;
% sigma1 = 0.01;
% temp = sigma1*randn(T,1);
% for t = 2:T
%     G(t) = G(t-1) + temp(t);
%     % G(t) = mu + G(t-1) + temp(t);
% end


% G(50:end) = G(50:end) + 1.5*mu;


%% Level, X

X = NaN(T,1);
X(1) = 100;
for t = 2:T
    X(t) = (1+G(t))*X(t-1);
end


%% Log level, x

x = log(X);


%% Alternative process

z = x(1) + [0:1:T-1]'*log(1+mu);


%% log difference

Delta_x = [NaN; x(2:end) - x(1:end-1)];


%% Estimate mu

mu_hat = mean(G);

X_hat = NaN(T,1);
X_hat(1) = X(1);
for t = 2:T
    X_hat(t) = (1+mu_hat)*X_hat(t-1);
end

x2_hat = log(X_hat(1)) + [0:1:T-1]'*log(1+mu_hat);


%% Figure

%%% Specify empty entries for the legend


nfig = nfig + 1;

figure(nfig)


subplot(1,3,1)
hold on; grid on;
    
    %%% Empty arrays needed for the legend
    legend_index = [];
    legend_names = [];

    %%% Plot
    index = plot(T_axis, X, 'Linewidth', 2);
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$X_t$: level')];
         
    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    set(gca, 'XTick', [0:10:T])
    % set(gca, 'YTick', [-100:200:2*max(X)])
    legend(legend_index, legend_names, 'Location', 'Best', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('Level', 'interpreter','latex')
    xlim([1 T])


subplot(1,3,2)
hold on; grid on;
    
    %%% Empty arrays needed for the legend
    legend_index = [];
    legend_names = [];

    %%% Plot
    index = plot(T_axis, x, 'o b', 'Linewidth', 2);
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$x_t$: log of level')];

    index = plot(T_axis, z, '. r', 'Linewidth', 2);
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$z_t$: alternative process')];    
             
    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    set(gca, 'XTick', [0:10:T])
    legend(legend_index, legend_names, 'Location', 'Best', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    title('Log of level', 'interpreter','latex')
    xlim([1 T])


subplot(1,3,3)
hold on; grid on;
    
    %%% Empty arrays needed for the legend
    legend_index = [];
    legend_names = [];

    %%% Plot
    index = yline(mu, 'o b', 'Linewidth', 1); 
    legend_index = [legend_index, index];
    % legend_names = [legend_names; cellstr('$\mu_t$: true growth rate')];
    legend_names = [legend_names; cellstr('$\mu_t$: average growth rate')];
    
    index = plot(T_axis, G, 'o b', 'Linewidth', 1);
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$G_t$: true growth rate')];
         
    index = plot(T_axis, Delta_x, '. r', 'Linewidth', 2);
    legend_index = [legend_index, index];
    legend_names = [legend_names; cellstr('$\Delta x_t$: log difference')];
         

    %%% Additional items for the figure    
    xlabel('time', 'interpreter','latex')
    set(gca, 'XTick', [0:10:T])
    legend(legend_index, legend_names, 'Location', 'Best', 'Interpreter', 'latex', 'AutoUpdate', 'off'); % legend('boxoff') 
    ylim([min(G)-0.2, max(G)+0.1])
    title('Growth rate', 'interpreter','latex')
    xlim([1 T])



set(gcf,'Position',[0 0 1050*.7 300*.7])
movegui('north')
set(gcf, 'PaperPositionMode', 'auto');

figures_outputpath = strcat('C:\Users\k1925967\Dropbox\Apps\Overleaf\Time Series Exercises\Figures\'); 


% print(strcat(figures_outputpath, 'GrowthRates_a'), '-dpdf')  
% print(strcat(figures_outputpath, 'GrowthRates_b'), '-dpdf')  
% print(strcat(figures_outputpath, 'GrowthRates_c'), '-dpdf')  


