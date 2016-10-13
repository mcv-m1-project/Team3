function [ output_args ] = saveSignalColorspaceHist( colorSpace, destPath, groups)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    colorSpace = lower(colorSpace);
    
    mkdir(destPath);
    
    for i=1:size(groups,1)
       mkdir(strcat(destPath,'/', int2str(i)));
       group = groups{i};
       
       yHist = zeros(512, 1);
       xHist = zeros(512, 1);
       
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
        
               
               yHist = addImgToHist(yHist, cImg);
           end           
       end
       
       yHist(1) = yHist(2);
       yHist(:) = yHist(:)/sum(yHist(:));
       xHist(1:512) = 0:511;
       %yHist(256,:) = yHist(255,:);
       
%        for j=1:3
%            yHist(:,j) = yHist(:,j)/sum(yHist(:,j));
%            xHist(1:end,j) = 0:(size(xHist,1)-1);
%        end
       
       save(strcat(destPath,'/', int2str(i), '/', colorSpace, '_yHist.mat'), 'yHist');
       save(strcat(destPath,'/', int2str(i), '/', colorSpace, '_xHist.mat'), 'xHist');
       
    end


end

