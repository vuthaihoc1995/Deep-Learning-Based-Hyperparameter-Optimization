# -*- coding: utf-8 -*-
"""
Created on Sun Feb 28 22:57:04 2021

@author: van_nguyentoan
"""
import numpy as np
from tensorflow import keras
import time
# load model and predict
new_model = keras.models.load_model('ErgodicCapacity_DNN.h5')


# system parameter

SNRdB = [0,5,10,15,20,25,30,35,40,45,50]
IthdB   = (20-5)/(20-5)
K       = (150-50)/(250-50)
N       = (7-1)/(10-1) 
beta    = (0.6-0)/(1-0)
alpha   = (0.1-0.05)/(0.45-0.05)
phi     = (0.1-0)/(0.1-0)
ome     = (1-0)/(1-0)

x_U1    = (40-10)/(40 - 10)
y_U1    = (0 - 0)/(20 - 0 )

x_U2    = (80-80)/(100-80)
y_U2    = (20 - 0)/(20 - 0)

x_R     = (50-40)/(80-40)
y_R     = (0- 0)/(20 - 0)

x_D     = (40 - 0)/(40 - 0)
y_D     = (60 - 0)/(60 - 0)


U1 = [];
U2 = [];
ESC = [];

start_time = time.perf_counter() 
# network predict
for ii in range(len(SNRdB)):
    Input = [(SNRdB[ii]-0)/(50-0),IthdB,K,N,beta,alpha,phi,ome,x_U1,y_U1,x_U2,y_U2,x_R,y_R,x_D,y_D]
   
    
    x_sample = np.array(Input).reshape(1,len(Input))
    
    y_pred = new_model.predict(x_sample)
    
    # print('Predict EC for U1:',y_pred.reshape(-1)[0]*(14-0.001)+ 0.001)
    # print('Predict EC for U2:',y_pred.reshape(-1)[1]*(4-0.001)+ 0.001)
    # print('Predict ESC:',y_pred.reshape(-1)[2]*(17-0.001)+ 0.001)
    U1.append(y_pred.reshape(-1)[0]*(14-0.001)+ 0.001)
    U2.append(y_pred.reshape(-1)[1]*(4-0.001)+ 0.001)
    ESC.append(y_pred.reshape(-1)[2]*(17-0.001)+ 0.001)
    
end = time.perf_counter()
print("Execution time (S):",end - start_time) 

print('Predict EC for U1:', U1)
print('Predict EC for U2:', U2)
print('Predict ESC:',ESC) 

