% TITLE: REAL DISPLACEMENT FUNCTION
% AUTHOR: ANVALES : https://github.com/AnVales
% DATE: 24/05/2021

function [output_displacement_sensor,output_displacement_force] = real_displacement_function(input_force_sensor,input_force_force, input_k)

    for i = 1: length(input_force_sensor)
        displacement_i = input_force_sensor(i) / input_k;
        output_displacement_sensor(i) = displacement_i;
    end
    
    for i = 1: length(input_force_force)
        displacement_i = input_force_force(i) / input_k;
        output_displacement_force(i) = displacement_i;
    end

end

