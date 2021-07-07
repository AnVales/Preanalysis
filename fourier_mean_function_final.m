% TITLE: AVERAGE OF FOURIER TRANSFORMS
% AUTHOR: ANVALES : https://github.com/AnVales
% DATE: 21/05/2021

% Average of fast fourier transforms final

function [output_f_fourier,output_P1_fourier, output_cycle_data] = fourier_mean_function_final(input_t,input_sensor_bead, input_frecuecy)

% SET PARAMETERS  
Fs_fourier = 1/input_t(2);                             
T_fourier = 1/Fs_fourier;                   
L_fourier = length(input_t);             
t_fourier = (0:L_fourier-1)*T_fourier;        

% OBTAIN FOURIER
fourier_data = fft(input_sensor_bead);
fourier_data_lenght = length(fourier_data);

% CYCLES INFORMATION
number_cycles = input_frecuecy * input_t(end); 
number_cycles_wanted = 2; 

output_cycle_data = floor(fourier_data_lenght/number_cycles); 

% PREPARE THE NEW FOURIER DATA UN GROUPS
row_cycles2_matrix = floor(output_cycle_data * number_cycles_wanted); 
col_cycles2_matrix = floor(fourier_data_lenght/(output_cycle_data*number_cycles_wanted)); 

cycles2_matrix = zeros( row_cycles2_matrix, col_cycles2_matrix);

% FOURIER DATA IN GROUPS OF THE NUMBER OF CYCLES THAT ARE WANTED
for i = 1: floor((fourier_data_lenght/(output_cycle_data*number_cycles_wanted)))
    if i ==1
        cycles2 = fourier_data(1 : i*output_cycle_data*number_cycles_wanted);
    else 
        cycles2 = fourier_data(((i - 1) * (output_cycle_data * number_cycles_wanted)) + 1 : i * output_cycle_data * number_cycles_wanted);
    end
    cycles2_matrix (:,i) = cycles2;
end

% SET THE NEW FOURIER MATRIX WITH THE MEAN FOURIER
cycles2_matrix_size = size (cycles2_matrix);
cycles2_matrix_row = cycles2_matrix_size(1);
cycles2_matrix_col = cycles2_matrix_size(2);

fourier_data_mean = zeros(1, cycles2_matrix_col);

% OBTAIN THE MAIN FOURIER
for i = 1:floor(cycles2_matrix_col)
    column_data = cycles2_matrix(:,i);
    column_data_mean = sum(column_data)/cycles2_matrix_row;
    fourier_data_mean(1, i) = column_data_mean;
end

% OBTAIN THE NEW PLOT OF P
L_fourier = length(fourier_data_mean);

P2_fourier = abs(fourier_data_mean/L_fourier);
output_P1_fourier = P2_fourier(1:L_fourier/2+1);
output_P1_fourier(2:end-1) = 2*output_P1_fourier(2:end-1);

output_f_fourier = Fs_fourier*(0:(L_fourier/2))/L_fourier;

end

