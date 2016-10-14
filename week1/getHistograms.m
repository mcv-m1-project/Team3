function [ output_args ] = getHistograms( destPath, groups, numChannels, samplingRate)
    colorSpaces = [{'ycbcr'}; {'rgb'}; {'xyz'}; {'cielab'}; {'hsv'}];
    
    for i=1:size(colorSpaces,1)
        getSignalHist(colorSpaces{i}, strcat(destPath, '_signal'), groups, numChannels, samplingRate);
        getBackgroundHist(colorSpaces{i}, strcat(destPath, '_background'), groups, numChannels, samplingRate);
    end
end


function [ yHist, xHist] = getBackgroundHist(colorSpace, destPath, groups, numChannels, samplingRate)
%   expects a lists of rgb image paths and the correlative mask paths of
%   desired element to include into the acummulated histogram. Also gets a
%   colorSpace value to get the histogram based on that defined space.
    mkdir(destPath);
    colorSpace = lower(colorSpace);
    
    imgBase = imread(groups{1}{1}{1});
    yHist = zeros(512, 1);
    xHist = zeros(512, 1);
    xHist(1:512) = 0:511;
    
    for i=1:size(groups,1)
       group = groups{i};
              
       for j=1:size(group,1)
           picture = group{j};
           img = imread(group{j}{1});
           mask = imread(group{j}{2})==0;
           img = deleteElements(img, mask);
           
           if strcmp(colorSpace, 'ycbcr')
               img = rgb2ycbcr(img);
           elseif strcmp(colorSpace, 'cielab')
               colorTransform = makecform('srgb2lab');
               img = applycform(img, colorTransform);
           elseif strcmp(colorSpace, 'hsv')
               img = rgb2hsv(img);
               cImg = cImg .* 255;
           elseif strcmp(colorSpace, 'xyz')
               img = rgb2xyz(img);
               cImg = cImg .* 255;
           end
           
           yHist = addImgToHist(yHist, img, numChannels, samplingRate);
       end       
    end

    for j=1:size(xHist, 2)
        yHist(1,j) = yHist(2,j);
        yHist(:,j) = yHist(:,j)/sum(yHist(:,j));
        xHist(1:end,j) = 0:(size(xHist,1)-1);
    end
    
    save(strcat(destPath, '/', colorSpace, '_yHist.mat'), 'yHist');
    save(strcat(destPath, '/', colorSpace, '_xHist.mat'), 'xHist');
        
end

function [ output_args ] = getSignalHist( colorSpace, destPath, groups, numChannels, samplingRate)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    colorSpace = lower(colorSpace);
    
    mkdir(destPath);
    
    for i=1:size(groups,1)
       mkdir(strcat(destPath,'/', int2str(i)));
       group = groups{i};
       
       if(numChannels == 1)
           yHist = zeros((256/samplingRate)^3, 1);
           xHist = zeros((256/samplingRate)^3, 1);
       else 
           yHist = zeros((256/samplingRate), 3);
           xHist = zeros((256/samplingRate), 3);
       end
       
       for j=1:size(group,1)
           picture = group{j};
           img = imread(group{j}{1});
           mask = imread(group{j}{2})>0;
           for k=1:size(picture{3},1)
               bbox = picture{3}{k};
               cImg = img(uint16(bbox{1}):uint16(bbox{3}), uint16(bbox{2}):uint16(bbox{4}), :);
               cMask = mask(uint16(bbox{1}):uint16(bbox{3}), uint16(bbox{2}):uint16(bbox{4}));
                          
               cImg = deleteElements(cImg, cMask);
               
               if strcmp(colorSpace, 'ycbcr')
                   cImg = rgb2ycbcr(cImg);
               elseif strcmp(colorSpace, 'cielab')
                   colorTransform = makecform('srgb2lab');
                   cImg = applycform(cImg, colorTransform);
               elseif strcmp(colorSpace, 'hsv')
                   cImg = rgb2hsv(cImg);
                   cImg = cImg .* 255;
               elseif strcmp(colorSpace, 'xyz')
                   cImg = rgb2xyz(cImg);
                   cImg = cImg .* 255;
               end
        
               
               yHist = addImgToHist(yHist, cImg, numChannels, samplingRate);
           end           
       end
              
       for j=1:size(xHist, 2)
           yHist(1,j) = yHist(2,j);
           yHist(:,j) = yHist(:,j)/sum(yHist(:,j));
           xHist(1:end,j) = 0:(size(xHist,1)-1);
       end
       
       save(strcat(destPath,'/', int2str(i), '/', colorSpace, '_yHist.mat'), 'yHist');
       save(strcat(destPath,'/', int2str(i), '/', colorSpace, '_xHist.mat'), 'xHist');
       
    end
end

function [ img ] = deleteElements( img, mask )
%   expects one image and a mask of logical values where value 0 mean
%   delete pixel
    mask = mask >0 ;
    mask = uint8(mask);
    
    for i=1:size(img,3) 
        img(:,:,i) = img(:,:,i).*mask(:,:);
    end
end


function [ acumHist ] = addImgToHist( acumHist, img, numChannels, samplingRate )
%   expects one hist initialized usually from previous image and another
%   image usually in the same color space  
    if numChannels == 1
        img2 = uint16(zeros(size(img,1),size(img,2),1));
        img2(:,:) = img(:,:,1)/samplingRate*(256/samplingRate)^2+img(:,:,2)/samplingRate*(256/samplingRate)+img(:,:,3)/samplingRate;
        [yChannel x] = histcounts(img2, (256/samplingRate)^3);
        acumHist(:) = acumHist(:) + yChannel(:);
    else
        [yChannel_1 x] = histcounts(img(:,:,1), 256);
        [yChannel_2 x] = histcounts(img(:,:,1), 256);
        [yChannel_3 x] = histcounts(img(:,:,1), 256);
        
        acumHist(:,1) = acumHist(:,1) + yChannel_1(:);
        acumHist(:,2) = acumHist(:,2) + yChannel_2(:);
        acumHist(:,3) = acumHist(:,3) + yChannel_3(:);
    end
end



