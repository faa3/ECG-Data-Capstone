# ECG-Data-Capstone
### ECGtoMatrix.m
The purpose of this file is to preprocess ECG data into numerical arrays. The file assume that data is in the h5 format, and the ECG is extracted from the Lead 1. To reproduce this code, change the variable "files" to the directory of your files. This code preprocess signal data using STFT and Hilber trabsform interpolation. Note: the JETCodeExtract.m performs the same functions as this file but for the JET data.

###PatientAnalysis.ipynb
Given heartbeat arrays, this python script computes pairwise distances among heartbeat data per patient. The file also contains functions that compute the MDS and Kmeans analysis for visualization purposes. 
