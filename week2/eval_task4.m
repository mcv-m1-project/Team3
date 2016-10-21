function eval_task4( val_path, bins)
%EVAL_TASK4 Evaluates task4 segmentation
%   This function evalautes the segmentation trained in task4.m with the
%   validation set.

    addpath('evaluation')

    pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
    
    files = ListFiles(val_path);
    nFiles = size(files, 1);
    disp(sprintf('Evaluating with %d Files', nFiles));
        
    load(['red_hist_' num2str(bins) '.mat'])
    load(['blue_hist_' num2str(bins) '.mat'])
    load(['rb_hist_' num2str(bins) '.mat'])
    
    red_hist(:,1:round(bins/2)) = 0;
    blue_hist(:,1:round(bins/2)) = 0;
    rb_hist(:,1:round(bins/2)) = 0;

    %---------- EVAL DATASET -------------
    tic
    
    for i=1:nFiles
        if (mod(i, 25) == 0)
            i
        end
        
        % Read the image
        im = imread(strcat(val_path,'/',files(i).name));
%         imshow(im);
%         k = waitforbuttonpress;
        % Convert the image into HSV
        im = rgb2hsv(im);
        im_h = im(:,:,1);
        im_s = im(:,:,2);
        %im_v = im(:,:,3);

        % Read the mask image
        mask = imread(strcat(val_path, '/mask/mask.',strrep(files(i).name, '.jpg', '.png'))) > 0;
        
        segmentation = zeros(size(mask));
        segmentation = reshape(segmentation, [size(segmentation, 1)*size(segmentation, 2), 1]);
        
        pixels = [im_h(:) im_s(:)];
        pixels = ceil(pixels*bins); % from pixels to bins
        pixels(pixels==0) = 1;
        
        for p=1:size(segmentation, 1)
            hist_i = pixels(p,1);
            hist_j = pixels(p,2);
            segmentation(p) = (red_hist(hist_i, hist_j) > 0.007) | (blue_hist(hist_i, hist_j) > 0.007) | (rb_hist(hist_i, hist_j) > 0.007);
        end
        segmentation = reshape(segmentation, size(mask));
%         imshow(segmentation);
%         k = waitforbuttonpress;
        
        [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(segmentation, mask);
        pixelTP = pixelTP + localPixelTP;
        pixelFP = pixelFP + localPixelFP;
        pixelFN = pixelFN + localPixelFN;
        pixelTN = pixelTN + localPixelTN;
    end
    %---------- END EVAL -------------
    
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
    
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1]
    
    disp(sprintf('Precision: %f', pixelPrecision));
    disp(sprintf('Accuracy: %f', pixelAccuracy));
    disp(sprintf('Specificity: %f', pixelSpecificity));
    disp(sprintf('Sensitivity (Recall): %f', pixelSensitivity));
    disp(sprintf('F1 score: %f', pixelF1));
    disp(sprintf('TP: %f', pixelTP));
    disp(sprintf('FP: %f', pixelFP));
    disp(sprintf('FN: %f', pixelFN));
    
    elapsed = toc;    
    disp(sprintf('Time per frame: %f s.', elapsed/nFiles));
end

