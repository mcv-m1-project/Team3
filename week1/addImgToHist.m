function [ acumHist ] = addImgToHist( acumHist, img )
%   expects one hist initialized usually from previous image and another
%   image usually in the same color space
%     for i=1:size(img,3)
%        
%     end   
    
    img2 = uint16(zeros(size(img,1),size(img,2),1));
    img2(:,:) = img(:,:,1)/32*8^2+img(:,:,2)/32*8+img(:,:,3)/32;
%        img2(:) = img(:,:,1)/32;
%        channel = img(:,:,i);
    [yChannel x] = histcounts(img2, 512);
    acumHist(:) = acumHist(:) + yChannel(:);
end

