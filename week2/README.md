Folder for the second week.

Tasks:

1- Implement custom morphology operators.
2- Test these operators
3- Improve the segmentation with morphology.
4- Implement histogram back-projection.
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

# Team3 - icv-m1-project - TrafficSignDetection
Introduction to Human and Computer Vision project - week 2

## Task 1 - Ditale & Erosion implementaion
Compute the dilation & erosion of a given image.
How to run it:
```
my_imdilate (im, se)
my_imerode (im, se)
```
Parameters:

**im:** grayscale or BW image

**se:** structuring element represented as a logical matrix

###Check correctness of the results
The function compares the results obtained with the matlab implementation and our implementation
How to run it:
```
check_correctness(im, se, type)
```
Parameters:
**im:** grayscale or BW image to be tested
**se:** structuring element represented as a logical matrix
**type:** (accepted values: 'dilate' or 'erode') string indicating the type of test

## Task 2 - Comparison of the computational efficiency
The script measures the computation time of the maltab functions *imdilate* and *imerode* and the time of the developed functions *my_imerode* and *my_imdilate*.
Run the script:
```
time_profile
```






