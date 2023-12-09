# ECG-Data-Capstone
### ECGtoMatrix.m
The purpose of this file is to preprocess ECG data into numerical arrays. The file assume that data is in the h5 format, and the ECG is extracted from the Lead 1. To reproduce this code, change the variable "files" to the directory of your files. This code preprocess signal data using STFT and Hilber trabsform interpolation. Note: the JETCodeExtract.m performs the same functions as this file but for the JET data.

### DeliverableFilesCode.ipynb
This python script contains the computations of the preliminary analysis of the data including barycenter computations per file, and per patien, as well as the computation of pairwise distances for selected files and patients. 

### PatientAnalysis.ipynb
Given heartbeat arrays, this python script computes pairwise distances among heartbeat data per patient. The file also contains functions that compute the MDS and Kmeans analysis for visualization purposes. 

### MDSandKmeansAnalysisCode.m
Similarly to PatientAnalysis.ipynb, this Matlab script will receive as input precomputed distance matrices and will return the MDS embedding of data as well as running a Kmeans algorithm to detect clusters in the MDS embedding. The advantage of this file vs. PatientAnalysis.ipynb is that in this file, you can also contain code that produces better visualization of data clusters as well as plotting capabilities.

