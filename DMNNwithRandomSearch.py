# -*- coding: utf-8 -*-
"""
Created on Thu Jul 15 01:48:42 2021

@author: Thai-Hoc Vu
"""
# # Turn on or turn off GPU (From line 8 to line 18)
# import os
# os.environ["CUDA_VISIBLE_DEVICES"]="-1"
# import tensorflow as tf
# a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
# b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
# c = tf.matmul(a, b)
# # Creates a session with log_device_placement set to True.
# config=tf.compat.v1.ConfigProto(log_device_placement=True)
# sess = tf.compat.v1.Session(config=config)
# config = tf.compat.v1.ConfigProto(device_count={'GPU':0})
# sess = tf.compat.v1.Session(config=config)


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from tensorflow import keras
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split
from keras.callbacks import EarlyStopping
import keras_tuner as kt


# Importing the dataset
dataset = pd.read_csv('500_Dataset.csv')
X = dataset.iloc[:, 0:16].values # get from 0 to 17
y = dataset.iloc[:, 16:19].values # get from 18 to 20

xtrain, xtest, ytrain, ytest = train_test_split(X, y, test_size=0.2)
n_inputs, n_outputs = xtrain.shape[1], ytrain.shape[1]

# Define function
def get_model(idx):
    model = keras.models.Sequential() # a basic feed-forward model
    model.add(keras.layers.Dense(16, input_shape = (n_inputs,)))
    ## hidden layer
    for i in range(idx.Int('num_layers',2,4)):
         model.add(keras.layers.Dense(units                 = idx.Int('Dense_' + str(i) + '_unit', min_value=20,max_value = 150, step= 10), 
                                      activation            = idx.Choice('Activation_'+ str(i) + '_unit' ,['elu','relu','selu',]),
                                      kernel_initializer    = idx.Choice('Kernel',['uniform','normal','he_uniform']),
                                      bias_initializer      = idx.Choice('Bias',['uniform','normal','he_uniform']),                                      ))
    # output layer
    model.add(keras.layers.Dense(n_outputs, activation = 'sigmoid'))
    ## compile model
    optimizer = keras.optimizers.Adam(idx.Choice('learning_rate',[1e-2,1e-3,1e-4]))
    model.compile(optimizer = optimizer, loss='mean_squared_error', metrics=['mse'])
    
    return model

# Main DCNN network
#Step 1: Search optimal value (i.e., the number of filter and kernel per each convolution and the number of neuron per each hidden layer)

tuner = kt.RandomSearch(get_model, objective = 'val_mse', max_trials = 900, executions_per_trial=3, directory='my_DNN',project_name='Optimal_DNN')
tuner.search_space_summary()
tuner.search(xtrain, ytrain,  epochs=10, validation_data=(xtrain, ytrain))

#Step 2: Export testing Network parameter
print('Hyperparameter optimal:') 
tuner.search_space_summary()
model = tuner.get_best_models()[0]
model.summary()

#Step 3: Training dataset
es = EarlyStopping(monitor='val_mse', mode='auto', verbose=0, patience=50, restore_best_weights=True)
history = model.fit(xtrain, ytrain,  epochs=3, validation_split=0.2, initial_epoch=0, callbacks=[es])
x_test = np.array(xtest)
y_pred = model.predict(x_test)

print('Root Mean Squared Error during training:', np.sqrt(mean_squared_error(ytest, y_pred))) 
plt.plot(history.history['loss'])
plt.plot(history.history['val_mse'])
plt.yscale('log')
plt.legend(loc='upper right')
plt.grid(True)
plt.ylabel('Estimator MSE')
plt.xlabel('Epochs')
plt.legend(['Train', 'Validation'], loc='upper right')
plt.show()

print(model.summary())

model.save('ErgodicCapacity_DNN.h5')

## LOAD MODEL and PREDEICT
new_model = keras.models.load_model('ErgodicCapacity_DNN.h5')

x_test = np.array(x_test)
y_pred = new_model.predict(x_test)
print('Root Mean Squared Error after training:', np.sqrt(mean_squared_error(ytest, y_pred))) 
