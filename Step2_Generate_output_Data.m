% 100 * 100 m2 wireless sensor network deployment
% Density = 50 nodes
delete(gcp('nocreate'));
clc, clear, close all;
tic
% %%500K get the datainput and save in a 3D vector
% data(:,:,1) = readmatrix('datainput.csv','Range','1:31250');
% data(:,:,2) = readmatrix('datainput.csv','Range','31251:62500');
% data(:,:,3) = readmatrix('datainput.csv','Range','62501:93750');
% data(:,:,4) = readmatrix('datainput.csv','Range','93751:125000');
% 
% data(:,:,5) = readmatrix('datainput.csv','Range','125001:156250');
% data(:,:,6) = readmatrix('datainput.csv','Range','156251:187500');
% data(:,:,7) = readmatrix('datainput.csv','Range','187501:218750');
% data(:,:,8) = readmatrix('datainput.csv','Range','218751:250000');
% 
% data(:,:,9) = readmatrix('datainput.csv','Range','250001:281250');
% data(:,:,10) = readmatrix('datainput.csv','Range','281251:312500');
% data(:,:,11) = readmatrix('datainput.csv','Range','312501:343750');
% data(:,:,12) = readmatrix('datainput.csv','Range','343751:375000');
% 
% data(:,:,13) = readmatrix('datainput.csv','Range','375001:406250');
% data(:,:,14) = readmatrix('datainput.csv','Range','406251:437500');
% data(:,:,15) = readmatrix('datainput.csv','Range','437501:468750');
% data(:,:,16) = readmatrix('datainput.csv','Range','468751:500000');


% %% 1000K dataset
data(:,:,1) = readmatrix('datainput.csv','Range','1:62500');
data(:,:,2) = readmatrix('datainput.csv','Range','62501:125000');
data(:,:,3) = readmatrix('datainput.csv','Range','125001:187500');
data(:,:,4) = readmatrix('datainput.csv','Range','187501:250000');

data(:,:,5) = readmatrix('datainput.csv','Range','250001:312500');
data(:,:,6) = readmatrix('datainput.csv','Range','312501:375000');
data(:,:,7) = readmatrix('datainput.csv','Range','375001:437500');
data(:,:,8) = readmatrix('datainput.csv','Range','437501:500000');

data(:,:,9) = readmatrix('datainput.csv','Range','500001:562500');
data(:,:,10) = readmatrix('datainput.csv','Range','562501:625000');
data(:,:,11) = readmatrix('datainput.csv','Range','625001:687500');
data(:,:,12) = readmatrix('datainput.csv','Range','687501:750000');

data(:,:,13) = readmatrix('datainput.csv','Range','750001:812500');
data(:,:,14) = readmatrix('datainput.csv','Range','812501:875000');
data(:,:,15) = readmatrix('datainput.csv','Range','875001:937500');
data(:,:,16) = readmatrix('datainput.csv','Range','937501:1000000');

Clus = parcluster('local');
Clus.NumWorkers = 16;
poolobj = parpool(Clus, Clus.NumWorkers);
sub1 = 0;
parfor ii = 1:16
fprintf('Running %d per %d \n',ii,16)
[sub1] = Get_data(ii, data(:,:,ii));
end

delete(poolobj);
clear Clus 

aa = toc;
ss=seconds(aa);
ss.Format = 'hh:mm:ss.SSS'


