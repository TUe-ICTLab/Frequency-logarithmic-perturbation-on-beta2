function [LogSteps,LogSteps_h] = calcLogSteps(P)
% This function calculates the vector of SSFM steps
% using logarithmic spacing
% Calculation according to 
% G. Bosco et. al., "Suppression of spurious tones induced by the split-step method in fiber systems simulation," in IEEE Photonics Technology Letters, vol. 12, no. 5, pp. 489-491, May 2000, doi: 10.1109/68.841262.

% Assign local variable names
alpha_lin = P.alpha_lin;
logFactor = P.logFactor;
Nsteps    = P.NumSSFMsteps;
L         = P.L;

% if logFactor~=0, apply log steps
% if logFactor==0, apply equally spaced steps
if logFactor ~= 0
    % Correct alpha for better log distribution
    alpha_adj = logFactor*alpha_lin; 
    delta = (1-exp(-alpha_adj*L))/Nsteps;

    % Determine log steps
    sInd = 0:Nsteps-1;
    LogSteps = -(1/(alpha_adj))*log((1-(sInd+1)*delta)./(1-(sInd)*delta));
else
    LogSteps = ones(1,Nsteps)*L/Nsteps;
end

% Generate symmetric steps using the log ones
Nsteps = Nsteps+1; % 1 more step for symmetry
LogSteps_h = zeros(1,Nsteps,class(LogSteps));

% Calculate the symmetric steps
LogSteps_h(1)  = LogSteps(1)/2;
LogSteps_h(end) = LogSteps(end)/2;
for k = 2:Nsteps-1
    LogSteps_h(k) = (LogSteps(k-1)+LogSteps(k))/2;
end

end

