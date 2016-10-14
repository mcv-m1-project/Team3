function [ output_args ] = task5( path )
% Task 5
%   

    I = imread(path);
    
    Ieq = rgbHistEq(I);
    
    imshow(Ieq);
    
end



function [ output_args ] = rgbHistEq ( image )
% Histogram equalization of an RGB image
%params:    image: image to be equalized
    
    % Convert the image into hsv color space
    Ic = rgb2hsv(image);
    % do the histogram equalization of the luminance channel
    Ic(:,:,3) = histeq(Ic(:,:,3));
    % convert the image into rgb
    Irgb = hsv2rgb(Ic);
    
    output_args = Irgb;
end 

