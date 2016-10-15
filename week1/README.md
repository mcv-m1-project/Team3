# Team3 - icv-m1-project - TrafficSignDetection
Introduction to Human and Computer Vision project

### How to obtain the best threshold (training)
2 methods:
1. based on information (pixels) of the traffic signs area
    * findTh_mask_normRGB.m: finds a threshold for each image and then computes the mean of the thresholds to
      obtain the final threshold. To compute the threshold the following steps are done: (1) get the set of 
      pixels within the; (2) compute the minimum of the set on the red channel (for red signs) or on the blue
      channel (for the blue signs). 
    * findTh_mask_hsv.m:  
    * 
2. based on the  information (pixels) of the whole image
    *
    *
    *


### How to run the Validation

### How to run the Test
