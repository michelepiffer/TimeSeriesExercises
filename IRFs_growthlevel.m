clc
clear
close all


% Add cumulative of the growth rates


%% Preliminary steps

addpath('functions')

grey    = [0.9 0.9, 0.9];
grey2   = [0.65, 0.65, 0.65];
red     = [0.6, 0.1, 0.2];
red2    = [0.6, 0.025, 0.1];
blue    = [0.25, 0.3, 0.8];
blue2   = [0.25, 0.6, 0.8];
blue3   = [0.25, 0.7, 0.8];
yellow  = [1, 0.8276, 0];
purple  = [0.4940, 0.1840, 0.5560];
orange  = [0.9290, 0.6940, 0.1250]; % more yellow
orange2 = [240 100 10]/256;
black   = [0 0 0];

fig_size1 = [0 0 900*.7 480*.7]; % 2x2 plot
fig_size2 = [0 0 950*.7 280*.7]; % 1x2 plot
fig_size3 = [0 0 1350*.7 880*.7]; % 
fig_size4 = [0 0 1150*.7 420*.7]; % 1x3, works well for both paper and presentation

figures_outputpath = strcat('C:\Users\k1925967\Dropbox\Apps\Overleaf\BOE_ Structural and forecasting\FiguresTables\FiguresTables5_firstdraft\'); 

nfig = 0;


T_irf = 15;


%% CASE 1: IRF expressed in level

%%% Level

param_a  = 1;

param_b  = 0;
param_hl = 3;
param_pf = NaN;
Option_c = 'control_half_life';

% param_b  = 3;
% param_hl = NaN;
% param_pf = 2;
% Option_c = 'control_peak_effect';

param_c = fun_param_c(param_a, param_b, param_hl, param_pf, Option_c);


Case1_IRF_level = squeeze(fun_Psi_bar(T_irf, param_a, param_b, param_c));


%%% Compute corresponding growth rate

starting_value = 1 % without the shock the variable of interest would stay at this value

temp = [starting_value; starting_value + Case1_IRF_level];

Case1_IRF_growthrate = NaN(T_irf+1,1);
for h = 1:T_irf+1
    Case1_IRF_growthrate(h) = 100*(temp(h+1)-temp(h))/temp(h);
end


%% CASE 2: IRF expressed in growth rate

%%% Level

param_a  = 100;

param_b  = 0;
param_hl = 3;
param_pf = NaN;
Option_c = 'control_half_life';


% param_b  = 3;
% param_hl = NaN;
% param_pf = 2;
% Option_c = 'control_peak_effect';


param_c = fun_param_c(param_a, param_b, param_hl, param_pf, Option_c);


Case2_IRF_growthrate = squeeze(fun_Psi_bar(T_irf, param_a, param_b, param_c));


%%% Compute corresponding growth rate

starting_value = 1 % without the shock the variable of interest would stay at this value

Case2_IRF_level = NaN(T_irf+1,1);
Case2_IRF_level(1) = starting_value*(1 + Case2_IRF_growthrate(1)/100);
for h = 2:T_irf+1
    Case2_IRF_level(h) = Case2_IRF_level(h-1)*(1 + Case2_IRF_growthrate(h)/100);
end


%% Figures

T_irf_axis = [0:1:T_irf];


%%% Plot the IRFs in a 1x2 plot
nfig       = nfig + 1; 
fig_handle = figure(nfig); 
fig_handle.Name = 'Impulse responses';


    %%% Case 1 

    subplot(2,2,1)
    grid on; hold on
            
        yline(0, 'k'); 
        index = plot(T_irf_axis, Case1_IRF_level, '.-', 'Color', orange2, 'Linewidth', 1.5, 'Markersize', 15); 
    
        xlim([T_irf_axis(1) T_irf_axis(end)])
        set(gca, 'YTick', [-2:0.25:5]) 
        set(gca, 'XTick', [0:1:T_irf+1])     
        set(gca,'box','off')
        ylabel('Level', 'Interpreter','latex')
        xtickangle(0)

        title('Case 1: Level to growth rate', 'Interpreter','latex')
        

    subplot(2,2,3)
    grid on; hold on
            
        yline(0, 'k'); 
        index = plot(T_irf_axis, Case1_IRF_growthrate, '.-', 'Color', orange2, 'Linewidth', 1.5, 'Markersize', 15); 
    
        xlim([T_irf_axis(1) T_irf_axis(end)])
        set(gca, 'YTick', [-200:20:200]) 
        set(gca, 'XTick', [0:1:T_irf+1])     
        set(gca,'box','off')
        ylabel('Growth rate (percent)', 'Interpreter','latex')
        xtickangle(0)


    %%% Case 2 

    subplot(2,2,2)
    grid on; hold on
            
        yline(0, 'k'); 
        index = plot(T_irf_axis, Case2_IRF_level, '.-', 'Color', blue2, 'Linewidth', 1.5, 'Markersize', 15); 
    
        xlim([T_irf_axis(1) T_irf_axis(end)])
        % set(gca, 'YTick', [-20:20:3000]) 
        set(gca, 'YTick', [-200:200:3000]) 
        set(gca, 'XTick', [0:1:T_irf+1])     
        set(gca,'box','off')
        ylabel('Level', 'Interpreter','latex')
        xtickangle(0)

        title('Case 2: Growth rate to level', 'Interpreter','latex')
        


    %%% Case 2 - Growth rate

    subplot(2,2,4)
    grid on; hold on
            
        yline(0, 'k'); 
        index = plot(T_irf_axis, Case2_IRF_growthrate, '.-', 'Color', blue2, 'Linewidth', 1.5, 'Markersize', 15); 
    
        xlim([T_irf_axis(1) T_irf_axis(end)])
        set(gca, 'YTick', [-200:20:200]) 
        set(gca, 'XTick', [0:1:T_irf+1])     
        set(gca,'box','off')
        ylabel('Growth rate (percent)', 'Interpreter','latex')
        xtickangle(0)


set(gcf,'Position', fig_size1) 

movegui('northeast')
set(gcf, 'PaperPositionMode', 'auto');


% print(strcat(figures_outputpath, 'IRFs_growthlevel'), '-dpdf')  

