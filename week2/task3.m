function [pixelCandidates] = task3( pixelCandidates )
    
    ee=strel('line',7,0);
    pixelCandidates = imclose(pixelCandidates,ee);
    ee=strel('line',7,60);
    pixelCandidates = imclose(pixelCandidates,ee);
    ee=strel('line',7,-60);
    pixelCandidates = imclose(pixelCandidates,ee);
    %hole filling
    pixelCandidates = imfill(pixelCandidates,'holes');
    %remove noise ---> Opening+Closing = [(erode+dilate)+(dilate+erode)]
    ee=strel('diamond',4);
    pixelCandidates = imopen(pixelCandidates,ee);
    pixelCandidates = imclose(pixelCandidates,ee);
    
 %   pixelCandidates = xor(bwareaopen(pixelCandidates,800),  bwareaopen(pixelCandidates,20000));
    
end

