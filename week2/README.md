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
## Task 3 - Improving results on color segmentation

This function improves the previous color-space components based segmentation. Removes noise and fill gaps of the undetected elements inside the signals.

The comments include functions whose goal is to complete broken edges of the signals. These functions increases false positive detections and reduces F1-score for now, although, the recall increases considerably. We think that this can be useful on the next weeks.
How to run it:
```
task3( pixelCandidates, element)
```
Parameters:

**pixelCandidates:** BW image of previous color-space components based segmentation.

**element:** Structural element to remove the noise

## Task 4 - Histogram Back Projection
How to generate histograms:

```
task4( directory, bins )
```
Parameters:

**directory**: Path were the training images are stored.
**bins**: Number of bins of the generated histograms.

File to try different thresholds:
```
find_th_hist(directory)
```

Parameters:

**directory**: Path were the training images are stored.

To use the created histograms for evaluating just call TrafficSignDetection with 'hbp' as the **pixel_method** argument.