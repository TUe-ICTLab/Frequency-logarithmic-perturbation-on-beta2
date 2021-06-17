
%%% Calculate the logarithmic steps for 
% hybrid SSFM
[P.SSFMsteps,P.SSFMsteps_h] = calcLogSteps(P);

%%% Calculate nonlinear multiplier used 
% in the SSFM
P.nlParam = calcNLparam(P);

%%% Load normalized Gauss-Legendre integration weights for
% perturbation on gamma
[P.xo,P.wo] = load_gauss(P.N_gauss);

%%% Perform change of interval on quadrature weights,
% adjusting them to the fiber length
[P.xo,P.wo] = changeGaussInterval(P);