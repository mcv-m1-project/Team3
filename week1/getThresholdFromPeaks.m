function [ th ] = getThresholdFromPeaks( peaks, margin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    th = zeros(size(peaks,1), size(peaks,2), 2);
    for i=1:size(peaks,1)
       for j=1:size(peaks,2)
          th(i, j, 1) = peaks(i, j) - margin;
          th(i, j, 2) = peaks(i, j) + margin; 
       end
    end
end

