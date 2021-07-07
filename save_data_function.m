% TITLE: SAVE DATA FUNCTION
% AUTHOR: ANVALES : https://github.com/AnVales
% DATE: 21/05/2021

% Save the data in a predeterminate file

function [input_nucleus_number] = save_data_function(input_nucleus_number,input_position, input_frecuency, input_force_bead_filter, input_sensor_bead_filter, input_viscosity_filter, input_displacement_sensor, input_gprima_filter, input_gprimaprima_filter)

path_sensor_bead = "señal_filtrada\Nucleo_" + input_nucleus_number + "\n" + input_nucleus_number + "_" + input_position + "_" + input_frecuency + "hz_sensor_clean.mat";
path_force_bead = "señal_filtrada\Nucleo_" + input_nucleus_number + "\n" + input_nucleus_number + "_" + input_position + "_" + input_frecuency + "hz_ident_clean.mat";
path_viscosity = "señal_filtrada\Nucleo_" + input_nucleus_number + "\n" + input_nucleus_number + "_" + input_position + "_" + input_frecuency + "hz_ident_clean_viscosity.mat";
path_sensor_bead_displacement = "señal_filtrada\Nucleo_" + input_nucleus_number + "\n" + input_nucleus_number + "_" + input_position + "_" + input_frecuency + "hz_sensor_displacement_clean.mat";
path_input_gprima_filter = "señal_filtrada\Nucleo_" + input_nucleus_number + "\n" + input_nucleus_number + "_" + input_position + "_" + input_frecuency + "hz_ident_clean_gprima.mat";
path_input_gprimaprima_filter = "señal_filtrada\Nucleo_" + input_nucleus_number + "\n" + input_nucleus_number + "_" + input_position + "_" + input_frecuency + "hz_ident_clean_gprimaprima.mat";


save([path_force_bead], 'input_force_bead_filter')
save([path_sensor_bead], 'input_sensor_bead_filter')
save([path_viscosity], 'input_viscosity_filter')
save([path_sensor_bead_displacement], 'input_displacement_sensor')
save([path_input_gprima_filter], 'input_gprima_filter')
save([path_input_gprimaprima_filter], 'input_gprimaprima_filter')

end

