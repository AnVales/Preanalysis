
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Import data from the file %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all
data=importdata('Copia/Nucleo_1_copia/Position_North/2Hz/Indentation1/Indentation1.txt');

[fil,col]=size(data);
M=fil;

Ntraps=col/6; % number of traps of the experiment
%  incialization of varaibles
Sum_Fx=zeros(1,Ntraps);
Sum_Fy=zeros(1,Ntraps);
F_cycle=zeros(M,Ntraps);

t = data(:,1);
dt=(max(t)-min(t))/length(t);

k=1;

% Notation: Capital letters -> non-filtered data
%           Non-capital letters -> filtered data  

% Extraction of forces x-y; displacements x-y and Power by each trap. 
% correction of off-sets.

for i =1:6:6*Ntraps
    t = data(:,1); % Time
    Fx(:,k)=data(:,i+1)-mean(data(:,i+1)); % Force in X with corrected off-set
    Fy(:,k)=data(:,i+2)-mean(data(:,i+2)); % Force in Y with corrected off-set
    Dx(:,k)=data(:,i+3)-mean(data(:,i+3)); % dispacement in X with corrected off-set
    Dy(:,k)=data(:,i+4)-mean(data(:,i+4)); % dispacement in Y with corrected off-set
    P(:,k)=data(:,i+5);  % Power of the trap
    k=k+1;
end

% %% Filtering for the data forces and displacements
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% Filetering  %%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Filter set-up
% Fs=1000; % Sampling frequency
% Fc=100;   % Cutoff frequency - should be above the freq. of the oscilation experiment
% d = designfilt('lowpassiir','FilterOrder',5, ...
%          'PassbandFrequency',Fc,'PassbandRipple',0.2, ...
%          'SampleRate',Fs);
%      
% %%% Be carefull because this kind of filter introduces riple and lags!!!
% 
% for k=1:Ntraps
%     fx(:,k)=filter(d,Fx(:,k)); % filtered Fx
%     fy(:,k)=filter(d,Fy(:,k)); % filtered Fy
%     dx(:,k)=filter(d,Dx(:,k)); % filtered dispacement in X
%     dy(:,k)=filter(d,Dy(:,k)); % filtered dispacement in Y
% end

% Plot Forces

for m=1:Ntraps

    Sum_Fx(m)=sum(sqrt(Fx(:,m).^2)); Sum_Fy(m)=sum(sqrt(Fy(:,m).^2));

    figure(3); subplot(Ntraps,1,m); plot(t,Fy(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ Fy $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;    
    grid   
    
    figure(4); subplot(Ntraps,1,m); plot(t,Fx(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ Fx $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;  
    grid
end

% Detection Trap experiment:
detect=[Sum_Fx Sum_Fy]; [val_max,inde]=max(detect); Trap_Ex=inde;
% falta un paso

% Plot Displacements

for m=1:Ntraps
    figure(4); subplot(Ntraps,1,m); plot(t,Dy(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;
    str = '$$ \Delta y $$'; h=ylabel(str,'Interpreter','latex');s=h.FontSize; h.FontSize=20;    
    grid   
    
    figure(5); subplot(Ntraps,1,m); plot(t,Dx(:,m))
    str = '$$ time $$'; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20; 
    str = '$$ \Delta x $$'; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=20;  
    grid
end

% detect displacement set-up
% dsip_x=max(Dx); disp_y=max(Dy);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Determination poroelastic time constant %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FInd=Fx(:,Trap_Ex);
DInd=Dx(:,Trap_Ex);
%histogram(DInd/max(DInd))

% Fp=FInd(FInd>0);
% Fup=mode(Fp);
% H_pf=histogram(Fp);
% error_Fp=H_pf.BinWidth;

% Fn=FInd(FInd<0);
% Fdwn=mode(Fn);
% H_nf=histogram(Fn);
% error_Fdwn=H_nf.BinWidth;

DInd=DInd/max(DInd); % normalization
 
R=3e-6;      %[m] Radius of the indenter bead.
h=0.1e-6;    % deep of indentation,
a=sqrt(R*h); % radius of indentation.
 
j=1;
for k=1:M
    if DInd(k) == 1
      F_cy(k)= FInd(k);
    end
end

for k=1:M
    if FInd(k) > 0
      F_cy(k)= FInd(k);
    end
end
c=0;

AA=nonzeros(F_cy);
bb=diff(AA);
ther=find(bb<-1);
N=length(ther);
size_samp=diff(ther); M=size_samp(1);
Ds=zeros(1,N);

for m=1:N    
    if m < N
        fa=AA(ther(m):ther(m+1)-1); 
        Max_a=max(fa);
        min_a=min(fa);
        fn=(fa-min_a)/(Max_a-min_a);
        dt=t(end)-t(end-1);
        tn=dt.*(1:length(fn));
        Dh=Fitres2(tn',fn);
        Ds(1,m)=Dh.D*a;
    else
%         fa=AA(ther(m):end);
%         Max_a=max(fa);
%         min_a=min(fa);
%         fn=(fa-min_a)/(Max_a-min_a);
%         dt=t(end)-t(end-1);
%         tn=dt.*(1:length(fn));
%         Dh=Fitres2(tn',fn);
%         Ds(1,m)=Dh.D*a;      
    end
end

D=mean(Ds);

%%

fcut=fn(255:350);
t_cut=tn(255:350);
t_cut_sc=t_cut-min(t_cut);

figure(2)
plot(t_cut_sc,fcut)

Fitres2(t_cut_sc',fcut)



