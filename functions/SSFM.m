function [OutputSSFM] = SSFM(S,P)
% This function applies the symmetric SSFM 
% to the input signal S.E

% Assign local variable names
InitialPulse = S.E;
FF       = S.f/1e12;  % signal frequency in THz
beta2    = P.beta2;
LogSteps = P.SSFMsteps_h;
nlParam  = P.nlParam;
nstep = P.NumSSFMsteps+1;

% Pre-calculation for the dispersion operator
d2    = +1i*0.5*beta2*((2*pi*FF).^2);

% Input waveform
sig = InitialPulse;

for ii = 1:nstep
    % Apply chromatic dispersion in the frequence domain
    SIG = ifft(sig,[],2);
    SIG = SIG.*exp(d2*LogSteps(ii));
    sig = fft(SIG,[],2);
    
    % Apply nonlinear effect
    sig = sig.*exp(nlParam(ii)*abs(sig).^2);
end

% Output waveform
OutputSSFM = sig;

end

