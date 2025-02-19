% generate data sample without throughput
tic
clc, clear, close all
%
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
%
datasample = 10^6; 
%
parfor ii = 1:datasample
    fprintf('Running %d per %d \n',ii,datasample)
    	
    SNRdB       = randsample([0:5:50],1);
    IthdB       = randsample([5:5:20],1);
    K           = randsample([50:50:250],1);
    N           = randi([1,10],1); 
    beta        = randsample([0:0.1:1],1);
    alpha       = randsample([0.05:0.05:0.45],1);
    phi         = randsample([0:0.025:0.1],1);
    ome         = randi([0,1],1); 
    x_U1        = randsample([10:10:40],1); 
    y_U1        = randsample([0:5:20],1); 
    x_U2        = randsample([80:5:100],1);
    y_U2        = randsample([0:5:20],1); 
    x_R         = randsample([40:10:80],1); 
    y_R         = randsample([0:5:20],1); 
    x_D         = randsample([0:10:40],1); 
    y_D         = randsample([0:10:60],1); 

    %Save vector
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

end
sub = [vec_SNRdB  vec_IthdB vec_K vec_N vec_beta vec_alpha vec_phi vec_ome...
    vec_x_U1 vec_y_U1 vec_x_U2 vec_y_U2 vec_x_R vec_y_R vec_x_D vec_y_D];
csvwrite('datainput.csv',sub);
jj = toc;
ss=seconds(jj);
ss.Format = 'hh:mm:ss.SSS'









