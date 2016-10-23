function find_th_hist(train_set)
% Find best threshold training with the mask information and HSV color
% space. The function finds the best threshold for each image
    %    Parameter name      Value
    %    --------------      -----
    %     train_set       string
    
    addpath('evaluation')
    
    files = ListFiles(train_set);
    nFiles = size(files, 1);
    disp(sprintf('Training with %d Files', nFiles));
    
    HISTTrain = fopen('hist_norm_train.txt','w');
    
    n_bins = [16 32];
    th_eval = [0.001 0.005 0.007 0.01];
    sat_radiuses = [0.3 0.5 0.7];
    for ri=1:length(th_eval)
        for bi=1:length(n_bins)
            for si=1:length(sat_radiuses)
                bins = n_bins(bi);
                
                load(['red_hist_' num2str(bins) '.mat'])
                load(['blue_hist_' num2str(bins) '.mat'])
                load(['rb_hist_' num2str(bins) '.mat'])

                red_hist(:,1:round(bins * sat_radiuses(si))) = 0;
                blue_hist(:,1:round(bins * sat_radiuses(si))) = 0;
                rb_hist(:,1:round(bins * sat_radiuses(si))) = 0;
                
                disp(sprintf('Training with %f %f %f', bins, th_eval(ri), sat_radiuses(si)));
                fprintf(HISTTrain, 'Training with %f %f %f \n', bins, th_eval(ri), sat_radiuses(si));
                
                pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
                
                %---------- START DATASET -------------
                for i=1:nFiles
                    
                    if (mod(i, 25) == 0)
                        i
                    end

                    % Read the image
                    im = imread(strcat(train_set,'/',files(i).name));
                    % Convert the image into HSV
                    im = rgb2hsv(im);
                    im_h = im(:,:,1);
                    im_s = im(:,:,2);
                    % im_v = im(:,:,3);

                    % Read the mask image
                    mask = imread(strcat(train_set, '/mask/mask.',strrep(files(i).name, '.jpg', '.png'))) > 0;

                    segmentation = CandidateGenerationPixel_Color(im, th_eval(ri), bins, red_hist, blue_hist, rb_hist);
                    
                    [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(segmentation, mask);
                    pixelTP = pixelTP + localPixelTP;
                    pixelFP = pixelFP + localPixelFP;
                    pixelFN = pixelFN + localPixelFN;
                    pixelTN = pixelTN + localPixelTN;
                    
                end
                %---------- END DATASET -------------
                
                [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
    
                disp(sprintf('Precision: %f', pixelPrecision));
                disp(sprintf('Accuracy: %f', pixelAccuracy));
                disp(sprintf('Specificity: %f', pixelSpecificity));
                disp(sprintf('Sensitivity (Recall): %f', pixelSensitivity));
                disp(sprintf('F1 score: %f', pixelF1));
                disp(sprintf('TP: %f', pixelTP));
                disp(sprintf('FP: %f', pixelFP));
                disp(sprintf('FN: %f', pixelFN));
                
                fprintf(HISTTrain, 'Precision: %f, Accuracy: %f, Specificity: %f, Sensitivity (Recall): %f, F1 score: %f, TP: %f, FP: %f, FN: %f \n', pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1, pixelTP, pixelFP, pixelFN);
    
            end
        end
    end
    
    fclose(HISTTrain);
end

function [pixelCandidates] = CandidateGenerationPixel_Color(im, th, bins, red_hist, blue_hist, rb_hist)

    im_h = im(:,:,1);
    im_s = im(:,:,2);
    
    % Normalize the signals histograms according to this specific image
%     im_hist = buildHist(im_h(:), im_s(:), bins);
%     im_hist = im_hist / sum(im_hist(:));
%     norm_red_hist = red_hist ./ im_hist; norm_red_hist(isinf(norm_red_hist)) = 0; norm_red_hist(isnan(norm_red_hist)) = 0;
%     norm_blue_hist = blue_hist ./ im_hist; norm_blue_hist(isinf(norm_blue_hist)) = 0; norm_blue_hist(isnan(norm_blue_hist)) = 0;
%     norm_rb_hist = rb_hist ./ im_hist; norm_rb_hist(isinf(norm_rb_hist)) = 0; norm_rb_hist(isnan(norm_rb_hist)) = 0;
%     % Normalize each histogram in the 0-1 range
%     norm_red_hist = norm_red_hist / max(norm_red_hist(:));
%     norm_blue_hist = norm_blue_hist / max(norm_blue_hist(:));
%     norm_rb_hist = norm_rb_hist / max(norm_rb_hist(:));
    
    pixels = [im_h(:) im_s(:)];
    pixels = ceil(pixels*bins); % from pixels to bins
    pixels(pixels==0) = 1;
    
    pixelCandidates = zeros(size(im_h));
    pixelCandidates = reshape(pixelCandidates, [size(pixelCandidates, 1)*size(pixelCandidates, 2), 1]);
    
    for p=1:size(pixelCandidates, 1)
        hist_i = pixels(p,1);
        hist_j = pixels(p,2);
        pixelCandidates(p) = (red_hist(hist_i, hist_j) > th) | (blue_hist(hist_i, hist_j) > th) | (rb_hist(hist_i, hist_j) > th);
    end
    pixelCandidates = reshape(pixelCandidates, size(im_h));

end  