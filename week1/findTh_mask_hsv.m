function [output_args] = findTh_mask_hsv(train_set)
% Find best threshold training with the mask information and HSV color
% space. The function finds the best threshold for each image
    %    Parameter name      Value
    %    --------------      -----
    %     train_set       string
    
    % Guillem - to use evaluation functions
    addpath('evaluation')
    
    files = ListFiles(train_set);
    nFiles = size(files, 1);
    disp(sprintf('Training with %d Files', nFiles));
    
    HSVTrain = fopen('hsv_train.txt','w');
    
    red_radiuses = [0.05 0.1 0.20 0.30];
    blue_radiuses = [0.05 0.1 0.20 0.30];
    sat_radiuses = [0.3 0.5 0.7];
    for ri=1:length(red_radiuses)
        for bi=1:length(blue_radiuses)
            for si=1:length(sat_radiuses)
                
                disp(sprintf('Training with %f %f %f', red_radiuses(ri), blue_radiuses(bi), sat_radiuses(si)));
                fprintf(HSVTrain, 'Training with %f %f %f \n', red_radiuses(ri), blue_radiuses(bi), sat_radiuses(si));
                
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
                    im_v = im(:,:,3);

                    % Read the mask image
                    mask = imread(strcat(train_set, '/mask/mask.',strrep(files(i).name, '.jpg', '.png'))) > 0;

                    r_th = [1-red_radiuses(ri) red_radiuses(ri) sat_radiuses(si)];
                    b_th = [0.66-blue_radiuses(bi) 0.66+blue_radiuses(bi) sat_radiuses(si)];
                    segmentation = CandidateGenerationPixel_Color(im, r_th, b_th);
                    
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
                
                fprintf(HSVTrain, 'Precision: %f, Accuracy: %f, Specificity: %f, Sensitivity (Recall): %f, F1 score: %f, TP: %f, FP: %f, FN: %f \n', pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1, pixelTP, pixelFP, pixelFN);
    
            end
        end
    end
    
    fclose(HSVTrain);
end

function [pixelCandidates] = CandidateGenerationPixel_Color(im, r_th, b_th)

    im_h = im(:,:,1);
    im_s = im(:,:,2);
    
    red_pixelCandidates = im_h > r_th(1) | im_h < r_th(2) & im_s > r_th(3);
    blue_pixelCandidates = im_h > b_th(1) & im_h < b_th(2) & im_s > b_th(3);

    pixelCandidates = red_pixelCandidates | blue_pixelCandidates;
end  