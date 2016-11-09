function [pixelCandidates] = morf( pixelCandidates, element)
    
    global RESCALE;
    ee=strel('line',7*RESCALE,0);
    pixelCandidates = imclose(pixelCandidates,ee);
    ee=strel('line',7*RESCALE,60);
    pixelCandidates = imclose(pixelCandidates,ee);
    ee=strel('line',7*RESCALE,-60);
    pixelCandidates = imclose(pixelCandidates,ee);
% 
%     ee=strel('line', 20, 0);
%     pixelCandidates = imdilate(pixelCandidates,ee);
%     pixelCandidates = imerode(pixelCandidates,ee);
%     
%     ee=strel('line', 20, 90);
%     pixelCandidates = imdilate(pixelCandidates,ee);
%     pixelCandidates = imerode(pixelCandidates,ee);
%     
    %hole filling
    pixelCandidates = imfill(pixelCandidates,'holes');
    %remove noise ---> Opening+Closing = [(erode+dilate)+(dilate+erode)]
            
    pixelCandidates = imopen(pixelCandidates,element);
    pixelCandidates = imclose(pixelCandidates,element);
    
end



