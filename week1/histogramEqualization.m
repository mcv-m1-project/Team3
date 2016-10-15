function [ output_args ] = histogramEqualization( I )
% histogramEqualization
%params:    I: image
%return:    image with histogram equalization

    Ieq = rgbHistEq(I);
    
    output_args = Ieq;
      
end

function [ output_args ] = rgbHistEq ( image )
% Histogram equalization of an RGB image
%params:    image: image to be equalized
%return:    image with histogram equalization
    
    % Convert the image into hsv color space
    Ic = rgb2hsv(image);
    % do the histogram equalization of the luminance channel
    Ic(:,:,3) = histeq(Ic(:,:,3));
    % convert the image into rgb
    Irgb = hsv2rgb(Ic);
    
    output_args = Irgb;
end 

