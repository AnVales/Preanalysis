% TITLE: G_PLOT
% AUTHOR: ANVALES : https://github.com/AnVales
% DATE: 10/06/2021

% Plots of G' and G''

clc
clear all
close all
warning('off','all')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORGANISING DATA %

n1_n_2p = struct2array(load('señal_filtrada/Nucleo_1/n1_North_2hz_ident_clean_gprima.mat'));
n1_n_4p = struct2array(load('señal_filtrada/Nucleo_1/n1_North_4hz_ident_clean_gprima.mat'));
n1_n_5p = struct2array(load('señal_filtrada/Nucleo_1/n1_North_5hz_ident_clean_gprima.mat'));
n1_n_8p = struct2array(load('señal_filtrada/Nucleo_1/n1_North_8hz_ident_clean_gprima.mat'));
n1_n_10p = struct2array(load('señal_filtrada/Nucleo_1/n1_North_10hz_ident_clean_gprima.mat'));

n1_s_2p = struct2array(load('señal_filtrada/Nucleo_1/n1_South_2hz_ident_clean_gprima.mat'));
n1_s_4p = struct2array(load('señal_filtrada/Nucleo_1/n1_South_4hz_ident_clean_gprima.mat'));
n1_s_5p = struct2array(load('señal_filtrada/Nucleo_1/n1_South_5hz_ident_clean_gprima.mat'));
n1_s_8p = struct2array(load('señal_filtrada/Nucleo_1/n1_South_8hz_ident_clean_gprima.mat'));
n1_s_10p = struct2array(load('señal_filtrada/Nucleo_1/n1_South_10hz_ident_clean_gprima.mat'));

n2_e_2p = struct2array(load('señal_filtrada/Nucleo_2/n2_East_2hz_ident_clean_gprima.mat'));
n2_e_4p = struct2array(load('señal_filtrada/Nucleo_2/n2_East_4hz_ident_clean_gprima.mat'));
n2_e_5p = struct2array(load('señal_filtrada/Nucleo_2/n2_East_5hz_ident_clean_gprima.mat'));
n2_e_8p = struct2array(load('señal_filtrada/Nucleo_2/n2_East_8hz_ident_clean_gprima.mat'));
n2_e_10p = struct2array(load('señal_filtrada/Nucleo_2/n2_East_10hz_ident_clean_gprima.mat'));

n2_w_2p = struct2array(load('señal_filtrada/Nucleo_2/n2_West_2hz_ident_clean_gprima.mat'));
n2_w_4p = struct2array(load('señal_filtrada/Nucleo_2/n2_West_4hz_ident_clean_gprima.mat'));
n2_w_5p = struct2array(load('señal_filtrada/Nucleo_2/n2_West_5hz_ident_clean_gprima.mat'));
n2_w_8p = struct2array(load('señal_filtrada/Nucleo_2/n2_West_8hz_ident_clean_gprima.mat'));
n2_w_10p = struct2array(load('señal_filtrada/Nucleo_2/n2_West_10hz_ident_clean_gprima.mat'));

matrix_datap = [ n1_n_2p, n1_n_4p, n1_n_5p, n1_n_8p, n1_n_10p;
    n1_s_2p, n1_s_4p, n1_s_5p, n1_s_8p, n1_s_10p;
    n2_e_2p, n2_e_4p, n2_e_5p, n2_e_8p, n2_e_10p;
    n2_w_2p, n2_w_4p, n2_w_5p, n2_w_8p, n2_w_10p];

frec = [2, 4, 5, 8, 10];
matrix_data_mean = zeros(1, length(frec));
matrix_datap = abs(matrix_datap);

for i = 1 : length(frec)
    matrix_data_mean(i) = mean(abs(matrix_datap(:,i)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT %

figure(1);
% boxplot([matrix_datap], frec);
plot(frec, abs(matrix_datap(1,:)),'-*', frec, abs(matrix_datap(2,:)),'-*', frec, abs(matrix_datap(3,:)),'-*', frec, abs(matrix_datap(4,:)),'-*');
str = ' Frecuency ($$Hz$$) '; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
str = ' G'' and G'''' ($$Pa$$) '; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
% legend('Location','northeast')
% h = legend('Nucleus 1, North','Nucleus 1, South', 'Nucleus 2, East', 'Nucleus 2, West');
legend('Location','northeast')
h = legend('G''', 'G''''');
ax = gca;
ax.FontSize = 25;
ylim([0, 0.45])

figure(2);
plot(frec, matrix_data_mean, '*')
str = ' Frecuency ($$Hz$$) '; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
str = ' G'' ($$Pa$$) '; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
ax = gca;
ax.FontSize = 25;
ylim([0, 0.45])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORGANISING DATA %

n1_n_2pp = struct2array(load('señal_filtrada/Nucleo_1/n1_North_2hz_ident_clean_gprimaprima.mat'));
n1_n_4pp = struct2array(load('señal_filtrada/Nucleo_1/n1_North_4hz_ident_clean_gprimaprima.mat'));
n1_n_5pp = struct2array(load('señal_filtrada/Nucleo_1/n1_North_5hz_ident_clean_gprimaprima.mat'));
n1_n_8pp = struct2array(load('señal_filtrada/Nucleo_1/n1_North_8hz_ident_clean_gprimaprima.mat'));
n1_n_10pp = struct2array(load('señal_filtrada/Nucleo_1/n1_North_10hz_ident_clean_gprimaprima.mat'));

n1_s_2pp = struct2array(load('señal_filtrada/Nucleo_1/n1_South_2hz_ident_clean_gprimaprima.mat'));
n1_s_4pp = struct2array(load('señal_filtrada/Nucleo_1/n1_South_4hz_ident_clean_gprimaprima.mat'));
n1_s_5pp = struct2array(load('señal_filtrada/Nucleo_1/n1_South_5hz_ident_clean_gprimaprima.mat'));
n1_s_8pp = struct2array(load('señal_filtrada/Nucleo_1/n1_South_8hz_ident_clean_gprimaprima.mat'));
n1_s_10pp = struct2array(load('señal_filtrada/Nucleo_1/n1_South_10hz_ident_clean_gprimaprima.mat'));

n2_e_2pp = struct2array(load('señal_filtrada/Nucleo_2/n2_East_2hz_ident_clean_gprimaprima.mat'));
n2_e_4pp = struct2array(load('señal_filtrada/Nucleo_2/n2_East_4hz_ident_clean_gprimaprima.mat'));
n2_e_5pp = struct2array(load('señal_filtrada/Nucleo_2/n2_East_5hz_ident_clean_gprimaprima.mat'));
n2_e_8pp = struct2array(load('señal_filtrada/Nucleo_2/n2_East_8hz_ident_clean_gprimaprima.mat'));
n2_e_10pp = struct2array(load('señal_filtrada/Nucleo_2/n2_East_10hz_ident_clean_gprimaprima.mat'));

n2_w_2pp = struct2array(load('señal_filtrada/Nucleo_2/n2_West_2hz_ident_clean_gprimaprima.mat'));
n2_w_4pp = struct2array(load('señal_filtrada/Nucleo_2/n2_West_4hz_ident_clean_gprimaprima.mat'));
n2_w_5pp = struct2array(load('señal_filtrada/Nucleo_2/n2_West_5hz_ident_clean_gprimaprima.mat'));
n2_w_8pp = struct2array(load('señal_filtrada/Nucleo_2/n2_West_8hz_ident_clean_gprimaprima.mat'));
n2_w_10pp = struct2array(load('señal_filtrada/Nucleo_2/n2_West_10hz_ident_clean_gprimaprima.mat'));

matrix_datapp = [ n1_n_2pp, n1_n_4pp, n1_n_5pp, n1_n_8pp, n1_n_10pp;
    n1_s_2pp, n1_s_4pp, n1_s_5pp, n1_s_8pp, n1_s_10pp;
    n2_e_2pp, n2_e_4pp, n2_e_5pp, n2_e_8pp, n2_e_10pp;
    n2_w_2pp, n2_w_4pp, n2_w_5pp, n2_w_8pp, n2_w_10pp];

frec = [2, 4, 5, 8, 10];

matrix_data_mean = zeros(1, length(frec));
matrix_datapp = abs(matrix_datapp);

for i = 1 : length(frec)
    matrix_data_mean_pp(i) = mean(matrix_datapp(:,i));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT %

figure(3);
boxplot([matrix_datapp], frec);
str = ' Frecuency ($$Hz$$) '; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
str = ' G'''' ($$Pa$$) '; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
ax = gca;
ax.FontSize = 25;
ylim([0, 0.45])

figure(4);
plot(frec, matrix_data_mean_pp, '*')
str = ' Frecuency ($$Hz$$) '; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
str = ' G'''' ($$Pa$$) '; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
ax = gca;
ax.FontSize = 25;
ylim([0, 0.45])
