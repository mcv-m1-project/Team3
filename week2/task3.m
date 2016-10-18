function [pixelCandidates] = task3( pixelCandidates )
    
  
    %hole filling
    pixelCandidates = imfill(pixelCandidates,'holes');
    %remove noise ---> Opening+Closing = [(erode+dilate)+(dilate+erode)]
    ee=strel('diamond',4);
    pixelCandidates = imopen(pixelCandidates,ee);
    pixelCandidates = imclose(pixelCandidates,ee);
    
   
    
end

