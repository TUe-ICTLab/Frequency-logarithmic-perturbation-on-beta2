P.GPUFlag = 1; % Set if calculations are done in GPU

% Select if transmission is in the C- or O-band
% Acceptable values: 'SMF-CBAND' and 'SMF-OBAND'
P.FiberType = 'SMF-CBAND';  

if strcmp(P.FiberType,'SMF-CBAND')
    P.alphadB       = 0.2;      % Attenuation coef [dB/Km]
    P.gamma_nl      = 1.2;      % Non-lin coef [1/(W km)]
    P.beta2         = -21.67;   % GVD coef [ps^2/km]
elseif strcmp(P.FiberType,'SMF-OBAND')
    P.alphadB       = 0.4;      % Attenuation coef [dB/Km]
    P.gamma_nl      = 1.4;      % Non-lin coef [1/(W km)]
    P.beta2         = -0.2;     % GVD coef [ps^2/km]
end

P.L             = 20;       % Span Length [km]
P.Lsplit        = 1;        % Fiber length after splitter [km]

P.alpha_lin   = P.alphadB/10*log(10);  % Attenuation [Np/m]

% Splitter split-ratio: signal power is divided by P.SplitRatio
% after splitter
P.SplitRatio  = 64; 

P.modtype  = 'qam'; % Supports QAM and PSK

P.M        = 2^2;          % M-qam, psk
P.Rs       = 10e9;         % Symbol rate [Hz]
P.Nsymb    = 2^17;         % Number of Symbols 
P.sps      = 16;           % Samples per symbol

P.NumSSFMsteps   = 70;     % Number of SSFM steps 
P.logFactor      = 0.6;    % Correction factor for log steps

% P.dz_pert_gamma is the length of the segments in which integration via 
% Gaussian quadrature will be applied.
% If P.dz_pert_gamma = P.L, only 1 segment of P.L km will be divided into 
% P.N_gauss quadrature points
P.dz_pert_gamma   = 20;  % [Km]

P.N_gauss = 2; % Number of quadrature points for Gaussian integration

P.Filt.BW    = P.Rs;  % Filter bandwidth
P.Filt.shape = 'RRC'; % Filter shape: RRC or Rect (sinc)
P.Filt.RRCrolloff = 0.1; % Roll-off for RRC shape


S.Fs       = P.Rs*P.sps;    % Sampling frequency
S.size     = P.Nsymb*P.sps; % Total number of time/freq samples
S.df       = S.Fs/(S.size); % Frequency resolution
S.ts       = 1/S.Fs;        % Time resolution
S.duration = S.size*S.ts;   % Total duration of pulse
S.t        = linspace(0,S.duration,S.size); % Time vector
S.f        = [0:ceil(S.size/2)-1,floor(-S.size/2):-1]*S.df; % Freq vector


