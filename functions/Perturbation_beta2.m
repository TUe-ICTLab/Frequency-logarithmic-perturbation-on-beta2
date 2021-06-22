function [OutputPulseRP,OutputPulseFLP ] = Perturbation_beta2(S,P)
% This function evaluate the continuous waveform of a given Pulse for a dispersion-managed system without ASE noise
% considering a RP and LP analysis on BETA_2 with the Analytic evaluation of the
% integrals
%%% - Physicist NLSE 

% Vinicius Oliari - <v.oliari.couto.dias@tue.nl>

% Assign local variable names
InitialPulse = S.E;
FF          = S.f/1e12;
L           = P.L;
gamma_nl    = P.gamma_nl;
beta2       = P.beta2;
Gvec        = P.Gvec;

% Calculate the RP on beta2 pulse and the components A0 and A1
[PulsePropRP,A0t,A1t] = calc_beta2RP(InitialPulse,gamma_nl,beta2,L,FF,Gvec);
OutputPulseRP = PulsePropRP;

if nargout > 1
    % Calculate the FLP on beta2 pulse based on A0 and A1
    PulsePropFLP  = calc_beta2FLP(A0t,A1t,beta2);
    OutputPulseFLP = PulsePropFLP;
end

end

function [OutRP,A0t,A1t] = calc_beta2RP(InP_RP,gamma,beta2,z,FF,Gvec)

    % Calculate the function B(t,z) and sL, which is the 
    % phase rotation exp(1j*gamma*|A(t,0)|^2G(z))
    [Btz,sL] = calc_Btz(InP_RP, gamma,z,FF,Gvec);
    
    % Apply the phase rotation to A0 and A1
    A0t = InP_RP.*sL;
    A1t = Btz.*sL;
    
    % Obtain the RP solution
    OutRP = A0t+beta2*A1t;
    
end

function [OutFLP] = calc_beta2FLP(A0t,A1t,beta2)

    % Determine the frequency representation of A0 and A1
    A0F = ifft(A0t); % A0 in the frequency domain
    A1F = ifft(A1t); % A1 in the frequency domain   

    % Determine the RP solution in the frequency domain
    RPfreq = A0F+beta2*A1F;
    
    % Calculate FLP on the frequency domain
    AF = A0F.*exp(beta2*A1F./A0F);
    
    % Replace FLP by RP in samples that could have 
    % numerical inacuracies 
    c_factor = 1.1;
    correc_pos = (abs(A0F)==0) | (abs(AF)>c_factor*abs(RPfreq));    
    AF(correc_pos) = RPfreq(correc_pos); 
    
    % Get FLP back to time domain 
    OutFLP = fft(AF);

end

function [Btz,sL] = calc_Btz(InP,gamma,z,FF,Gvec)

    % Get G functions
    Gz  = Gvec(1);
    Gi  = Gvec(2);
    Gi2 = Gvec(3);
    Gi3 = Gvec(4); 

    % Calcuate angular frequency W and its square W^2
    W  = 2*pi*FF;
    W2 = W.^2;
    
    % Calculate input waveform in frequency domain
    FInP = ifft(InP);
    
    % Calculate second time derivative of input pulse
    D2A = fft(-FInP.*W2);
    
    % Calculate first time derivative of input pulse
    DA  = fft(-1i*FInP.*W);
    
    % Calculate second time derivative of |A(t,0)|^2 = A*conj(A)
    D2NA2 = 2*real(D2A.*conj(InP))+2*abs(DA).^2;
    
    % Calculate first time derivative of |A(t,0)|^2 = A*conj(A)
    DNA2  = 2*real(conj(InP).*DA);
    
    % Calculate functions M, R and P
    Mt = (1j/2)*D2A;
    Rt = (gamma/2)*InP.*D2NA2+gamma*DA.*DNA2;
    Pt = ((1i*gamma^2)/2)*InP.*(DNA2.^2);

    % Pre-calculate some functions for substituting 
    % in B(t,z) expression    
    intg  = Mt*z-Gi*Rt-Gi2*Pt;
    intZg = Mt*Gi-Rt*Gi2-Pt*Gi3;
    
    % Calculate B(t,z) and sL = exp(1j*gamma*|A(t,0)|^2G(z))
    Btz = -intg-2*1i*gamma*InP.*...
        real(conj(InP).*(Gz.*intg-intZg));
    sL = exp(+1i*gamma*(abs(InP).^2)*Gz);   
    
end