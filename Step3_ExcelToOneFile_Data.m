% Number of file
clc;
clear;
close all;
N = 16; % Number file of dataset input
tile = ["vec_SNRdB"  "vec_IthdB" "vec_K" "vec_N" "vec_beta" "vec_alpha" "vec_phi" "vec_ome"...
    "vec_x_U1" "vec_y_U1" "vec_x_U2" "vec_y_U2" "vec_x_R" "vec_y_R" "vec_x_D" "vec_y_D" "vec_Sim_U1" "vec_Sim_U2" "vec_Sim_SUM"];
sum = [];
sum = [sum,tile];
for ii = 1:N
    file = sprintf('DataOutput%d.csv',ii);
    data = readmatrix(file,'Range',1);
    sum  = [sum;data];
end
writematrix(sum,'500_Dataset.csv') % Put name of dataset
