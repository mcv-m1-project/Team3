function [pixelCandidates] = task3( pixelCandidates, element)
    
%     ee=strel('line',7,0);
%     pixelCandidates = imclose(pixelCandidates,ee);
%     ee=strel('line',7,60);
%     pixelCandidates = imclose(pixelCandidates,ee);
%     ee=strel('line',7,-60);
%     pixelCandidates = imclose(pixelCandidates,ee);
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
            
    %ee=strel('diamond',6);
    pixelCandidates = imopen(pixelCandidates,element);
    pixelCandidates = imclose(pixelCandidates,element);
    

    
     %pixelCandidates = imfill(pixelCandidates,'holes');
    
 %   pixelCandidates = xor(bwareaopen(pixelCandidates,800),  bwareaopen(pixelCandidates,20000));
    
end

