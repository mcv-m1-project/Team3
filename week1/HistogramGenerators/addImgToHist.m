function [ hist ] = addImgToHist( hist, img )
%   expects one hist initialized usually from previous image and another
%   image usually in the same color space
    for i=1:size(img,3)
       channel = img(:,:,i);
       [yChannel x] = imhist(channel);
       hist(:, i) = hist(:, i) + yChannel(:);
    end    
end

