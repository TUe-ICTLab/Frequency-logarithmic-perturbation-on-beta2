function [S,P] = VarToCPU(S,P)
%VARTOCPU Summary of this function goes here
%   Detailed explanation goes here

S.E = double(gather(S.E));

P.SSFMsteps     = double(gather(P.SSFMsteps));
P.SSFMsteps_h     = double(gather(P.SSFMsteps_h));
P.nlParam       = double(gather(P.nlParam));
P.dz_pert_gamma = double(gather(P.dz_pert_gamma));
S.f           = double(gather(S.f));
P.L           = double(gather(P.L));

P.alpha_lin   = double(gather(P.alpha_lin));
P.gamma_nl    = double(gather(P.gamma_nl));
P.beta2       = double(gather(P.beta2));

P.xo          = double(gather(P.xo));
P.wo          = double(gather(P.wo));
P.N_gauss     = double(gather(P.N_gauss));

end


