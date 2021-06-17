clear 
close all

% Add function's folder to the path
addpath('./functions')

% Vector with the input powers to be simulated
InputPowerVector = 0:20; 

% Initialize the NSD vectors
nsdb2       = zeros(size(InputPowerVector));
nsdflpb2    = zeros(size(InputPowerVector));
nsdgamma    = zeros(size(InputPowerVector));
nsderpgamma = zeros(size(InputPowerVector));
nsdlpgamma  = zeros(size(InputPowerVector));
nsdssfm1    = zeros(size(InputPowerVector));
nsdssfm2    = zeros(size(InputPowerVector));
nsdssfm3    = zeros(size(InputPowerVector));


for pp = 1:length(InputPowerVector)
    
    % Determine current input power
    P.power_dBm = InputPowerVector(pp);

    %    Load system parameters
    parameters;
    
    % Calculate SSFM steps and load Gauss-Legendre quadrature
    SSFMstepsCalculation;
    
    % Generate the transmitted signal 
    Make_TX_Signal;

    % If P.GPUFlag==1, load variables to the GPU
    if P.GPUFlag
        [S,P] = VarToGPU(S,P);
    end

    % Obtain model outputs given the input S.E
    [RPb2,FLPb2] = Perturbation_beta2(S,P);
    [RPgamma,ERPgamma,LPgamma] = Perturbation_gamma(S,P);
    
    % Obtain SSFM output given the input S.E
    [SSFMsignal] = SSFM(S,P);
    
    % Calculate the attenuation given by 
    % fiber attenuation and splitter
    AttAndSplitGain = exp(-P.alpha_lin*P.L/2)*sqrt(1/P.SplitRatio);
    
    % Apply attenuation to model outputs and SSFM output
    RPb2        = RPb2*AttAndSplitGain;
    FLPb2       = FLPb2*AttAndSplitGain;
    RPgamma     = RPgamma*AttAndSplitGain;
    LPgamma     = LPgamma*AttAndSplitGain;
    ERPgamma    = ERPgamma*AttAndSplitGain;
    SSFMsignal  = SSFMsignal*AttAndSplitGain;
    
    % Attribute the new fiber length after splitter
    P.L = P.Lsplit;    
    
    % Calculate new steps for SSFM give the new fiber length
    % P.Lsplit
    SSFMstepsCalculation;
    
    % Propagate each model in the last fiber segment after splitter
    
    % Define new input signal as the previous model output
    S.E = SSFMsignal;
    % Propagate in the last fiber segment
    [SSFMsignal] = SSFM(S,P);
    
    % Same for the models below
    S.E = RPb2;
    [RPb2,~] = Perturbation_beta2(S,P);
    S.E = FLPb2;
    [~,FLPb2] = Perturbation_beta2(S,P);
    S.E = RPgamma;
    [RPgamma,~,~] = Perturbation_gamma(S,P);
    S.E = ERPgamma;
    [~,ERPgamma,~] = Perturbation_gamma(S,P);
    S.E = LPgamma;
    [~,~,LPgamma] = Perturbation_gamma(S,P);
    
    
    % Calculate the NSD at the given input power for each model
    nsdb2(pp)       = nsd_calc(SSFMsignal,RPb2);
    nsdflpb2(pp)    = nsd_calc(SSFMsignal,FLPb2);
    nsdgamma(pp)    = nsd_calc(SSFMsignal,RPgamma);
    nsderpgamma(pp) = nsd_calc(SSFMsignal,ERPgamma);
    nsdlpgamma(pp)  = nsd_calc(SSFMsignal,LPgamma);

    
end


% Plot NSD curves
plot(InputPowerVector,nsdb2)
hold all
plot(InputPowerVector,nsdflpb2)
plot(InputPowerVector,nsdgamma)
plot(InputPowerVector,nsderpgamma)
plot(InputPowerVector,nsdlpgamma)
set(gca, 'YScale', 'log')
grid on

title('NSD vs. Input Power for Perturbation Models')
legend('RP on \beta_2','FLP on \beta_2',...
    'RP on \gamma','ERP on \gamma','LP on \gamma')
xlabel('Input power [dBm]')
ylabel('NSD (%)')


