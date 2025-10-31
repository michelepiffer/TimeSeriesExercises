clc
clear
close all

k = 4;

rng(100)

%% x_3 and 4 come first:

B34 = randn(2);
Sigma34 = B34*B34';

mu34 = randn(2,1);
% mu34 = zeros(2,1);


%% x_1 and x_2 are some separate functions of x3 and x4 and only of these two

%%% x1 = b1' * (x_3; x_4) + noise;

b1           = randn(2,1);
extraSigma11 = 1;
% extraSigma11 = 0;

mu1      = b1'*mu34;
Sigma11  = b1'*Sigma34*b1 + extraSigma11;
Sigma134 = b1'*Sigma34;


%%% x2 = b2' * (x_3; x_4) + noise;

b2           = randn(2,1);
extraSigma22 = 1;
% extraSigma22 = 0;


mu2      = b2'*mu34;
Sigma22  = b2'*Sigma34*b2 + extraSigma22;
Sigma234 = b2'*Sigma34;

Sigma12 = b1'*Sigma34*b2


mu = [mu1; mu2; mu34]

Sigma = [Sigma11, Sigma12, Sigma134; ...
         Sigma12, Sigma22, Sigma234; ...
         [Sigma134', Sigma234', Sigma34]]

% will give singularity issue

rank(Sigma)

inv(Sigma)

%% Conditional distribution

Sigma11 = Sigma(1:2,1:2);
Sigma12 = Sigma(1:2,3:4);
Sigma21 = Sigma(3:4,1:2);
Sigma22 = Sigma(3:4,3:4);


% cond_values2 = mu(3:4);
cond_values2 = randn(2,1);


mu2_cond1    = mu(1:2) + Sigma12*inv(Sigma22)*(cond_values2 - mu2);
Sigma2_cond1 = Sigma11 - Sigma12*inv(Sigma22)*Sigma21;


[mu2_cond1, NaN(2,1), Sigma2_cond1]


