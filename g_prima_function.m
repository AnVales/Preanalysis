% TITLE: G_PRIMA_FUNCTION
% AUTHOR: ÁNGELA VALES : https://github.com/AnVales
% DATE: 01/06/2021

% Calculate G'

function [output_g_prima] = g_prima_function(input_fmax,input_r, input_xmax, input_lag, input_f)
    
    theta = 2*pi*input_lag*input_f;
    input_fmax_n = input_fmax * 10^(-12);
    input_r_m = input_r * 10^(-6);
    input_xmax_m = input_xmax * 10^(-6);
    output_g_prima = ((input_fmax_n)/(6*pi*input_r_m*input_xmax_m))*cos(theta);

end

