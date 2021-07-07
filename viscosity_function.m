% TITLE: VISCOSITY FUNCTION
% AUTHOR: ANVALES : https://github.com/AnVales
% DATE: 01/06/2021

% Calculate viscosity

function [output_viscosity] = viscosity_function(input_g_prima, input_g_prima_prima, input_f)

    g_prima_2 = input_g_prima^(2);
    g_prima_prima_2 = input_g_prima_prima^(2);
    g_prima_join = g_prima_2 + g_prima_prima_2;
    numerador = sqrt(g_prima_join);
    denominador = 2*pi*input_f;
    output_viscosity = numerador/denominador;

end

