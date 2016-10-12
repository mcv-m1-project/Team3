function [ img ] = deleteElements( img, mask )
%   expects one image and a mask of logical values where value 0 mean
%   delete pixel

    mask = mask >0 ;
    mask = uint8(mask);
    
    for i=1:size(img,3) 
        img(:,:,i) = img(:,:,i).*mask(:,:);
    end
end

