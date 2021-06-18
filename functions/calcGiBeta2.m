function [Gvec] = calcGiBeta2(P)
%%% This function calculates G, G1, G2, and G3 
% for the RP/FLP on beta2. These are the functions analogous
% to the fiber steps in the SSFM or RP/ERP/LP on gamma
% Gz  -> G(z)
% Gi  -> G_1(z)
% Gi2 -> G_2(z)
% Gi3 -> G_3(z)

% Assign local variables
z       = P.L;
alpha_lin   = P.alpha_lin;

% Calculate functions G, G1, G2, and G3
if alpha_lin ~= 0
    Gz  = (1-exp(-alpha_lin*z))/alpha_lin;
    Gi  = (alpha_lin*z+exp(-alpha_lin*z)-1)/(alpha_lin^2);
    Gi2 = (2*alpha_lin*z+4*exp(-alpha_lin*z)-exp(-2*alpha_lin*z)-3)/(2*alpha_lin^3);
    Gi3 = (6*alpha_lin*z+18*exp(-alpha_lin*z)...
        -9*exp(-2*alpha_lin*z)+2*exp(-3*alpha_lin*z)-11)/(6*alpha_lin^4);
else
    % If in the loss-less case, the expressions are simpler
    Gz  = z;
    Gi  = (z^2)/2;
    Gi2 = (z^3)/3;
    Gi3 = (z^4)/4;
end

% Gather everything together in a vector for easier(?) manipulation
Gvec = [Gz,Gi,Gi2,Gi3];

end

