function [ output_args ] = Hist_thres(samplingRate,directory, signalsHistPath)
%HIST_THRES Summary of this function goes here
%   Detailed explanation goes here
addpath('evaluation/');
groups={'A','B','C','D','E','F'};
pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
results=[];
allfiles=dir(signalsHistPath);
for i=3:size(allfiles,1)
    allfiles2=dir(strcat(signalsHistPath,allfiles(i).name));
    for j=4:2:size(allfiles2,1)
        load(strcat(signalsHistPath,allfiles(i).name,'/',allfiles2(j).name));
        for smoothV=1:4:22
            [locs_smooth]=peaks_extractor(yHist,smoothV);
            for margin=0:5
                pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
                th  = getThresholdFromPeaks( locs_smooth, margin ) ;
                val_folder=dir(directory);
                tic;
                for z=3:size(val_folder,1)-2
                    color_spaces=strsplit(allfiles2(j).name,'_');
                    img=imread(strcat(directory,val_folder(z).name));
                    if strcmp(color_spaces, 'ycbcr')
                        img = rgb2ycbcr(img);
                    elseif strcmp(color_spaces, 'cielab')
                        colorTransform = makecform('srgb2lab');
                        img = applycform(img, colorTransform);
                    elseif strcmp(color_spaces, 'hsv')
                        img = rgb2hsv(img);
                        img = img .* 255;
                    elseif strcmp(color_spaces, 'xyz')
                        img = rgb2xyz(img);
                        img = img .* 255;
                    end
           
                    img2 = uint16(zeros(size(img,1),size(img,2),1));
                    img2(:,:) = img(:,:,1)/samplingRate*(256/samplingRate)^2+img(:,:,2)/samplingRate*(256/samplingRate)+img(:,:,3)/samplingRate;
                    bw  = applyThreshold( th, img2 );
                    str_split=strsplit(val_folder(z).name,'.jpg');
                    pixelAnnotation = imread(strcat(directory, '/mask/mask.', cell2mat(str_split(1)), '.png'))>0;
                    [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(bw, pixelAnnotation);
                    pixelTP = pixelTP + localPixelTP;
                    pixelFP = pixelFP + localPixelFP;
                    pixelFN = pixelFN + localPixelFN;
                    pixelTN = pixelTN + localPixelTN;
                    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
                end
                tiempo=toc;
                tiempo=tiempo/(size(val_folder,1)-2);
                [color_spaces(1),margin, smoothV,pixelPrecision,pixelAccuracy,pixelSpecificity,pixelSensitivity,pixelF1,pixelTP,pixelFP,pixelFN,pixelTN,tiempo]
                results=[results;color_spaces(1),margin, smoothV,pixelPrecision,pixelAccuracy,pixelSpecificity,pixelSensitivity,pixelF1,pixelTP,pixelFP,pixelFN,pixelTN,tiempo];
            end
        end
    end
end

save('results.mat', 'results');
end

function [locs_smooth] = peaks_extractor (yHist, smoothV)
    [pks,locs] = findpeaks(yHist); %returns a vector with the local maxima (peaks).
    
    yHist_smooth=yHist;
    for z=1:smoothV
        yHist_smooth=smooth(yHist_smooth); %smooths the data in the column vector using a moving average filter
    end
    [pks_smooth,locs_smooth] = findpeaks(yHist_smooth);
end


function [ bw ] = applyThreshold( th, img )
    bw = zeros(size(img,1), size(img,2));
    for i=1:size(th,1)
        for j=1:size(th(1),1)
            bwAux = img(:,:,j) >= th(i, j, 1) & img(:,:,j) <= th(i, j, 2);
            bw = bw | bwAux;
        end
    end
end

function [ th ] = getThresholdFromPeaks( peaks, margin )
    th = zeros(size(peaks,1), size(peaks,2), 2);
    for i=1:size(peaks,1)
       for j=1:size(peaks,2)
          th(i, j, 1) = peaks(i, j) - margin;
          th(i, j, 2) = peaks(i, j) + margin; 
       end
    end
end


