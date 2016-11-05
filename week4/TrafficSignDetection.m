
%
% Template example for using on the validation set.
% 

function TrafficSignDetection(directory, pixel_method, window_method, decision_method)
    % TrafficSignDetection
    % Perform detection of Traffic signs on images. Detection is performed first at the pixel level
    % using a color segmentation. Then, using the color segmentation as a basis, the most likely window 
    % candidates to contain a traffic sign are selected using basic features (form factor, filling factor). 
    % Finally, a decision is taken on these windows using geometric heuristics (Hough) or template matching.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'directory'         directory where the test images to analize  (.jpg) reside
    %    'pixel_method'      Name of the color space: 'opp', 'normrgb', 'lab', 'hsv', etc. (Weeks 2-5)
    %    'window_method'     'connectedComponents' or 'slidingWindow' or 'integral' or
    %                        'convolution' or 'mergeIntegral' (Weeks 3-5)
    %    'decision_method'   'GeometricHeuristics' or 'TemplateMatching' (Weeks 4-5)

    addpath('evaluation')

    global CANONICAL_W;        CANONICAL_W = 64;
    global CANONICAL_H;        CANONICAL_H = 64;
    global SW_STRIDEX;         SW_STRIDEX = 8;
    global SW_STRIDEY;         SW_STRIDEY = 8;
    global SW_CANONICALW;      SW_CANONICALW = 32;
    global SW_ASPECTRATIO;     SW_ASPECTRATIO = 1;
    global SW_MINS;            SW_MINS = 1;
    global SW_MAXS;            SW_MAXS = 2.5;
    global SW_STRIDES;         SW_STRIDES = 1.2;


    % Load models
    %global circleTemplate;
    %global givewayTemplate;   
    %global stopTemplate;      
    %global rectangleTemplate; 
    %global triangleTemplate;  
    %
    %if strcmp(decision_method, 'TemplateMatching')
    %   circleTemplate    = load('TemplateCircles.mat');
    %   givewayTemplate   = load('TemplateGiveways.mat');
    %   stopTemplate      = load('TemplateStops.mat');
    %   rectangleTemplate = load('TemplateRectangles.mat');
    %   triangleTemplate  = load('TemplateTriangles.mat');
    %end

    windowTP=0; windowFN=0; windowFP=0; windowTN=0; % (Needed after Week 3)
    pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
    
    files = ListFiles(directory);
    
    global RESCALE;         RESCALE = 0.5;
    
    nFiles = size(files, 1);
    disp(sprintf('%d images to evaluate', nFiles));
    
    % Load mask templates
    load('mask_templates.mat');
    
    % Load grayscale templates for correlatino
    load('grayscaleTemps.mat');
    
    mask_templates = {rgb2gray(imread('mask_templates/circle.png'))>0 rgb2gray(imread('mask_templates/square.png'))>0 rgb2gray(imread('mask_templates/triangle.png'))>0 rgb2gray(imread('mask_templates/triangle_down.png'))>0};
    
    mask_templates = {imresize(mask_templates{1}, RESCALE) imresize(mask_templates{2}, RESCALE) imresize(mask_templates{3}, RESCALE) imresize(mask_templates{4}, RESCALE)}; 
    
    grayscaleTemps = {imresize(grayscaleTemps{1}, RESCALE) imresize(grayscaleTemps{2}, RESCALE) imresize(grayscaleTemps{3}, RESCALE) imresize(grayscaleTemps{4}, RESCALE)}; 
    
    tic
    
    for i=1:nFiles
        
        if (mod(i, 25) == 0)
            i
        end
        
        % Read file
        im = imread(strcat(directory,'/',files(i).name));
        
        im = imresize(im, RESCALE);
                    
        % Candidate Generation (pixel) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        pixelCandidates = CandidateGenerationPixel_Color(im, pixel_method);
        element=strel('diamond',4*RESCALE);
        pixelCandidates = morf(pixelCandidates, element);
        
        % Candidate Generation (window)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        switch window_method
            case 'slidingWindow'
                windowCandidates = CandidateGenerationWindow(im, pixelCandidates, window_method); %%'SegmentationCCL' or 'SlidingWindow'  (Needed after Week 3)
            case 'integral'
                windowCandidates = IntegralCandidateGenerationWindow(im, pixelCandidates, window_method);
                windowCandidates = filterWindows(windowCandidates);
            case 'convolution'
                windowCandidates = ConvCandidateGenerationWindow(im, pixelCandidates, window_method);
            case 'mergeIntegral'
                windowCandidates = MergeIntegralCandidateGenerationWindow(im, pixelCandidates, window_method);
                windowCandidates = filterWindows(windowCandidates);
            case 'connectedComponents'
                windowCandidates = ConnectedComponents(pixelCandidates);
            case 'correlation'
                windowCandidates = CorrCandidateGenerationWindow(im, pixelCandidates, window_method, grayscaleTemps);
            case 'maskchamfer'
                windowCandidates = MaskChamferGenerationWindow(pixelCandidates, mask_templates);
            otherwise
                error('Incorrect window method defined');
                return
        end
        filtroResta(im, pixelCandidates, windowCandidates, grayscaleTemps);
        
        % Because the image is resized, the window points shall be moved
        for a=1:size(windowCandidates, 1)
            windowCandidates(a).x = windowCandidates(a).x / RESCALE;
            windowCandidates(a).y = windowCandidates(a).y / RESCALE;
            windowCandidates(a).w = windowCandidates(a).w / RESCALE;
            windowCandidates(a).h = windowCandidates(a).h / RESCALE;
        end
        
        windowAnnotations = LoadAnnotations(strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt'));   
        
        % %%%%%%%%%%%%%%%% Print candidate windows %%%%%%%%%%%%%%%%
        
        imshow(imresize(pixelCandidates, 1/RESCALE))
        
        for a=1:size(windowAnnotations, 1)
            rectangle('Position',[windowAnnotations(a).x ,windowAnnotations(a).y ,windowAnnotations(a).w,windowAnnotations(a).h],'EdgeColor','r');
        end 

        for a=1:size(windowCandidates, 1)
            rectangle('Position',[windowCandidates(a).x ,windowCandidates(a).y ,windowCandidates(a).w,windowCandidates(a).h],'EdgeColor','c');
        end 

        waitforbuttonpress;
        waitforbuttonpress;
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Accumulate pixel performance of the current image %%%%%%%%%%%%%%%%%
        pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
        pixelAnnotation = imresize(pixelAnnotation, RESCALE);
        
        [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
        pixelTP = pixelTP + localPixelTP;
        pixelFP = pixelFP + localPixelFP;
        pixelFN = pixelFN + localPixelFN;
        pixelTN = pixelTN + localPixelTN;
        
        % Accumulate object performance of the current image %%%%%%%%%%%%%%%%  (Needed after Week 3)
        % windowAnnotations = LoadAnnotations(strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt'));
        [localWindowTP, localWindowFN, localWindowFP, localWindowTN] = PerformanceAccumulationWindow(windowCandidates, windowAnnotations);
        windowTP = windowTP + localWindowTP;
        windowFN = windowFN + localWindowFN;
        windowFP = windowFP + localWindowFP;
        windowTN = windowTN + localWindowTN;
    end

    % Plot performance evaluation
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
    [windowPrecision, windowAccuracy, windowSpecificity, windowSensitivity, windowF1] = PerformanceEvaluationWindow(windowTP, windowFN, windowFP, windowTN); % (Needed after Week 3)
    
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1];
    
    disp(sprintf('PIXEL INFORMATION'));
    disp(sprintf('Precision: %f', pixelPrecision));
    disp(sprintf('Accuracy: %f', pixelAccuracy));
    disp(sprintf('Specificity: %f', pixelSpecificity));
    disp(sprintf('Sensitivity (Recall): %f', pixelSensitivity));
    disp(sprintf('F1 score: %f', pixelF1));
    disp(sprintf('TP: %f', pixelTP));
    disp(sprintf('FP: %f', pixelFP));
    disp(sprintf('FN: %f', pixelFN));
    
    [windowPrecision, windowAccuracy]
    
    disp(sprintf('WINDOW INFORMATION'));
    disp(sprintf('Precision: %f', windowPrecision));
    disp(sprintf('Accuracy: %f', windowAccuracy));
    disp(sprintf('Specificity: %f', windowSpecificity));
    disp(sprintf('Sensitivity (Recall): %f', windowSensitivity));
    disp(sprintf('F1 score: %f', windowF1));
    disp(sprintf('TP: %f', windowTP));
    disp(sprintf('FP: %f', windowFP));
    disp(sprintf('FN: %f', windowFN));
    
    %profile report
    %profile off
    elapsed = toc;    
    disp(sprintf('Time per frame: %f s.', elapsed/nFiles));
end
 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CandidateGeneration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    

function [windowCandidates] = CandidateGenerationWindow(im, pixelCandidates, window_method)
    sizes = [32 64];
    windowCandidates = [];
    for s=1:length(sizes)
        windowCandidates = [ windowCandidates; SlidingWindow(pixelCandidates, 8, sizes(s), sizes(s), 0.5, 1) ];
        windowCandidates = NonMaxS(windowCandidates, 0.2);
    end
    windowCandidates = NonMaxS(windowCandidates, 0.2);
end

function [windowCandidates] = MergeCandidateGenerationWindow(im, pixelCandidates, window_method)
    windowCandidates = SlidingWindow(pixelCandidates, 10, 40, 40, 0.7, 1);

    new_windowCandidates = NonMaxS(windowCandidates, 0.3);

    while length(new_windowCandidates) ~= length(windowCandidates)
        windowCandidates = new_windowCandidates;
        new_windowCandidates = NonMaxS(windowCandidates, 0.3);
    end
    windowCandidates = new_windowCandidates;
    
end

function [windowCandidates] = IntegralCandidateGenerationWindow(im, pixelCandidates, window_method)
    iImg = cumsum(cumsum(double(pixelCandidates)),2);
    global RESCALE;
    sizes = [24*RESCALE 32*RESCALE 44*RESCALE 52*RESCALE 64*RESCALE 80*RESCALE 92*RESCALE 108*RESCALE 128*RESCALE 136*RESCALE];
    windowCandidates = [];
    for s=1:length(sizes)
        windowCandidates = [ windowCandidates; IntegralSlidingWindow(iImg, sizes(s)/4, sizes(s), sizes(s), 0.5, 1) ];
        windowCandidates = NonMaxS(windowCandidates, 0.2);
    end
    windowCandidates = NonMaxS(windowCandidates, 0.2);
end

function [windowCandidates] = MergeIntegralCandidateGenerationWindow(im, pixelCandidates, window_method)
    iImg = cumsum(cumsum(double(pixelCandidates)),2);
    global RESCALE;
    windowCandidates = IntegralSlidingWindow(iImg, 10*RESCALE, 40*RESCALE, 40*RESCALE, 0.6, 1);

    new_windowCandidates = NonMaxS(windowCandidates, 0.3);

    while length(new_windowCandidates) ~= length(windowCandidates)
        windowCandidates = new_windowCandidates;
        new_windowCandidates = NonMaxS(windowCandidates, 0.3);
    end
    windowCandidates = new_windowCandidates;
    
end

function [windowCandidates] = ConvCandidateGenerationWindow(im, pixelCandidates, window_method)
    sizes = [32 64];
    windowCandidates = [];
    for s=1:length(sizes)
        windowCandidates = [ windowCandidates; convTask5(pixelCandidates, 1, sizes(s), sizes(s), 0.5, 1) ];
        windowCandidates = NonMaxS(windowCandidates, 0.2);
    end
    windowCandidates = NonMaxS(windowCandidates, 0.2);
end

function [windowCandidates] = CorrCandidateGenerationWindow(im, pixelCandidates, window_method, templates)
    scales = [0.4 0.6 0.8 1.0 1.2 1.4];
    windowCandidates = [];
    threshods = [0.6 0.6 0.6 0.6];
    
    im = rgb2gray(im);

    for s=1:size(scales,2)
        templates = {imresize(templates{1}, scales(s)) imresize(templates{2}, scales(s)) imresize(templates{3}, scales(s)) imresize(templates{4}, scales(s))}; 
        windowCandidates = [windowCandidates; templateCorrelation(im, templates, threshods)];
    end
end

function [windowCandidates] = SubsCandidateGenerationWindow(im, pixelCandidates, window_method)
    sizes = [32 64];
    windowCandidates = [];
    im = rgb2gray(im);
    templates = rgb2gray(imread('mask.png'));
    templates = {templates; templates; templates; templates};
    %for s=1:length(sizes)
        windowCandidates = [windowCandidates; templateSubstraction(im, templates, 0.3)];
    %end
end

function [windowCandidates] = MaskChamferGenerationWindow(pixelCandidates, mask_templates)

    windowCandidates = [];
    scales = [0.4 0.6 0.8 1.0 1.2 1.4];
    
    edg = edge(pixelCandidates, 'Canny');
    if ~any(edg(:))
        return
    end
    dist = bwdist(edg);
    
    for s=1:size(scales,2)
        templates = {imresize(mask_templates{1}, scales(s)) imresize(mask_templates{2}, scales(s)) imresize(mask_templates{3}, scales(s)) imresize(mask_templates{4}, scales(s))}; 
        windowCandidates = [windowCandidates; MaskChamferWCandidates(templates, dist)];
    end
    pick = min_nms(windowCandidates, 0.05);
    windowCandidates = windowCandidates(pick);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performance Evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PerformanceEvaluationROC(scores, labels, thresholdRange)
    % PerformanceEvaluationROC
    %  ROC Curve with precision and accuracy
    
    roc = [];
	for t=thresholdRange,
        TP=0;
        FP=0;
        for i=1:size(scores,1),
            if scores(i) > t    % scored positive
                if labels(i)==1 % labeled positive
                    TP=TP+1;
                else            % labeled negative
                    FP=FP+1;
                end
            else                % scored negative
                if labels(i)==1 % labeled positive
                    FN = FN+1;
                else            % labeled negative
                    TN = TN+1;
                end
            end
        end
        
        precision = TP / (TP+FP+FN+TN);
        accuracy = TP / (TP+FN+FP);
        
        roc = [roc ; precision accuracy];
    end

    plot(roc);
end

