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
            for margin=0:4:20
                pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
                th  = getThresholdFromPeaks( locs_smooth, margin ) ;
                val_folder=dir('../SplitDataset/val/');
                tic;
                for z=3:size(val_folder,1)-2
                    color_spaces=strsplit(allfiles2(j).name,'_');
                    img=imread(strcat('../SplitDataset/val/',val_folder(z).name));
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

