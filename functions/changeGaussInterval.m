function [xoV,woV,N_steps] = changeGaussInterval(P)
%%%% This function adjusts the normalized quadrature weights 
%%%% to the fiber length intervals

% Assign local variable names
dz          = P.dz_pert_gamma;
L           = P.L;
xo          = P.xo;
wo          = P.wo;

% Determine the length of the steps
% Obs.: if dz >= L, there will be 1 step
% to be divided in P.N_gauss quadrature points
Lv = 0:dz:L;
if Lv(end)<L
    Lv = [Lv L];
end

% Calculate the weights and z positions according to
% https://en.wikipedia.org/wiki/Gaussian_quadrature
% in "Change of interval"
bma_vec = diff(Lv)/2;
bpa_vec = bma_vec+Lv(1:end-1);
woV = (bma_vec.')*wo;
xoV = (bma_vec.')*xo+(bpa_vec.');

% Transpose vectors to match integration dimensions
% on the perturbation on gamma function
xoV = xoV.';
woV = woV.';

% Number of steps in which the 
% quadrature will be applied
N_steps = ceil(L/dz);

end

