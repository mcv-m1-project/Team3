# Team3 - icv-m1-project - TrafficSignDetection
Introduction to Human and Computer Vision project - week 3

## Task 1 - Conected components

## Task 2 - Sliding Window
Compute the sliding window of the binary image
How to run it:
```
SlidingWindow( im, step, iWinPx, jWinPx, low_thr, high_thr )
```
Parameters:

**im:** target image (grayscale or logical)

**step:** stride of the sliding window

**iWinPx:** width of the window

**jWinPx:** height of the window

**low_thr:** lower boundary for detection

**high_thr:** upper boundary for detection

### Remove Redundant Bounding Boxes (NMS)
....

## Task 3 - Sliding Window with integral image
Compute the sliding window of an integral image (the method is faster than task2 and it gives the same output)
How to run it:
```
IntegralSlidingWindow( im, step, iWinPx, jWinPx, low_thr, high_thr )
```
Parameters:

**im:** target image (grayscale or logical)

**step:** stride of the sliding window

**iWinPx:** width of the window

**jWinPx:** height of the window

**low_thr:** lower boundary for detection

**high_thr:** upper boundary for detection

## Task 5 - Sliding Window with convolution
Compute the sliding window using the filling ratio feature using the convolution. First convolves by columns and the output result is convolved by rows.
How to run it:
```
convTask5( pixelCandidates, step, iWinPx, jWinPx, low_thr, high_thr )
```
Parameters:

**pixelCandidates:** target image (grayscale or logical)

**step:** stride of the sliding window

**iWinPx:** width of the window

**jWinPx:** height of the window

**low_thr:** lower boundary for detection

**high_thr:** upper boundary for detection






