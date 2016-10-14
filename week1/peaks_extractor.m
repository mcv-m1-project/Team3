%%Function used to extract the local maxima (peaks) from histograms. Later
%%these peaks will be used to find the threshold
function [locs_smooth] = peaks_extractor (yHist, smooth)
    [pks,locs] = findpeaks(yHist); %returns a vector with the local maxima (peaks).
    
    
    yHist_smooth=yHist;
    for z=1:smooth
        yHist_smooth=smooth(yHist_smooth); %smooths the data in the column vector using a moving average filter
    end
    [pks_smooth,locs_smooth] = findpeaks(yHist_smooth);
    
end