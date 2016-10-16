# Team3 - icv-m1-project - TrafficSignDetection
Introduction to Human and Computer Vision project - week 1

## Task 1 - statistics
Extract statistics of the bounding boxes of the dataset (size, form factor, filling ratio, and frequency of appearance of each class.
How to run it:
```
task1 (pathGt, pathMask)
```
Parameters:

**pathGt:** Folder where the dataset ground truth are stored.

**pathMask:** Folder where the dataset masks are stored.

## Task 2 - Dataset Split
This will split the dataset in two sets, train and validation, and store each set in a different folder. The train and validation sets have a 70% and 30% of samples respectively. The labels are evenly distributed.
How to run it:
```
task2(pathGt, pathImg, pathMask, pathSplit)
```
Parameters:

**pathGt:** Folder where the dataset ground truth are stored.

**pathImg:** Folder where the dataset images are stored.

**pathMask:** Folder where the dataset masks are stored.

**pathSplit:** Folder where the two sets will be created.

## Task 3 - How to obtain the best threshold
different threshold computation methods have been developed: 

### **findTh_mask_normRGB.m**
 finds a threshold for each image and then computes the mean of the thresholds to obtain the final threshold. To compute the threshold the following steps are done: **(1)** perform RGB normalization of the original RGB image; **(2)** get the set of pixels within the; **(3)** compute the minimum of the set on the red channel (for red signs) or on the blue channel (for the blue signs); **(4)** compute the mean of the remaining channels within the set.
How to run it:
```
findTh_mask_normRGB(path_to_train, flag) 
```
 Parameters:
 
**path_to_train:** path to the training images

**flag** (accepted values: ‘normRGB’, ‘RGB, ‘histEq’): type of preprocessing

    

### **findTh_mask_hsv.m**
This method will try different threshold combinations in the HSV and store the performance results of each combination in a txt file *‘hsv_train.txt’*.
How to run it: 
```
findTh_mask_hsv(path_to_train) 
```
Parameters:

**path_to_train: ** path to the training images

### **findTh_lab**
This method will try different threshold combinations in the CIELAB color space and store the performance results of each combination in a txt file ‘lab_train.txt’.
How to run it:
```
findTh_lab(path_to_train) 
```
Parameters:

**path_to_train:** path to the training images

### **getHistograms**
This file will get all the signs and background normalized histograms, separated by color spaces. The aim of this function is to use that histograms info for posterior image thresholding. This function can take around 30 minutes to complete.
How to run it:
```
getHistograms( destPath, groups, numChannels, samplingRate)
```
Parameters:

**destPath:** path where the histograms will be saved

**gorups:** .mat file generated in task2 containing training data

**numChannels:** allows to join 3 channels to 1

**samplingRate:** allows to downsample the channels 


### **Hist_thres**
This file will do a brute force search of best configuration for each sign class combining color space, histogram smoothness and threshold width for each histogram peak. The generated data will be saved in a file for posterior analysis. Be careful, this function can take around 13 hours to complete.
How to run it:
```
Hist_thres( samplingRate, directory, signalsHistPath )
```
Parameters:

**samplingRate:** allows to downsample the channels

**directory:** validation split directory

**signalsHistPath:** directory containing data from getHistograms

### **final_thresh**
This file is a prototype, it shows the results of applying to each validation image the best segmentation configuration extracted from Hist_thres. Due to the obvious bad results of that method we don’t even implement the correct parametrization neither get the performance evaluation .
How to run it: set the threshold data and execute the command:
```
final_thresh( samplingRate,directory, signalsHistPath)
```
Parameters:

**samplingRate:** allows to downsample the channels

**directory:** validation split directory

**signalsHistPath:** directory containing data from getHistogram.

### **plots**
This function shows the ROC & Precision/Recall plots for each sign type, joined by the different color spaces and modifying the smoothness of the histograms.
How to run it:
```
plots(results_histograms_path)
```
Parameters:

**results_histograms_path:** path of generated data by Hist_thres function.


## Task 4 - How to Evaluate the Segmentation
This will run all the images of the validation set and print the final performance metrics obtained.
To evaluate the segmentation one must run the function:
```
TrafficSignDetection(directory, pixel_method)
```
Parameters:

**directory:** Folder where the validation set is stored.

**pixel_method:** Color space used. (‘rgb’, ‘normrgb’, ‘hsv’, ‘lab’)

### **How to run the Test**
To generate the pixel Segmentation for each test image one must run the function:
```
TrafficSignDetection_test(input_dir, output_dir,pixel_method)
```
Parameters:

**input_dir:** folder where the test images are stored.

**output_dir:** folder where the segmentated test images will be stored.

**pixel_method:** Color space used for segmentation. (‘rgb’, ‘normrgb’, ‘hsv’, ‘lab’)


## Task 5 - Luminance normalization
We implemented the Histogram Equalization, it follow the next steps: **(1)** Convert the RGB image into HSV; **(2)** Histogram Equalization over the V channel (luminance); **(3)** Convert the image back to RGB.
We tried to find the best threshold using the images with histogram equalization.
How to run it:
```
findTh_mask_normRGB(path_to_train, flag) 
```
Parameters:
**path_to_train:** path to the training images

**flag:** it MUST be set to 'histEq'

The histogram equalization algorithm by itself can also be run typing:
```
histogramEqualization(im)
```
Parameters:

**im:** image to be processed







