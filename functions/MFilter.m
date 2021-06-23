function [OutSignal] = MFilter(InSignal,FiltS,FF)
%%%%
% This function filters an input signal according to a filter structure 
% FiltS
%
% %%%% Remarks %%%%
%
% % Necessary variables
%
%   FiltS.shape -> Shape of the filter: 'RRC' (Root Raised Cosine), 
%   'Rect' (Rectangular filter) or 'Gaussian' (Gaussian Filter) 
%
%   FF -> Frequency Vector (not fftshifted, aligned with fft output)
%
%   FiltS.BW -> Bandwidth of the Filter (for Gaussian, 3dB cutoff)
%
% % % RRC
%   FiltS.RRCrolloff -> Roll-Off parameter of the Root Raised Cosine Filter
%
% %%%% INPUTS %%%%%
%
% InSignal: Input Signal -> signal (NxT1) to be filtered, where T is the
% number of time samples
%
% FiltS: Filter Structure -> Structure containing the parameters of the
% filter
%
% FF: Frequency vector -> Frequency Vector (not fftshifted, aligned with fft output)
%
% %%%% OUTPUT %%%%%
%
% OutSignal: Output Signal -> Desired filtered output signal (NxT1)
%
%%%%


% Normalization of the frequencies (better accuracy for high frequencies)
maxF     = max(abs(FF)); % Maximum frequency value
FF       = FF/maxF; % Normalize frequency vector
FiltS.BW = FiltS.BW/maxF; % Normalize filter bandwidth/cutoff frequency 

switch FiltS.shape
    case 'RRC'             

        FTSig = fft(InSignal,[],2); % Input signal in the Fourier domain     
        rolloff = FiltS.RRCrolloff; % Make a shorter variable name - RollOff of the RRCOS

        %%% Creates the RC filter
        SFreq = (1-rolloff)*FiltS.BW/2; % Beggining of rolloff frequencies
        EFreq = (1+rolloff)*FiltS.BW/2; % End of rolloff frequencies

        IndMid =  abs(FF)<= SFreq ;                       % Frequency positions where the gain is 1
        IndEdg = find( abs(FF)> SFreq & abs(FF)<=EFreq ); % Frequency positions of the rolloff

        RCFilt = zeros(1,length(FF),class(FF)); % Initialize Filter vector
        RCFilt(IndMid) = 1;                      % Attribute 1 to the center frequencies (flat gain region)

        % Construct the rolloff region in the positions IndEdg
        RCFilt(IndEdg) = 0.5*(1+cos((pi/(rolloff*FiltS.BW))... 
            *(abs(FF(IndEdg))-(1-rolloff)*FiltS.BW/2)));              
        %%%

        RRCFilt = sqrt(RCFilt);   % Takes the squareroot of the RC filter (creating the RRC)

        FOutSig = FTSig.*RRCFilt;       % Filtered signal (Fourier Domain)
        OutSignal = ifft(FOutSig,[],2); % Comes back to the time domain

    case 'Rect'       
        FTSig = fft(InSignal,[],2);     % Input signal in the Fourier domain     

        %%% Creates the Rect filter              
        IndMid =  abs(FF)<= FiltS.BW/2; % Frequency positions where the gain is 1

        RectFilt = zeros(1,length(FF)); % Initialize Filter vector
        RectFilt(IndMid) = 1;           % Attribute 1 to the center frequencies (flat gain region)                         
        %%%

        FOutSig = FTSig.*RectFilt;      % Filtered signal (Fourier Domain)
        OutSignal = ifft(FOutSig,[],2); % Comes back to the time domain              
end


end
