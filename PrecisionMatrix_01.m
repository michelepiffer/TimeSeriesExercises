clc
clear
close all

k = 4;

rng(100)

B = randn(k);
Sigma = B*B';

mu = randn(k,1);
% mu = zeros(k,1);


%% Joint pdf of all 4 random variables

[mu, NaN(k,1), Sigma]


mu1 = mu(1:2);
mu2 = mu(3:4);


%% Play around with covariance matrix


P = inv(Sigma);
disp('-- Pre adjustment --')

% Sigma
P

% P(2,1) = 0; P(1,2) = 0;
% P(3,1) = 0; P(1,3) = 0;

Sigma(2,1) = 0; Sigma(1,2) = 0;

disp('-- Post adjustment --')
Sigma
% Sigma = inv(P)
P = inv(Sigma)

Sigma11 = Sigma(1:2,1:2);
Sigma12 = Sigma(1:2,3:4);
Sigma21 = Sigma(3:4,1:2);
Sigma22 = Sigma(3:4,3:4);


%% Marginal pdf of first two random variables

[mu1, NaN(2,1), Sigma11]



%% Conditional posterior of entries 1,2 given entry 3,4

% cond_values2 = mu(3:4);
cond_values2 = randn(2,1);


mu2_cond1    = mu(1:2) + Sigma12*inv(Sigma22)*(cond_values2 - mu2);
Sigma2_cond1 = Sigma11 - Sigma12*inv(Sigma22)*Sigma21;


[mu2_cond1, NaN(2,1), Sigma2_cond1]


