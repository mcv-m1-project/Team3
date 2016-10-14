function [ output_args ] = Hist_thres(samplingRate,directory)
%HIST_THRES Summary of this function goes here
%   Detailed explanation goes here
groups={'A','B','C','D','E','F'};
pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
results=[];
allfiles=dir('../Histos/_signal');
for i=3:size(allfiles,1)
    allfiles2=dir(strcat('../Histos/_signal/',allfiles(i).name));
    for j=4:2:size(allfiles2,1)
        load(strcat('../Histos/_signal/',allfiles(i).name,'/',allfiles2(j).name));
        for smoothV=1:10
            [locs_smooth]=peaks_extractor(yHist,smoothV);
            for margin=0:2:10
                pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
                th  = getThresholdFromPeaks( locs_smooth, margin ) ;
                val_folder=dir('../SplitDataset/val/');
                tic;
                for z=3:size(val_folder,1)-2
                    color_spaces=strsplit(allfiles2(j).name,'_');
                    img=imread(strcat('../SplitDataset/val/',val_folder(z).name));
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
                [color_spaces(1),margin, smoothV,pixelPrecision,pixelAccuracy,pixelSpecificity,pixelSensitivity,pixelF1,pixelTP,pixelFP,pixelFN,tiempo]
                results=[results;color_spaces(1),margin, smoothV,pixelPrecision,pixelAccuracy,pixelSpecificity,pixelSensitivity,pixelF1,pixelTP,pixelFP,pixelFN,tiempo];
            end
        end
    end
end
end

