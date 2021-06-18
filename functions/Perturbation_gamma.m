function [OutputPulseRP,OutputPulseERP,OutputPulseLP] = Perturbation_gamma(S,P)
% This function evaluate the continuous waveform of a given Pulse for a system without ASE noise
% considering RP/ERP/LP analysis on GAMMA
% 
% Input Waveform: S.E
%
%%% - Physicist NLSE 


% Change variables to a local name
InitialPulse = S.E;
L           = P.L;
FF          = S.f/1e12;
gamma_nl    = P.gamma_nl;
beta2       = P.beta2;
xo          = P.xo;
wo          = P.wo;
alpha_lin   = P.alpha_lin;
N_steps     = P.Gsteps;

% Initialize A1 term
PulseA1zt   = 0*InitialPulse;

% Determine P0 for ERP calculation
P0 = mean(abs(InitialPulse).^2); 
Leff = (1-exp(-alpha_lin*L))/alpha_lin;

% Input waveform in frequency domain
IniPulseFreq = ifft(InitialPulse,[],2);

% Pre-calculation for the chromatic dispersion operator
w2beta2 = +1i/2*beta2*(2*pi*(FF)).^2;

for kk = 1:N_steps
    
    % Get quadrature weights and positions 
    % relative to the kk-th step
    woW = wo(:,kk);
    xoW = xo(:,kk);
    z = xoW; % Fiber length positions for integration
    
    % Dispersion operators
    Hzf             = exp(+w2beta2.*z); % To obtain A0 at z (operator Dz)
    HLzf            = exp(+w2beta2.*(L-z)); % To apply to A0|A0|^2 (operator D_{L-z})
    
    % Obtain A0 at positions z
    PulseA0zt_M     = fft(Hzf.*IniPulseFreq,[],2);
    
    % Obtain A0|A0|^2
    AAAconj         = PulseA0zt_M.*abs(PulseA0zt_M).^2;
    
    % Apply operator D_{L-z} in A0|A0|^2
    ULzAAAconj      = fft(ifft(AAAconj,[],2).*HLzf,[],2);
    
    % Add attenuation and nonlinear coeff.
    PulseA1zt_I     = 1i*gamma_nl*ULzAAAconj.*exp(-alpha_lin*z);
    
    % Integrate with quadrature weights
    PulseA1zt = PulseA1zt+sum(PulseA1zt_I.*woW);
    
end

% Obtain A0
PulseA0zt   = fft(IniPulseFreq.*exp(+w2beta2*L),[],2);

% Obtain RP output: A0+gamma*A1 (gamma already included in PulseA1zt)
OutputPulseRP    = PulseA0zt+PulseA1zt;

if nargout > 1
    % Obtain enhanced ERP from A0 and A1
    OutputPulseERP = (PulseA0zt*(1-1i*P0*gamma_nl*Leff)+PulseA1zt).*exp(+1i*gamma_nl*P0*Leff);
end

if nargout > 2 
    % Obtain LP on gamma
    OutputPulseLP   = PulseA0zt.*exp(PulseA1zt./PulseA0zt);
    
    % Determine the LP samples that might have numerical issues
    % and replace them by RP ones
    % We choose to replace whenever |A_LP| > c*|A_RP|
    c_factor = 1.1;
    correc_pos = abs(OutputPulseLP)>c_factor*(abs(OutputPulseRP));
    OutputPulseLP(correc_pos) = OutputPulseRP(correc_pos);
end


end
