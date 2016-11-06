# Team3 - icv-m1-project - TrafficSignDetection
Introduction to Human and Computer Vision project - week 4

## Task 1 - Template matching using correlation


## Task 2 - Template matching using Distance Transform and chamfer distance

### Global Approach
The function used to use Template matching and chamfer distance to generate window candidates is MaskChamferWCandidates().
How to run it:
```
MaskChamferWCandidates( templates, dist )
```
Parameters:

**templates:** List of templates to be used. Each template must be binary.

**dist:** Distance Transform of the image of edges where we want to perform template matching.

It returns a list of all the Window Candidates found.

#### Remove Redundant Bounding Boxes (NMS)

In order to remove overlapping bounding boxes that are considered to be the same, the window candidates returned by the previus window are filtered.

```
min_nms( windowCandidates, threshold )
```
Parameters:

**windowCandidates:** List of windowCandidates.

**threshold:** Within all the window candidates that overlap more than the threshold, only the most similar to the template is kept.

### Chamfer Template Matching to Filter
Template matching with the chamfer distance can also be used to filter window candidates generated with another method.
```
filterCandidatesChamfer(  pixelCandidates, windowCandidates, templates, th )
```

Parameters:

**pixelCandidates:** Segmented pixels.

**windowCandidates:** List of window candidates to filter.

**templates:** List of templates to match against each window candidate.

**th:** All the window candidates with a similarity value (the lower the better) below this threshold will be kept.