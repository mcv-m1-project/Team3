function [pixelCandidates]=kmeans (im)
hsv = rgb2hsv(im);
hueImage = hsv(:, :, 1);
saturationImage = hsv(:, :, 2);
valueImage = hsv(:, :, 3);
bluePixels = hueImage > 0.56 & hueImage < 0.76 & valueImage < 0.8;
RedPixels = valueImage < 0.8 & (hueImage > 0.96  | hueImage<0.04);
otherPixels = (hueImage > 0.04 & hueImage < 0.56) |  (hueImage > 0.76 & hueImage <0.96);
saturationImage(bluePixels) = saturationImage(bluePixels) * 3.5;
saturationImage(RedPixels) = saturationImage(RedPixels) * 3.5;
saturationImage(otherPixels) = 0;
hsvImage = cat(3, hueImage, saturationImage, valueImage);
rgbImage = hsv2rgb(hsvImage);
rgbImage(find(rgbImage<0))=0;
img=rgbImage;
img=ceil(img);
% imshow(im);
% waitforbuttonpress;
% waitforbuttonpress;

% You can change the colors        
colors = [  0 0 0;
            0 0 1;  % Blue
            0 1 0;  % Green
            0 1 1;  
            1 0 0;  % Red
            1 0 1;   
            1 1 0;  
            1 1 1]; 


% Find nearest neighbour color
list = double(reshape(img, [], 3)) ;
[~, IDX] = pdist2(colors, list, 'euclidean', 'Smallest', 1);
% IDX contains the indices to the nearest element


% Eventually build the masks
indices = reshape(IDX, [size(img,1), size(img,2)]);

ima=(indices==5);
ima2=(indices==2);
pixelCandidates=ima+ima2;
