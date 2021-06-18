
%%% Calculate the logarithmic steps for 
% hybrid SSFM
[P.SSFMsteps,P.SSFMsteps_h] = calcLogSteps(P);

%%% Calculate nonlinear multiplier used 
% in the SSFM
P.nlParam = calcNLparam(P);

%%% Load Gaussian integration weights for
% perturbation on gamma
[P.xo,P.wo] = load_gauss(P.N_gauss);

%%% Perform change of interval on quadrature weights,
% adjusting them to the fiber length
[P.xo,P.wo,P.Gsteps] = changeGaussInterval(P);

%%% Determine the functions G, G1, G2, G3 for RP/FLP on beta2,
% which is the analogous of finding the steps for SSFM or RP gamma
[P.Gvec] = calcGiBeta2(P);