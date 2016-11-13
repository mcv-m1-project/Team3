function [pixelCandidates]=kmeans (im)
% hsv = rgb2hsv(im);
% hueImage = hsv(:, :, 1);
% saturationImage = hsv(:, :, 2);
% valueImage = hsv(:, :, 3);
% bluePixels = hueImage > 0.56 & hueImage < 0.76 & valueImage < 0.8;
% RedPixels = valueImage < 0.8 & (hueImage > 0.96  | hueImage<0.04);
% otherPixels = (hueImage > 0.04 & hueImage < 0.56) |  (hueImage > 0.76 & hueImage <0.96);
% saturationImage(bluePixels) = saturationImage(bluePixels) * 3.5;
% saturationImage(RedPixels) = saturationImage(RedPixels) * 3.5;
% saturationImage(otherPixels) = 0;
% hsvImage = cat(3, hueImage, saturationImage, valueImage);
% rgbImage = hsv2rgb(hsvImage);
% rgbImage(find(rgbImage<0))=0;
% img=rgbImage;
% img=ceil(img);
% imshow(im);
% waitforbuttonpress;
% waitforbuttonpress;
img=double(im)./255;


% You can change the colors        
colors = [  0 0 0;
            0 0 1;  % Blue
            0 1 0;  % Green
            0 1 1;  
            1 0 0;  % Red
            1 0 1;   
            1 1 0;  
            1 1 1]; 


colors = [  0 0 0;
            0 0 0.5;
            0 0 1;  % Blue
            0 0.5 0;
            0 1 0;  % Green
            0 0.5 0.5;
            0 1 1;
            0.5 0 0;
            1 0 0;  % Red
            0.5 0 0.5;
            1 0 1; 
            0.5 0.5 0;
            1 1 0;  
            0.5 0.5 0.5;
            1 1 1]; 



% Find nearest neighbour color
list = double(reshape(img, [], 3)) ;
[~, IDX] = pdist2(colors, list, 'euclidean', 'Smallest', 1);
% IDX contains the indices to the nearest element


% Eventually build the masks
indices = reshape(IDX, [size(img,1), size(img,2)]);

imag(1:size(im,1), 1:size(im,2),1:3)=0;

        
% imag(:,:,3)=imag(:,:,3)+(indices==2);
% imag(:,:,2)=imag(:,:,2)+(indices==3);
% imag(:,:,2)=imag(:,:,2)+(indices==4);
% imag(:,:,3)=imag(:,:,3)+(indices==4);
% imag(:,:,1)=imag(:,:,1)+(indices==5);
% imag(:,:,1)=imag(:,:,1)+(indices==6);
% imag(:,:,3)=imag(:,:,3)+(indices==6);
% imag(:,:,1)=imag(:,:,1)+(indices==7);
% imag(:,:,2)=imag(:,:,2)+(indices==7);
% imag(:,:,1)=imag(:,:,1)+(indices==8);
% imag(:,:,2)=imag(:,:,2)+(indices==8);
% imag(:,:,3)=imag(:,:,3)+(indices==8);

 

            

            
         
% imag(:,:,3)=imag(:,:,3)+(indices==2)*0.5;
% imag(:,:,3)=imag(:,:,3)+(indices==3);
% imag(:,:,2)=imag(:,:,2)+(indices==4)*0.5;
% imag(:,:,2)=imag(:,:,2)+(indices==5);
% imag(:,:,2)=imag(:,:,2)+(indices==6)*0.5;
% imag(:,:,3)=imag(:,:,3)+(indices==6)*0.5;
% imag(:,:,2)=imag(:,:,2)+(indices==7);
% imag(:,:,3)=imag(:,:,3)+(indices==7);
% imag(:,:,1)=imag(:,:,1)+(indices==8)*0.5;
% imag(:,:,1)=imag(:,:,1)+(indices==9);
% imag(:,:,1)=imag(:,:,1)+(indices==10)*0.5;
% imag(:,:,3)=imag(:,:,3)+(indices==10)*0.5;
% imag(:,:,1)=imag(:,:,1)+(indices==11);
% imag(:,:,3)=imag(:,:,3)+(indices==11);
% imag(:,:,1)=imag(:,:,1)+(indices==12)*0.5;
% imag(:,:,2)=imag(:,:,2)+(indices==12)*0.5;
% imag(:,:,1)=imag(:,:,1)+(indices==13);
% imag(:,:,2)=imag(:,:,2)+(indices==13);
% imag(:,:,1)=imag(:,:,1)+(indices==14)*0.5;
% imag(:,:,2)=imag(:,:,2)+(indices==14)*0.5;
% imag(:,:,3)=imag(:,:,3)+(indices==14)*0.5;
% imag(:,:,3)=imag(:,:,3)+(indices==15);
% imag(:,:,1)=imag(:,:,1)+(indices==15);
% imag(:,:,2)=imag(:,:,2)+(indices==15);
% imshow(imag);
% waitforbuttonpress;
% waitforbuttonpress;


ima=(indices==8);
ima2=(indices==6);
ima3=(indices==2);
ima4=(indices==3);
ima5=(indices==9);
ima6=(indices==7);
pixelCandidates=ima+ima2+ima3+ima4+ima5+ima6;
