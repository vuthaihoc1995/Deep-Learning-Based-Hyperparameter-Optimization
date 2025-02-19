% Number of file
N = 16;
tile = ["vec_M" "vec_N" "vec_K" "vec_xP" "vec_yP" "vec_xD" "vec_yD" "vec_PdB"...
    "vec_SNRdB" "vec_IthdB" "vec_alpha1" "vec_alpha3" "vec_epsilon" "vec_Rate1" "vec_Rate2"...
    "OP_U1_time1" "OP_U1_time2" "OP_U2_RRS" "OP_U2_PRS" "OP_U2_ORS" "OP_U2_HRS"];
sum = [];
sum = [sum,tile];
for ii = 1:N
    file = sprintf('DataOutput%d.csv',ii);
    data = readmatrix(file,'Range',1);
    sum  = [sum;data];
end
writematrix(sum,'499K_Dataset.csv')