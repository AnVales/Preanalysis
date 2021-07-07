% TITLE: VISCOSITY_PLOT
% AUTHOR: ANVALES : https://github.com/AnVales
% DATE: 10/06/2021

% Plot the viscosity

clc
clear all
close all
warning('off','all')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORGANISING DATA %

n1_n_2 = struct2array(load('señal_filtrada/Nucleo_1/n1_North_2hz_ident_clean_viscosity.mat'));
n1_n_4 = struct2array(load('señal_filtrada/Nucleo_1/n1_North_4hz_ident_clean_viscosity.mat'));
n1_n_5 = struct2array(load('señal_filtrada/Nucleo_1/n1_North_5hz_ident_clean_viscosity.mat'));
n1_n_8 = struct2array(load('señal_filtrada/Nucleo_1/n1_North_8hz_ident_clean_viscosity.mat'));
n1_n_10 = struct2array(load('señal_filtrada/Nucleo_1/n1_North_10hz_ident_clean_viscosity.mat'));

n1_s_2 = struct2array(load('señal_filtrada/Nucleo_1/n1_South_2hz_ident_clean_viscosity.mat'));
n1_s_4 = struct2array(load('señal_filtrada/Nucleo_1/n1_South_4hz_ident_clean_viscosity.mat'));
n1_s_5 = struct2array(load('señal_filtrada/Nucleo_1/n1_South_5hz_ident_clean_viscosity.mat'));
n1_s_8 = struct2array(load('señal_filtrada/Nucleo_1/n1_South_8hz_ident_clean_viscosity.mat'));
n1_s_10 = struct2array(load('señal_filtrada/Nucleo_1/n1_South_10hz_ident_clean_viscosity.mat'));

n2_e_2 = struct2array(load('señal_filtrada/Nucleo_2/n2_East_2hz_ident_clean_viscosity.mat'));
n2_e_4 = struct2array(load('señal_filtrada/Nucleo_2/n2_East_4hz_ident_clean_viscosity.mat'));
n2_e_5 = struct2array(load('señal_filtrada/Nucleo_2/n2_East_5hz_ident_clean_viscosity.mat'));
n2_e_8 = struct2array(load('señal_filtrada/Nucleo_2/n2_East_8hz_ident_clean_viscosity.mat'));
n2_e_10 = struct2array(load('señal_filtrada/Nucleo_2/n2_East_10hz_ident_clean_viscosity.mat'));

n2_w_2 = struct2array(load('señal_filtrada/Nucleo_2/n2_West_2hz_ident_clean_viscosity.mat'));
n2_w_4 = struct2array(load('señal_filtrada/Nucleo_2/n2_West_4hz_ident_clean_viscosity.mat'));
n2_w_5 = struct2array(load('señal_filtrada/Nucleo_2/n2_West_5hz_ident_clean_viscosity.mat'));
n2_w_8 = struct2array(load('señal_filtrada/Nucleo_2/n2_West_8hz_ident_clean_viscosity.mat'));
n2_w_10 = struct2array(load('señal_filtrada/Nucleo_2/n2_West_10hz_ident_clean_viscosity.mat'));

matrix_data = [ n1_n_2, n1_n_4, n1_n_5, n1_n_8, n1_n_10;
    n1_s_2, n1_s_4, n1_s_5, n1_s_8, n1_s_10;
    n2_e_2, n2_e_4, n2_e_5, n2_e_8, n2_e_10;
    n2_w_2, n2_w_4, n2_w_5, n2_w_8, n2_w_10];

frec = [2, 4, 5, 8, 10];

matrix_data_mean = zeros(1, length(frec));
matrix_data = abs(matrix_data);

for i = 1 : length(frec)
    matrix_data_mean(i) = mean(matrix_data(:,i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT %

figure(1);
boxplot([matrix_data], frec);
% plot(frec, abs(matrix_datap(1,:)),'-*', frec, abs(matrix_datap(2,:)),'-*', frec, abs(matrix_datap(3,:)),'-*', frec, abs(matrix_datap(4,:)),'-*');
str = ' Frecuency ($$Hz$$) '; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
str = ' Viscosity ($$Pa s$$) '; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
% legend('Location','northeast')
% h = legend('Nucleus 1, North','Nucleus 1, South', 'Nucleus 2, East', 'Nucleus 2, West');
ax = gca;
ax.FontSize = 25;
ylim([0 0.04])

figure(2);
plot(frec, matrix_data_mean, '*')
str = ' Frecuency ($$Hz$$) '; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
str = ' Viscosity ($$Pa s$$) '; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
ax = gca;
ax.FontSize = 25;
ylim([0 0.04])

% figure(1);
% plot1 = plot(frec, matrix_data(1,:),'-*', frec, matrix_data(2,:),'-*', frec, matrix_data(3,:),'-*', frec, matrix_data(4,:),'-*');
% str = ' Frecuency ($$Hz$$) '; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
% str = ' Viscosity ($$Pa s$$) '; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
% legend('Location','northeast')
% h = legend('Nucleus 1, North','Nucleus 1, South', 'Nucleus 2, East', 'Nucleus 2, West');
% ax = gca;
% ax.FontSize = 25;
