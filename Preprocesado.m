
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read the opticals tweezers data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PATH AND INFORMATION %

path = 'Copia/Nucleo_2_copia/Position_West/10Hz/Indentation1/Indentation1.txt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INFORMATION ABOUT THE DATA %

path_split = strsplit(path, '/');

pattern_nucleus = '\d';
nucleus_number_cell = regexp(path_split(2), pattern_nucleus, 'match');
nucleus_number = cell2mat(nucleus_number_cell{1});

pattern_frecuency = '\d(\d)?';
frecuency_cell = regexp(path_split(4), pattern_frecuency, 'match');
frecuency = cell2mat(frecuency_cell{1});
frecuency = str2double(frecuency);

pattern_position = 'North|South|West|East';
position_cell = regexp(path_split(3), pattern_position, 'match');
position = cell2mat(position_cell{1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORT DATA %

data=importdata(path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBTAIN THE DATA %

[fil,col]=size(data);
M=fil;

Ntraps=col/6; % number of traps of the experiment
%  parameters
Sum_Fx=zeros(1,Ntraps);
Sum_Fy=zeros(1,Ntraps);
F_cycle=zeros(M,Ntraps);

t = data(:,1);
dt=(max(t)-min(t))/length(t);

k=1;

% Notation: Capital letters -> non-filtered data
%           Non-capital letters -> filtered data  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CORRECT OFF-SET %

for i =1:6:6*Ntraps
    t = data(:,1); % Time
    Fx(:,k)=data(:,i+1)-mean(data(:,i+1)); % Force in X with corrected off-set
    Fy(:,k)=data(:,i+2)-mean(data(:,i+2)); % Force in Y with corrected off-set
    Dx(:,k)=data(:,i+3)-mean(data(:,i+3)); % dispacement in X with corrected off-set
    Dy(:,k)=data(:,i+4)-mean(data(:,i+4)); % dispacement in Y with corrected off-set
    P(:,k)=data(:,i+5);  % Power of the trap
    k=k+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE IN X OR Y

direction_force = direction_force_function(position, Fx, Fy);

% if strcmp(position,'West')|strcmp(position,'East')
%     direction_force = Fx;
% else
%     direction_force = Fy;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE BEAD AND SENSOR BEAD FOR TWO BEADS WITHOUT FILTER

% SOLO FUNCIONA PARA DOS, SE PODRÍA HACER MÁS FINAMENTE PERO ES LO QUE
% TIENE USAR MATLAB Y NO PYTHON

% dimensions_force = size(direction_force);
% n_col_force = dimensions_force(2);
% 
% lista_rangos = [0, 0, 0, 0];
%     
% for i = 1 : n_col_force
%     columna = direction_force(:,i);
%     rango = range(columna);
%     par = [i, rango];
%     lista_rangos(i) = par;
% end
    
rango1_no_filter = range(direction_force(:,1));
rango2_no_filter = range(direction_force(:,2));

if rango1_no_filter > rango2_no_filter
    force_bead_no_filter = direction_force(:,1);
    sensor_bead_no_filter = direction_force(:,2);
else
    force_bead_no_filter = direction_force(:,2);
    sensor_bead_no_filter = direction_force(:,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOURIER %

% SET PARAMETERS  
Fs_fourier = 1/t(2);          % Sampling frequency                    
T_fourier = 1/Fs_fourier;             % Sampling period       
L_fourier = length(t);             % Length of signal
t_fourier = (0:L_fourier-1)*T_fourier;        % Time vector

% OBTAIN FOURIER
fourier_data = fft(sensor_bead_no_filter);
fourier_data_lenght = length(fourier_data);

% CYCLES INFORMATION
number_cycles = frecuency * t(end); % Number of cycles in the data
number_cycles_wanted = 2; % Number of cycles that are wanted

cycle_data = floor(fourier_data_lenght/number_cycles); % How many data describe one cycle?

% PREPARE THE NEW FOURIER DATA UN GROUPS
row_cycles2_matrix = floor(cycle_data * number_cycles_wanted); % Number of rows
col_cycles2_matrix = floor(fourier_data_lenght/(cycle_data*number_cycles_wanted)); % Number of columns

cycles2_matrix = zeros( row_cycles2_matrix, col_cycles2_matrix); % Set the matrix with 0s

% FOURIER DATA IN GROUPS OF THE NUMBER OF CYCLES THAT ARE WANTED
for i = 1: floor((fourier_data_lenght/(cycle_data*number_cycles_wanted)))
    if i ==1
        cycles2 = fourier_data(1 : i*cycle_data*number_cycles_wanted);
    else 
        cycles2 = fourier_data(((i - 1) * (cycle_data * number_cycles_wanted)) + 1 : i * cycle_data * number_cycles_wanted);
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

% OBTAIN THE NEW PLOT
L_fourier = length(fourier_data_mean);

P2_fourier = abs(fourier_data_mean/L_fourier);
P1_fourier = P2_fourier(1:L_fourier/2+1);
P1_fourier(2:end-1) = 2*P1_fourier(2:end-1);

f_fourier = Fs_fourier*(0:(L_fourier/2))/L_fourier;
figure(1); loglog(f_fourier,P1_fourier) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILTER SET UP: LOW PASS FIR FILTER

Fs=1/t(2); % Sampling frequency
Fc=frecuency+5;   % Cutoff frequency - should be above the freq. of the oscilation experiment

d = designfilt('lowpassiir','FilterOrder',5, ...
         'PassbandFrequency',Fc,'PassbandRipple',0.2, ...
         'SampleRate',Fs);
     
% Fstop = 1;
% Fpass = 40;
% Astop = 65;
% Apass = 0.5;
% Fs = 1e3;

% d = designfilt('highpassfir','StopbandFrequency',Fstop, ...
%   'PassbandFrequency',Fpass,'StopbandAttenuation',Astop, ...
%   'PassbandRipple',Apass,'SampleRate',Fs,'DesignMethod','equiripple');


% this kind of filter introduces riple and lags

for k=1:Ntraps
    fx(:,k)=filter(d,Fx(:,k)); % filtered Fx
    fy(:,k)=filter(d,Fy(:,k)); % filtered Fy
    dx(:,k)=filter(d,Dx(:,k)); % filtered dispacement in X
    dy(:,k)=filter(d,Dy(:,k)); % filtered dispacement in Y
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILTER SET UP: HIGH PASS FIR FILTER

Fs=1/t(2); % Sampling frequency
Fc1=frecuency-5;   % Cutoff frequency - should be above the freq. of the oscilation experiment
     
Fstop = 1;
Fpass = 10;
Astop = 65;
Apass = 0.2;
% Fs = 1e3;

% d = designfilt('highpassfir','StopbandFrequency',Fstop, ...
%   'PassbandFrequency',Fpass,'StopbandAttenuation',Astop, ...
%   'PassbandRipple',Apass,'SampleRate',Fs,'DesignMethod','equiripple');

d = designfilt('highpassiir','FilterOrder',5, ...
    'PassbandFrequency',Fc1,'PassbandRipple',0.2, ...
    'SampleRate',Fs); 
   

% this kind of filter introduces riple and lags

for k=1:Ntraps
    fx(:,k)=filter(d,fx(:,k)); % filtered Fx
    fy(:,k)=filter(d,fy(:,k)); % filtered Fy
    dx(:,k)=filter(d,fx(:,k)); % filtered dispacement in X
    dy(:,k)=filter(d,fy(:,k)); % filtered dispacement in Y
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE IN X OR Y FOR FILTERED DATA

if strcmp(position,'West')|strcmp(position,'East')
    direction_force_filter = fx;
else
    direction_force_filter = fy;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE BEAD AND SENSOR BEAD FOR TWO BEADS WITHOUT FILTER

rango1_filter = range(direction_force_filter(:,1));
rango2_filter = range(direction_force_filter(:,2));

if rango1_filter > rango2_filter
    force_bead_filter = direction_force_filter(:,1);
    sensor_bead_filter = direction_force_filter(:,2);
else
    force_bead_filter = direction_force_filter(:,2);
    sensor_bead_filter = direction_force_filter(:,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOURIER  FOR FILTERED DATA %

% SET PARAMETERS  
Fs_fourier1 = 1/t(2);          % Sampling frequency                    
T_fourier1 = 1/Fs_fourier1;             % Sampling period       
L_fourier1 = length(t);             % Length of signal
t_fourier1 = (0:L_fourier1-1)*T_fourier1;        % Time vector

% OBTAIN FOURIER
fourier_data1 = fft(sensor_bead_filter);
fourier_data_lenght1 = length(fourier_data1);

% CYCLES INFORMATION
number_cycles1 = frecuency * t(end); % Number of cycles in the data
number_cycles_wanted1 = 2; % Number of cycles that are wanted

cycle_data1 = floor(fourier_data_lenght1/number_cycles1); % How many data describe one cycle?

% PREPARE THE NEW FOURIER DATA UN GROUPS
row_cycles2_matrix1 = floor(cycle_data1 * number_cycles_wanted1); % Number of rows
col_cycles2_matrix1 = floor(fourier_data_lenght1/(cycle_data1*number_cycles_wanted1)); % Number of columns

cycles2_matrix1 = zeros( row_cycles2_matrix1, col_cycles2_matrix1); % Set the matrix with 0s

% FOURIER DATA IN GROUPS OF THE NUMBER OF CYCLES THAT ARE WANTED
for i = 1: floor((fourier_data_lenght1/(cycle_data1*number_cycles_wanted1)))
    if i ==1
        cycles21 = fourier_data1(1 : i*cycle_data1*number_cycles_wanted1);
    else 
        cycles21 = fourier_data1(((i - 1) * (cycle_data1 * number_cycles_wanted1)) + 1 : i * cycle_data1 * number_cycles_wanted1);
    end
    cycles2_matrix1 (:,i) = cycles21;
end

% SET THE NEW FOURIER MATRIX WITH THE MEAN FOURIER
cycles2_matrix_size1 = size (cycles2_matrix1);
cycles2_matrix_row1 = cycles2_matrix_size1(1);
cycles2_matrix_col1 = cycles2_matrix_size1(2);

fourier_data_mean1= zeros(1, cycles2_matrix_col1);

% OBTAIN THE MAIN FOURIER
for i = 1:floor(cycles2_matrix_col1)
    column_data1 = cycles2_matrix1(:,i);
    column_data_mean1 = sum(column_data1)/cycles2_matrix_row1;
    fourier_data_mean1(1, i) = column_data_mean1;
end

% OBTAIN THE NEW PLOT
L_fourier1 = length(fourier_data_mean1);

P2_fourier1 = abs(fourier_data_mean1/L_fourier1);
P1_fourier1 = P2_fourier1(1:L_fourier1/2+1);
P1_fourier1(2:end-1) = 2*P1_fourier1(2:end-1);

f_fourier1 = Fs_fourier1*(0:(L_fourier1/2))/L_fourier1;
figure(2); loglog(f_fourier1,P1_fourier1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FORCES WITHOUT FILTERING

for m=1:Ntraps

    Sum_Fx(m)=sum(sqrt(Fx(:,m).^2)); Sum_Fy(m)=sum(sqrt(Fy(:,m).^2));
    
    figure(3); subplot(Ntraps,1,m); plot(t,Fx(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ Fx $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;  
    grid

    figure(4); subplot(Ntraps,1,m); plot(t,Fy(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ Fy $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;    
    grid   
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DISPLACEMENTS WITHOUT FILTERING

for m=1:Ntraps
    figure(5); subplot(Ntraps,1,m); plot(t,Dy(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ \Delta y $$'; h=ylabel(str,'Interpreter','latex');s=h.FontSize; h.FontSize=20;    
    grid   
    
    figure(6); subplot(Ntraps,1,m); plot(t,Dx(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20; 
    str = '$$ \Delta x $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;  
    grid
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FORCES WITH FILTER

for m=1:Ntraps

    Sum_fx(m)=sum(sqrt(fx(:,m).^2)); Sum_fy(m)=sum(sqrt(fy(:,m).^2));

    figure(7); subplot(Ntraps,1,m); plot(t,fy(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ fy $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;    
    grid   
    
    figure(8); subplot(Ntraps,1,m); plot(t,fx(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ fx $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;  
    grid
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE THE DATA

path_sensor_bead = "señal_filtrada\Nucleo_" + nucleus_number + "\n" + nucleus_number + "_" + position + "_" + frecuency + "hz_sensor_clean.mat";
path_force_bead = "señal_filtrada\Nucleo_" + nucleus_number + "\n" + nucleus_number + "_" + position + "_" + frecuency + "hz_ident_clean.mat";


save([path_force_bead], 'force_bead_filter')
save([path_sensor_bead], 'sensor_bead_filter')

% detect displacement set-up
% dsip_x=max(Dx); disp_y=max(Dy)