
% Generates random symbol indices
data = randi(P.M,1,P.Nsymb)-1;

% Generate symbols given the symbol indices
% The set of symbols has unit average power
switch P.modtype
    case 'qam'
        symb = qammod(data,P.M,'UnitAveragePower',1);
    case 'psk'
        symb = pskmod(data,P.M);           
end

% Pass symbs to GPU
if P.GPUFlag
    symb = gpuArray(symb);
    S.f  = gpuArray(S.f);
end

% Generate pulse of symbol samples
delta    = zeros(1,P.sps,class(symb));
delta(1) = 1;               % Identity sample
E_samp   = kron(symb,delta);  % Pulse of symbol samples

% Pulse shape the signal (apply a filter to E_samp)
S.E = MFilter(E_samp,P.Filt,S.f);

% Adjust transmitted power
P_samp  = 20*log10(1/P.sps)+30; % Current power of S.E
pgain   = 10^((P.power_dBm-P_samp)/20); % Necessary correction gain
S.E     = pgain*S.E;  
