function [nsd] = nsd_calc(wave_ref,wave2)
% This function calculates the NSD between
% 'wave_ref' and 'wave2', assuming 'wave_ref'
% as the reference waveform

% Calculates the error's energy
err  = mean(abs(wave_ref-wave2).^2);

% Calculates the reference wave's energy
pRef = mean(abs(wave_ref).^2);

% Compute the NSD in percentage (%)
nsd = double(gather(100*(err/pRef)));

end
