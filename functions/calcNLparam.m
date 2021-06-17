function [nlParam] = calcNLparam(P)
%%% This function calculates the nonlinear parameter,
% i.e., 1j*gamma*dz, where dz is mapped to the fiber steps

% Assign local variable names
SSFMsteps    = P.SSFMsteps;
alpha_lin = P.alpha_lin;
gamma_nl  = P.gamma_nl;

% Determine the attenuation factor on each step
att     = exp(-alpha_lin*SSFMsteps/2);
att_tot = cumprod(att.^2);

% Calculate effective steps
EffSteps = (1-exp(-alpha_lin*SSFMsteps))/alpha_lin;

% Determine nonlinear parameter to be multiplied later by |A|^2
% The last nonlinear step is 0 for the symmetry of the CD step
nlParam = 1j*gamma_nl*[EffSteps,0].*[1,att_tot];

end

