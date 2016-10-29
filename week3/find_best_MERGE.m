function find_best_MERGE( directory )
%FIND_BEST_MERGE Summary of this function goes here
%   Detailed explanation goes here

    addpath('evaluation')

    files = ListFiles(directory);
    nFiles = size(files, 1);
    disp(sprintf('Training with %d Files', nFiles));

    BUCTrain = fopen('BUC_MERGING_train_refined.txt','w');

    th_low = [0.65, 0.7, 0.75];
    th_high = [1];

    nms_th = [0.3, 0.35, 0.4];
    win_sizes = [35, 40, 45];

    for li=1:length(th_low)
        for hi=1:length(th_high)
            for ni=1:length(nms_th)
                for wi=1:length(win_sizes)
                    disp(sprintf('Training with %f %f %f %f', th_low(li), th_high(hi), nms_th(ni), win_sizes(wi)));
                    fprintf(BUCTrain, 'Training with %f %f %f %f\n', th_low(li), th_high(hi), nms_th(ni), win_sizes(wi));

                    windowTP=0; windowFN=0; windowFP=0; windowTN=0; % original
                    fwindowTP=0; fwindowFN=0; fwindowFP=0; fwindowTN=0; % filtered
                    %---------- START DATASET -------------
                    for i=1:nFiles

                        if (mod(i, 25) == 0)
                            i
                        end

                        % Read file
                        im = imread(strcat(directory,'/',files(i).name));

                        % Candidate Generation (pixel) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        pixelCandidates = CandidateGenerationPixel_Color(im, 'hsv');
                        element=strel('diamond',4);
                        pixelCandidates = morf(pixelCandidates, element);

                        % Candidate Generation (window)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        windowCandidates = IntegralCandidateGenerationWindow(im, pixelCandidates, 'Integral', th_low(li), th_high(hi), win_sizes(wi));

                        new_windowCandidates = NonMaxS(windowCandidates, nms_th(ni));
                        while length(new_windowCandidates) ~= length(windowCandidates)
                            windowCandidates = new_windowCandidates;
                            new_windowCandidates = NonMaxS(windowCandidates, nms_th(ni));
                        end
                        windowCandidates = new_windowCandidates;
                        
                        %filtered
                        fwindowCandidates = filterWindows(windowCandidates);

                        windowAnnotations = LoadAnnotations(strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt'));

                        % Accumulate object performance of the current image %%%%%%%%%%%%%%%%  (Needed after Week 3)
                        [localWindowTP, localWindowFN, localWindowFP, localWindowTN] = PerformanceAccumulationWindow(windowCandidates, windowAnnotations);
                        windowTP = windowTP + localWindowTP;
                        windowFN = windowFN + localWindowFN;
                        windowFP = windowFP + localWindowFP;
                        windowTN = windowTN + localWindowTN;

                        % filtered version
                        [localWindowTP, localWindowFN, localWindowFP, localWindowTN] = PerformanceAccumulationWindow(fwindowCandidates, windowAnnotations);
                        fwindowTP = fwindowTP + localWindowTP;
                        fwindowFN = fwindowFN + localWindowFN;
                        fwindowFP = fwindowFP + localWindowFP;
                        fwindowTN = fwindowTN + localWindowTN;
                    end
                    %---------- END DATASET -------------

                    [windowPrecision, windowAccuracy, windowSpecificity, windowSensitivity, windowF1] = PerformanceEvaluationWindow(windowTP, windowFN, windowFP, windowTN); % (Needed after Week 3)
                    % filtered
                    [fwindowPrecision, fwindowAccuracy, fwindowSpecificity, fwindowSensitivity, fwindowF1] = PerformanceEvaluationWindow(fwindowTP, fwindowFN, fwindowFP, fwindowTN); % (Needed after Week 3)

                    disp(sprintf('WINDOW INFORMATION'));
                    disp(sprintf('Precision: %f', windowPrecision));
                    disp(sprintf('Accuracy: %f', windowAccuracy));
                    disp(sprintf('Specificity: %f', windowSpecificity));
                    disp(sprintf('Sensitivity (Recall): %f', windowSensitivity));
                    disp(sprintf('F1 score: %f', windowF1));
                    disp(sprintf('TP: %f', windowTP));
                    disp(sprintf('FP: %f', windowFP));
                    disp(sprintf('FN: %f', windowFN));

                    fprintf(BUCTrain, 'Precision: %f, Accuracy: %f, Specificity: %f, Sensitivity (Recall): %f, F1 score: %f, TP: %f, FP: %f, FN: %f \n', windowPrecision, windowAccuracy, windowSpecificity, windowSensitivity, windowF1, windowTP, windowFP, windowFN);
                    fprintf(BUCTrain, 'Filtered version:\n');
                    fprintf(BUCTrain, 'Precision: %f, Accuracy: %f, Specificity: %f, Sensitivity (Recall): %f, F1 score: %f, TP: %f, FP: %f, FN: %f \n', fwindowPrecision, fwindowAccuracy, fwindowSpecificity, fwindowSensitivity, fwindowF1, fwindowTP, fwindowFP, fwindowFN);

                end
            end
        end
    end

end

function [pixelCandidates] = CandidateGenerationPixel_Color(im, space)

    im=double(im);

    switch space
        case 'rgb'
            r_th = [11.8967, 56.8533, 52.7663];
            red_pixelCandidates = im(:,:,1) > r_th(1) & im(:,:,2) < r_th(2) & im(:,:,3) < r_th(3);
            
            b_th = [44.1466, 60.4712, 24.5236];
            blue_pixelCandidates = im(:,:,1) < b_th(1) & im(:,:,2) < b_th(2) & im(:,:,3) > b_th(3);
            
            pixelCandidates = red_pixelCandidates | blue_pixelCandidates;
            
        case 'normrgb'
            % normalize rgb
            im = NormRGB(double(im));
            
            r_th = [0.0830    0.2943    0.2870];
            red_pixelCandidates = im(:,:,1) > r_th(1) & im(:,:,2) < r_th(2) & im(:,:,3) < r_th(3);
            
            b_th = [0.2625    0.3121    0.1951];
            blue_pixelCandidates = im(:,:,1) < b_th(1) & im(:,:,2) < b_th(2) & im(:,:,3) > b_th(3);
            
            pixelCandidates = red_pixelCandidates | blue_pixelCandidates;
        
        case 'hsv'
            imhsv = rgb2hsv(im);
            im_h = imhsv(:,:,1);
            im_s = imhsv(:,:,2);
            im_v = imhsv(:,:,3);
            
            v_th = [0.1*255 1*255];
            
            r_th = [0.96    0.04     0.5];
            red_pixelCandidates = (im_h > r_th(1) | im_h < r_th(2)) & im_s > r_th(3);
            
            b_th = [0.56    0.76     0.5];
            blue_pixelCandidates = im_h > b_th(1) & im_h < b_th(2) & im_s > b_th(3);
            
            pixelCandidates = red_pixelCandidates | blue_pixelCandidates;
            
            pixelCandidates = pixelCandidates & im_v > v_th(1) & im_v < v_th(2);
            
        case 'lab'
            imlab = rgb2lab(im);
                        
            im_a = imlab(:,:,2);
            im_b = imlab(:,:,3);
            
            red_pixelCandidates = im_a > 0;
            blue_pixelCandidates = im_b < 0;
            
            pixelCandidates = red_pixelCandidates | blue_pixelCandidates;
        
        case 'histEq'
            im = histogramEqualization(im);
            
            r_th = [0.1757    0.7075    0.6895];
            red_pixelCandidates = im(:,:,1) > r_th(1) & im(:,:,2) < r_th(2) & im(:,:,3) < r_th(3);
            
            b_th = [0.5784    0.6954    0.4534];
            blue_pixelCandidates = im(:,:,1) < b_th(1) & im(:,:,2) < b_th(2) & im(:,:,3) > b_th(3);
            
            pixelCandidates = red_pixelCandidates | blue_pixelCandidates;
        
        case 'hbp'
            imhsv = rgb2hsv(im);
            im_h = imhsv(:,:,1);
            im_s = imhsv(:,:,2);
            
            bins = 32;
            
            load(['red_hist_' num2str(bins) '.mat']);
            load(['blue_hist_' num2str(bins) '.mat']);
            load(['rb_hist_' num2str(bins) '.mat']);
            
            red_hist(:,1:round(bins*0.5)) = 0;
            blue_hist(:,1:round(bins*0.5)) = 0;
            rb_hist(:,1:round(bins*0.5)) = 0;
  
            pixels = [im_h(:) im_s(:)];
            pixels = ceil(pixels*bins); % from pixels to bins
            pixels(pixels==0) = 1; % convert 0 to ones because the loswest bin is 1.

            pixelCandidates = zeros(size(im_h));
            pixelCandidates = reshape(pixelCandidates, [size(pixelCandidates, 1)*size(pixelCandidates, 2), 1]);

            for p=1:size(pixelCandidates, 1)
                hist_i = pixels(p,1);
                hist_j = pixels(p,2);
                pixelCandidates(p) = (red_hist(hist_i, hist_j) > 0.005) | (blue_hist(hist_i, hist_j) > 0.005) | (rb_hist(hist_i, hist_j) > 0.005);
            end
            pixelCandidates = reshape(pixelCandidates, size(im_h));
            
        otherwise
            error('Incorrect color space defined');
            return
    end
end

function [windowCandidates] = IntegralCandidateGenerationWindow(im, pixelCandidates, window_method, low_th, high_th, size_w)
    iImg = cumsum(cumsum(double(pixelCandidates)),2);
    windowCandidates = IntegralSlidingWindow(iImg, floor(size_w/4), size_w, size_w, low_th, high_th);
end
