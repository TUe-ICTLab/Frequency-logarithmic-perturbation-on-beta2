function [S,P] = VarToGPU(S,P)
%%% This function allocates some parameters from the objects
% S and P into the GPU 

S.E = gpuArray(S.E);
P.SSFMsteps     = gpuArray(P.SSFMsteps);
P.SSFMsteps_h     = gpuArray(P.SSFMsteps_h);
P.nlParam       = gpuArray(P.nlParam);
P.dz_pert_gamma = gpuArray(P.dz_pert_gamma);
S.f           = gpuArray(S.f);
P.L           = gpuArray(P.L);

P.alpha_lin   = gpuArray(P.alpha_lin);
P.gamma_nl    = gpuArray(P.gamma_nl);
P.beta2       = gpuArray(P.beta2);

P.xo          = gpuArray(P.xo);
P.wo          = gpuArray(P.wo);
P.N_gauss     = gpuArray(P.N_gauss);

end

