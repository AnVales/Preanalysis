% TITLE: F MAX FUNCTION
% AUTHOR: ÁNGELA VALES 
% DATE: 01/06/2021
% Find the fmax

function [ouput_fmax, output_fmax_list] = fmax_function(input_sensor_bead, input_cycle_data)

[sensor_pks, sensor_loc] = findpeaks(input_sensor_bead(5*input_cycle_data:end)); % find peaks and its location
output_fmax_list = sensor_pks;
ouput_fmax = mean(sensor_pks);

end


