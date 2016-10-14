function [ norm ] = NormRGB( im )
%NORMRGB Normalizes an RGB image
%   im must be double

    % normalize rgb (add small constant to avoid division by zero)
    norm_r = im(:,:,1)./(im(:,:,1)+im(:,:,2)+im(:,:,3)+0.0001);
    norm_g = im(:,:,2)./(im(:,:,1)+im(:,:,2)+im(:,:,3)+0.0001);
    norm_b = im(:,:,3)./(im(:,:,1)+im(:,:,2)+im(:,:,3)+0.0001);
    
    norm(:,:,1) = norm_r;
    norm(:,:,2) = norm_g;
    norm(:,:,3) = norm_b;

end

