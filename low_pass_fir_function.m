% TITLE: LOW PASS FIR FUNCTION
% AUTHOR: ÁNGELA VALES : https://github.com/AnVales
% DATE: 21/05/2021

% Filter the noise with a low pass fir filter

function [output_d] = low_pass_fir_function(input_t, input_frecuency, input_extra)

Fs = 1/input_t(2); % Sampling frequency
Fc = input_frecuency + input_extra;   % Cutoff frequency - should be above the freq. of the oscilation experiment

output_d = designfilt('lowpassiir','FilterOrder',5, ...
         'PassbandFrequency',Fc,'PassbandRipple',0.2, ...
         'SampleRate',Fs);

% this kind of filter introduces riple and lags
end