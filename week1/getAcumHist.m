function [ yHist, xHist] = getAcumHist( imgPaths, maskPaths, colorSpace)
%   expects a lists of rgb image paths and the correlative mask paths of
%   desired element to include into the acummulated histogram. Also gets a
%   colorSpace value to get the histogram based on that defined space.
    colorSpace = lower(colorSpace);
    
    imgBase = imread(imgPaths(1,:));
    yHist = zeros(256, size(imgBase, 3));
    xHist = zeros(256, size(imgBase, 3));

    for i=2:size(imgPaths,1)
        mask = imread(maskPaths(i,:))>0;
        
        img = imread(imgPaths(i,:));
        img = deleteElements(img, mask);
        if strcmp(colorSpace, 'ycbcr')
            img = rgb2ycbcr(img);
        elseif strcmp(colorSpace, 'cielab')
            colorTransform = makecform('srgb2lab');
            img = applycform(img, colorTransform);
        elseif strcmp(colorSpace, 'hsv')
            img = rgb2hsv(img);
        elseif strcmp(colorSpace, 'xyz')
            img = rgb2xyz(img);
        end
        
        yHist = addImgToHist(yHist, img);        
    end
    
    yHist(1,:) = yHist(2,:);
    yHist(256,:) = yHist(255,:);
    
    for i=1:size(imgBase,3)
        yHist(:,i) = yHist(:,i)/sum(yHist(:,i));
        xHist(1:end,i) = 0:(size(xHist,1)-1);
    end
    
        
end

