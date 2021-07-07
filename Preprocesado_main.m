%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read the opticals tweezers data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all
warning('off','all')

% Notation: Capital letters -> non-filtered data
%           Non-capital letters -> filtered data  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PATH AND INFORMATION %

path = 'Copia/Nucleo_1_copia/Position_South/10Hz/Indentation1/Indentation1.txt';
k_trap = 23.8;
bead_r = 3.00;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INFORMATION ABOUT THE DATA %

[nucleus_number, frecuency, position] = search_pattern_function(path);

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
% FORCE IN X OR Y %

direction_force = direction_force_function(position, Fx, Fy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE BEAD AND SENSOR BEAD FOR TWO BEADS WITHOUT FILTER %

if Ntraps == 2
    [force_bead_no_filter,sensor_bead_no_filter] = bead2_determination_function(direction_force);
    
elseif Ntraps == 3
    [force_bead, sensor_bead, nucleolo_bead] = bead3_determination_function(direction_force);
    
elseif Ntraps == 4
    [force_bead, sensor_bead, another_bead1, another_bead2] = bead4_determination_function(direction_force);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESAMPLE DATA %
% [output_resample] = resample_function(sensor_bead_no_filter ,input_p, input_q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOURIER %

[f_fourier,P1_fourier]=fourier(t,sensor_bead_no_filter,'sinus');
% [f_fourier, P1_fourier, cycle_data, fourier_data_mean] = fourier_mean_function(t ,sensor_bead_no_filter, frecuency);

figure(1); stem(f_fourier,abs(P1_fourier), 'MarkerFaceColor',[0,0.51,0.255]) 
str = 'f ($$Hz$$)'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
str = 'Amplitude ($$dB$$)'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
ax = gca;
ax.FontSize = 25;
ylim([0,1.75])
xlim([1,65])
grid

% title('Single-Sided Amplitude Spectrum of Fx(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% 
% ly = length(fourier_data_mean);
% fs = 1/t(2);
% frec_fourier_filter = (-ly/2:ly/2-1)/ly*fs;
% 
% figure(11);stem(frec_fourier_filter,angle(fourier_data_mean))
% xlabel 'Frequency (Hz)'
% ylabel '|y|'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOURIER PHASE %

[f,F_x_f]=fourier(t,sensor_bead_no_filter,'sinus');

% plot the magnitude spectrum
figure(11)
stem(f,abs(F_x_f))
grid on
xlim([0,20])
xlabel('Frequency in Hz')
ylabel('Amplitude spectrum of the force in N')

% plot the phase spectrum
figure(12)
stem(f,angle(F_x_f)*180/pi)
grid on
xlim([0,20])
xlabel('Frequency in Hz')
ylabel('Phase spectrum of the force in °')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILTER SET UP: LOW PASS FIR FILTER %

[d] = low_pass_fir_function(t, frecuency, 5);

for k=1:Ntraps
    fx(:,k)=filter(d,Fx(:,k)); % filtered Fx
    fy(:,k)=filter(d,Fy(:,k)); % filtered Fy
    dx(:,k)=filter(d,Dx(:,k)); % filtered dispacement in X
    dy(:,k)=filter(d,Dy(:,k)); % filtered dispacement in Y
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILTER SET UP: HIGH PASS FIR FILTER %

[d] = high_pass_fir_function(t,frecuency);
    
for k=1:Ntraps
    fx(:,k)=filter(d,fx(:,k)); % filtered Fx
    fy(:,k)=filter(d,fy(:,k)); % filtered Fy
    dx(:,k)=filter(d,fx(:,k)); % filtered dispacement in X
    dy(:,k)=filter(d,fy(:,k)); % filtered dispacement in Y
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE IN X OR Y FOR FILTERED DATA %

[direction_force_filter] = direction_force_function(position, fx, fy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLACAMENT IN X OR Y FOR FILTERED DATA %

[direction_displacement_filter] = direction_force_function(position, dx, dy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE BEAD AND SENSOR BEAD FOR TWO BEADS WITHOUT FILTER %

if Ntraps == 2
    [force_bead_filter,sensor_bead_filter] = bead2_determination_function(direction_force_filter);
    
elseif Ntraps == 3
    [force_bead_filter, sensor_bead_filter, nucleolo_bead_filter] = bead3_determination_function(direction_force);
    
elseif Ntraps == 4
    [force_bead_filter, sensor_bead_filter, another_bead1_filter, another_bead2_filter] = bead4_determination_function(direction_force);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE BEAD AND SENSOR BEAD FOR TWO BEADS WITHOUT FILTER %

[force_displacement_bead_filter,sensor_displacement_bead_filter] = bead2_determination_function(direction_displacement_filter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOURIER FOR FILTERED DATA %

% [f_fourier_filter,P1_fourier_filter]=fourier(t,sensor_bead_filter,'sinus');
[f_fourier_filter, P1_fourier_filter, cycle_data, fourier_data_mean] = fourier_mean_function(t ,sensor_bead_filter, frecuency);

figure(2); stem(f_fourier_filter,abs(P1_fourier_filter), 'MarkerFaceColor',[0,0.51,0.255]) 
str = 'f ($$Hz$$)'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
str = 'Amplitude ($$dB$$)'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
ax = gca;
ax.FontSize = 25;
ylim([0,1.75])
xlim([1,65])
grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FORCES WITHOUT FILTERING %

for m=1:Ntraps

    Sum_Fx(m)=sum(sqrt(Fx(:,m).^2)); Sum_Fy(m)=sum(sqrt(Fy(:,m).^2));
    
    figure(3); subplot(Ntraps,1,m); plot(t,Fx(:,m),'MarkerFaceColor',[0,0.51,0.255])
    str = 'Time ($$s$$)'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
    str = 'Force ($$pN$$)'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
    ax = gca;
    ax.FontSize = 25;
    xlim([t(75) t(249)])
    ylim([-12,12])
    grid

    figure(4); subplot(Ntraps,1,m); plot(t,Fy(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ Fy $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;    
    grid   
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DISPLACEMENTS WITHOUT FILTERING %

% for m=1:Ntraps
%     figure(5); subplot(Ntraps,1,m); plot(t,Dy(:,m))
%     str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
%     str = '$$ \Delta y $$'; h=ylabel(str,'Interpreter','latex');s=h.FontSize; h.FontSize=20;    
%     grid   
%     
%     figure(6); subplot(Ntraps,1,m); plot(t,Dx(:,m))
%     str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20; 
%     str = '$$ \Delta x $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;  
%     grid
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FORCES WITH FILTER %

for m=1:Ntraps

    Sum_fx(m)=sum(sqrt(fx(:,m).^2)); Sum_fy(m)=sum(sqrt(fy(:,m).^2));
    
    figure(7); subplot(Ntraps,1,m); plot(t(75:249),fx(75:249,m),'MarkerFaceColor',[0,0.51,0.255])
    str = 'Time ($$s$$)'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
    str = 'Force filtered ($$pN$$)'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
    ax = gca;
    ax.FontSize = 25;
    xlim([t(75) t(249)])
    ylim([-12,12])
    grid

    figure(8); subplot(Ntraps,1,m); plot(t,fy(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ Fy $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;    
    grid   
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FORCES, COMPARE FILTER AND NO FILTER %

figure(9); subplot(Ntraps,1,1); plot(t(cycle_data*6:cycle_data*16), sensor_bead_no_filter(cycle_data*6:cycle_data*16))
xlim([t(cycle_data*6) t(cycle_data*16)])
str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
str = '$$ Fx $$ ( no filter )'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;    
grid   

subplot(Ntraps,1,2); plot(t(cycle_data*6:cycle_data*16), sensor_bead_filter(cycle_data*6:cycle_data*16))
xlim([t(cycle_data*6) t(cycle_data*16)])
str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
str = '$$ fx $$ ( filter)'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;    
grid 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FORCES HISTOGRAM, COMPARE FILTER AND NO FILTER %

figure(10); subplot(Ntraps,1,1); histogram(sensor_bead_no_filter)
str = ' $$ Fx $$( no filter )'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;    
grid   

subplot(Ntraps,1,2); histogram(sensor_bead_filter)
str = '$$ fx $$( filter)'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;    
grid 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE REAL U %

[displacement_sensor, displacement_force] = real_displacement_function(sensor_bead_filter,force_bead_filter, k_trap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE THE TIME-LAG %

[time_lag, time_lag_list] = time_lag_function(force_bead_filter, force_displacement_bead_filter, t, cycle_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CALCULATE FMAX %

[fmax, fmax_list] = fmax_function(force_bead_filter, cycle_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE X MAX %

[xmax, xmax_list] = xmax_function(displacement_force, cycle_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE G' AND G'' %

[g_prima] = g_prima_function(fmax, bead_r, xmax, time_lag, frecuency);
[g_prima_prima] = g_prima_prima_function(fmax, bead_r, xmax, time_lag, frecuency);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE VISCOSITY %

[viscosity] = viscosity_function(g_prima, g_prima_prima, frecuency);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE THE DATA %

[nucleus_number] = save_data_function(nucleus_number,position, frecuency, force_bead_filter, sensor_bead_filter, viscosity, displacement_sensor, g_prima, g_prima_prima);
