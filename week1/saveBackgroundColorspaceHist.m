function [ yHist, xHist] = saveBackgroundColorspaceHist(colorSpace, destPath, groups)
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
           
           yHist = addImgToHist(yHist, img);
       end       
    end
    
    yHist(1) = yHist(2);
    %yHist(256,:) = yHist(255,:);
    yHist(:) = yHist(:)/sum(yHist(:));
%     for j=1:3
%         
%         xHist(1:end,j) = 0:(size(xHist,1)-1);
%     end
    
    save(strcat(destPath, '/', colorSpace, '_yHist.mat'), 'yHist');
    save(strcat(destPath, '/', colorSpace, '_xHist.mat'), 'xHist');

%     for i=2:size(imgPaths,1)
%         mask = imread(maskPaths(i,:))==0;
%         
%         img = imread(imgPaths(i,:));
%         img = deleteElements(img, mask);
%         if strcmp(colorSpace, 'ycbcr')
%             img = rgb2ycbcr(img);
%         elseif strcmp(colorSpace, 'cielab')
%             colorTransform = makecform('srgb2lab');
%             img = applycform(img, colorTransform);
%         elseif strcmp(colorSpace, 'hsv')
%             img = rgb2hsv(img);
%         elseif strcmp(colorSpace, 'xyz')
%             img = rgb2xyz(img);
%         end
%         
%         yHist = addImgToHist(yHist, img);        
%     end
%     
%     yHist(1,:) = yHist(2,:);
%     yHist(256,:) = yHist(255,:);
%     
%     for i=1:size(imgBase,3)
%         yHist(:,i) = yHist(:,i)/sum(yHist(:,i));
%         xHist(1:end,i) = 0:(size(xHist,1)-1);
%     end
%     
%     save(strcat(destPath,'/', colorSpace, '_yHist.mat'), strcat(colorSpace, '_yHist'));
%     save(strcat(destPath,'/', colorSpace, '_xHist.mat'), strcat(colorSpace, '_xHist'));
        
end

