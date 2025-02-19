function [sub] = Get_data(sw,data)
datasample = size(data,1);
% vector input
vec_SNRdB = [];
vec_IthdB = [];
vec_K = [];
vec_N = [];
vec_beta = [];
vec_alpha = [];
vec_phi = [];
vec_ome = [];
vec_x_U1 = [];
vec_y_U1 = [];
vec_x_U2 = [];
vec_y_U2 = [];
vec_x_R = [];
vec_y_R = [];
vec_x_D = [];
vec_y_D = [];

vec_Sim_U1 = [];
vec_Sim_U2 = [];
vec_Sim_SUM= [];


%% Location of elements in Secondary network.
sigma2 = 1;
pathloss = @(x) 10^3 * x^(-3);
distance = @(x,y,z,t) sqrt((y-x)^2 +(t-z)^2);
x_S = 0;
y_S = 0;
iteration = 1e5;
%%
for aa = 1:datasample
    %         fprintf('Running %d per %d \n',ii,datasample);
    
    SNRdB       = data(aa,1);
    IthdB      = data(aa,2);
    K           = data(aa,3);
    N           = data(aa,4);
    beta        = data(aa,5);
    alpha       = data(aa,6);
    phi         = data(aa,7);
    ome         = data(aa,8);
    x_U1        = data(aa,9);
    y_U1        = data(aa,10);
    x_U2        = data(aa,11);
    y_U2        = data(aa,12);
    x_R         = data(aa,13);
    y_R         = data(aa,14);
    x_D         = data(aa,15);
    y_D         = data(aa,16);
    
    
    %% Distanc from X to Y
    d_SU1 = distance(x_S,x_U1,y_S,y_U1);
    d_SU2 = distance(x_S,x_U2,y_S,y_U2);
    d_SD  = distance(x_S,x_D,y_S,y_D);
    
    d_SR  = distance(x_S,x_R,y_S,y_R);
    d_RU1 = distance(x_R,x_U1,y_R,y_U1);
    d_RU2 = distance(x_R,x_U2,y_R,y_U2);
    
    Omega_sr = pathloss(d_SR);
    Omega_su1 = pathloss(d_SU1);
    Omega_su2 = pathloss(d_SU2);
    Omega_sd = pathloss(d_SD);
    Omega_ru1 = pathloss(d_RU1);
    Omega_ru2 = pathloss(d_RU2);
    
    
    SNR = 10^(SNRdB/10);
    Ith = 10^(IthdB/10);
    
    
    %Outage of user 2
    [Sim_U1,Sim_U2] = ErgodicSim(SNR,sigma2,iteration,Omega_sr,Omega_ru1,Omega_ru2,Omega_su1,Omega_su2,Omega_sd,...
        K,N,beta,Ith,1-alpha,alpha,phi,ome);

    % Normalize input and output
    Temp = Sim_U1 + Sim_U2;
    SNRdB   = (SNRdB - 0)/(50 -0);
   
    IthdB   = (IthdB - 5)/(20 - 5);
    K       = (K - 50)/(250 - 50);
    N       = (N - 1)/(10 - 1);
    beta    = (beta - 0)/(1 - 0);
    alpha   = (alpha - 0.05)/(0.45 - 0.05);
    phi     = (phi - 0)/(0.1 - 0);
    ome     = (ome - 0)/(1 - 0);
    x_U1    = (x_U1 - 10)/(40 - 10);
    y_U1    = (y_U1 - 0)/(20 - 0);
    
    x_U2    = (x_U2 - 80)/(100 - 80);
    y_U2    = (y_U2 - 0)/(20- 0);
    
    x_R     = (x_R - 40)/(80 - 40);
    y_R     = (y_R - 0)/(20 - 0);
    
    x_D     = (x_D - 0)/(40 - 0);
    y_D     = (y_D - 0)/(60 - 0);
    
   
    
    

    % export output paramter;
    if  isempty(Sim_U2)||isnan(Sim_U2)||isempty(Sim_U1)||isnan(Sim_U1)
    else
    % condition for value of OP
    
    vec_SNRdB = [vec_SNRdB;SNRdB];
    vec_IthdB = [vec_IthdB;IthdB];
    vec_K = [vec_K;K];
    vec_N = [vec_N;N];
    vec_beta = [vec_beta;beta];
    vec_alpha = [vec_alpha;alpha];
    vec_phi = [vec_phi;phi];
    vec_ome = [vec_ome;ome];
    vec_x_U1 = [vec_x_U1;x_U1];
    vec_y_U1 = [vec_y_U1;y_U1];
    vec_x_U2 = [vec_x_U2;x_U2];
    vec_y_U2 = [vec_y_U2;y_U2];
    vec_x_R = [vec_x_R;x_R];
    vec_y_R = [vec_y_R;y_R];
    vec_x_D = [vec_x_D;x_D];
    vec_y_D = [vec_y_D;y_D];
    
    Sim_U1  = (Sim_U1 - 1e-3)/(14 - 1e-3);
    Sim_U2  = (Sim_U2 - 1e-3)/(4- 1e-3);
    Sim_SUM = (Temp - 1e-3)/(17 - 1e-3);
    
    vec_Sim_U1  = [vec_Sim_U1; Sim_U1];
    vec_Sim_U2  = [vec_Sim_U2; Sim_U2];
    vec_Sim_SUM = [vec_Sim_SUM; Sim_SUM];
    end
end


sub = [vec_SNRdB  vec_IthdB vec_K vec_N vec_beta vec_alpha vec_phi vec_ome...
    vec_x_U1 vec_y_U1 vec_x_U2 vec_y_U2 vec_x_R vec_y_R vec_x_D vec_y_D vec_Sim_U1 vec_Sim_U2 vec_Sim_SUM];
if sw == 1
    writematrix(sub,'DataOutput1.csv');
elseif sw == 2
    writematrix(sub,'DataOutput2.csv');
elseif sw == 3
    writematrix(sub,'DataOutput3.csv');
elseif sw == 4
    writematrix(sub,'DataOutput4.csv');
elseif sw == 5
    writematrix(sub,'DataOutput5.csv');
elseif sw == 6
    writematrix(sub,'DataOutput6.csv');
elseif sw == 7
    writematrix(sub,'DataOutput7.csv');
elseif sw == 8
    writematrix(sub,'DataOutput8.csv');
elseif sw == 9
    writematrix(sub,'DataOutput9.csv');
elseif sw == 10
    writematrix(sub,'DataOutput10.csv');
elseif sw == 11
    writematrix(sub,'DataOutput11.csv');
elseif sw == 12
    writematrix(sub,'DataOutput12.csv');
elseif sw == 13
    writematrix(sub,'DataOutput13.csv');
elseif sw == 14
    writematrix(sub,'DataOutput14.csv');
elseif sw == 15
    writematrix(sub,'DataOutput15.csv');
else
    writematrix(sub,'DataOutput16.csv');
end

end




