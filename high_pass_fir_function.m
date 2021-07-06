% TITLE: HIGH PASS FIR FILTER
% AUTHOR: ÁNGELA VALES : https://github.com/AnVales
% DATE: 21/05/2021

% Filter the noise with high pass fir filter

function [output_d] = high_pass_fir_function(input_t,input_frecuency)

Fs=1/input_t(2); % Sampling frequency

% Cutoff frequency - should be above the freq. of the oscilation experiment

if input_frecuency == 2
    Fc = 1;
elseif input_frecuency < 7
    Fc = 2;
elseif input_frecuency > 7
    Fc=input_frecuency-5;  
end
     
Fstop = 1;
Fpass = 10;
Astop = 65;
Apass = 0.2;

% output_d = designfilt('highpassfir','StopbandFrequency',Fstop, ...
%   'PassbandFrequency',Fpass,'StopbandAttenuation',Astop, ...
%   'PassbandRipple',Apass,'SampleRate',Fs,'DesignMethod','equiripple');

output_d = designfilt('highpassiir','FilterOrder',5, ...
    'PassbandFrequency',Fc,'PassbandRipple',0.2, ...
    'SampleRate',Fs); 

% this kind of filter introduces riple and lags

end

