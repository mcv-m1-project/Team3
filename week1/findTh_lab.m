function [output_args] = findTh_lab(train_set)
% Find best threshold training with the mask information and LAB color
% space. The function finds the best threshold for each image
    %    Parameter name      Value
    %    --------------      -----
    %     train_set       string
    
    % Guillem - to use evaluation functions
    addpath('evaluation')
    
    files = ListFiles(train_set);
    nFiles = size(files, 1);
    disp(sprintf('Training with %d Files', nFiles));
    
    LABTrain = fopen('lab_train.txt','w');
    
    red_radiuses = [[0 0] ; [10 10] ; [20 20]];
    blue_radiuses = [[-10 -10] ; [-10 -20] ; [-20 -20]];
    lum_radiuses = [20 30 40];
    for ci=1:length(red_radiuses)
        for oi=1:length(blue_radiuses)
            for li=1:length(lum_radiuses)
                
                disp(sprintf('Training with [%i %i], [%i %i], [%i]', red_radiuses(ci,1), red_radiuses(ci,2), blue_radiuses(oi,1), blue_radiuses(oi,2), lum_radiuses(li)));
                fprintf(LABTrain, 'Training with [%i %i], [%i %i], [%i]', red_radiuses(ci,1), red_radiuses(ci,2), blue_radiuses(oi,1), blue_radiuses(oi,2), lum_radiuses(li));
                                
                pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
                
                %---------- START DATASET -------------
                for i=1:nFiles
                    
                    if (mod(i, 25) == 0)
                        i
                    end

                    % Read the image
                    im = imread(strcat(train_set,'/',files(i).name));
                    % Convert the image into LAB
                    im = rgb2lab(im);

                    % Read the mask image
                    mask = imread(strcat(train_set, '/mask/mask.',strrep(files(i).name, '.jpg', '.png'))) > 0;

                    r_th = [red_radiuses(ci,1) red_radiuses(ci,2)]; % a-axis min, b-axis min
                    b_th = [blue_radiuses(oi,1) blue_radiuses(oi,2)]; % a-axis min, b-axis min
                    l_th = [50-lum_radiuses(li) 50+lum_radiuses(li)]; % range from 50-x to 50+x
                    segmentation = CandidateGenerationPixel_Color(im, r_th, b_th, l_th);
                    
%                     imshow(lab2rgb(im));
%                     k = waitforbuttonpress;
%                     imshow(segmentation);
%                     k = waitforbuttonpress;
                    
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
                
                fprintf(LABTrain, 'Precision: %f, Accuracy: %f, Specificity: %f, Sensitivity (Recall): %f, F1 score: %f, TP: %f, FP: %f, FN: %f \n', pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1, pixelTP, pixelFP, pixelFN);
    
            end
        end
    end
    
    fclose(LABTrain);
end

function [pixelCandidates] = CandidateGenerationPixel_Color(im, r_th, b_th, l_th)

    im_l = im(:,:,1);
    im_a = im(:,:,2);
    im_b = im(:,:,3);
    
    red_pixelCandidates = im_l > l_th(1) & im_l < l_th(2) & im_a > r_th(1) & im_b > b_th(2);
    blue_pixelCandidates = im_l > l_th(1) & im_l < l_th(2) & im_a < b_th(1) & im_b < b_th(2);

    pixelCandidates = red_pixelCandidates | blue_pixelCandidates;
end  