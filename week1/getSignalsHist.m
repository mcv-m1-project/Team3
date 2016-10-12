function [ output_args ] = getSignalsHist( colorSpace, destPath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    colorSpace = lower(colorSpace);
    load('groups.mat')
    
    mkdir(destPath);
    
    for i=1:size(groups,1)
       mkdir(strcat(destPath,'/', int2str(i)));
       group = groups{i};
       
       yHist = zeros(256, 3);
       xHist = zeros(256, 3);
       
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
               elseif strcmp(colorSpace, 'xyz')
                   cImg = rgb2xyz(cImg);
               end
        
               
               yHist = addImgToHist(yHist, cImg);
           end           
       end
       
       yHist(1,:) = yHist(2,:);
       yHist(256,:) = yHist(255,:);
       
       for j=1:3
           yHist(:,j) = yHist(:,j)/sum(yHist(:,j));
           xHist(1:end,j) = 0:(size(xHist,1)-1);
       end
       
       save(strcat(destPath,'/', int2str(i), '/', colorSpace, '_yHist.mat'), 'yHist');
       save(strcat(destPath,'/', int2str(i), '/', colorSpace, '_xHist.mat'), 'xHist');
       
    end


end

