clc
clear
close all


% model a decreasing growth rate, then estimate the random walk, estimate a
% single mu, plot the fitted value, show that it inmposes that you are
% growing at a constant rate when actually you are not

T = 100;
T_axis = [1:1:T];

rng(100)

%%% Growth Rate of X

mu = 0.03;
sigma1 = 0.025;

% G = mu*ones(T,1);
G = mu*ones(T,1) + sigma1*randn(T,1);

mu_new = 0.01;

G(50:end) = G(50:end) - mu + mu_new;

%%% Level, X

X = NaN(T,1);
X(1) = 100;
for t = 2:T
    X(t) = (1+G(t))*X(t-1);
end

%%% Log level, x

x = log(X);
x2 = log(X(1)) + [0:1:T-1]'*log(1+mu);


%%% log difference
Delta_x = [NaN; x(2:end) - x(1:end-1)];


%%% Estimate mu

mu_hat = mean(G);

X_hat = NaN(T,1);
X_hat(1) = X(1);
for t = 2:T
    X_hat(t) = (1+mu_hat)*X_hat(t-1);
end

x2_hat = log(X_hat(1)) + [0:1:T-1]'*log(1+mu_hat);


%%% Figure

figure(1)

    subplot(2,2,1)
hold on; grid on;

index_G = plot(T_axis, G, '- b')
plot(T_axis, Delta_x, ': r')

index_mu = yline(mu, '-- b')
index_mu_new = yline(mu_new, '-- b')
index_muhat = yline(mu_hat, '.- g')

title('Growth rate', 'interpreter','latex')
xlabel('$G_t$', 'interpreter','latex')
legend([index_mu, index_G, index_muhat], '$\mu$', 'G', '$\hat{\mu}$', 'interpreter','latex')

    subplot(2,2,2)
hold on; grid on;

plot(T_axis, X)

title('Level', 'interpreter','latex')
xlabel('$X_t$', 'interpreter','latex')


    subplot(2,2,3)
hold on; grid on;

plot(T_axis, x, '- b')
plot(T_axis, x2, ': b')

plot(T_axis, x2_hat, '.- g')


title('Log of Level', 'interpreter','latex')
xlabel('$x_t$', 'interpreter','latex')
set(gcf,'Position',[0 0 1150*.7 1000*.7])
movegui('southeast')
set(gcf, 'PaperPositionMode', 'auto');
