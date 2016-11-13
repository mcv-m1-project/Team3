%
% Template example for using on the test set (no annotations).
% 
 
function TrafficSignDetection_test(input_dir, output_dir, pixel_method, window_method, decision_method)
    % TrafficSignDetection
    % Perform detection of Traffic signs on images. Detection is performed first at the pixel level
    % using a color segmentation. Then, using the color segmentation as a basis, the most likely window 
    % candidates to contain a traffic sign are selected using basic features (form factor, filling factor). 
    % Finally, a decision is taken on these windows using geometric heuristics (Hough) or template matching.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'input_dir'         Directory where the test images to analize  (.jpg) reside
    %    'output_dir'        Directory where the results are stored
    %    'pixel_method'      Name of the color space: 'opp', 'normrgb', 'lab', 'hsv', etc. (Weeks 2-5)
    %    'window_method'     'SegmentationCCL' or 'SlidingWindow' (Weeks 3-5)
    %    'decision_method'   'GeometricHeuristics' or 'TemplateMatching' (Weeks 4-5)


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

    files = ListFiles(input_dir);
    
    global RESCALE;         RESCALE = 1;
    
    mask_templates = {rgb2gray(imread('mask_templates/circle.png'))>0 rgb2gray(imread('mask_templates/square.png'))>0 rgb2gray(imread('mask_templates/triangle.png'))>0 rgb2gray(imread('mask_templates/triangle_down.png'))>0};

    % Load grayscale templates for correlatino
    load('grayscaleTemps.mat');
    
    grayscaleTemps = {imresize(grayscaleTemps{1}, RESCALE) imresize(grayscaleTemps{2}, RESCALE) imresize(grayscaleTemps{3}, RESCALE) imresize(grayscaleTemps{4}, RESCALE)}; 

    
    mkdir(strcat(output_dir, '/test/'));
    
    for ii=1:size(files,1),

        ii
        
        % Read file
        im = imread(strcat(input_dir,'/',files(ii).name));
     
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
                %windowCandidates = filterWindows(windowCandidates);
            case 'convolution'
                windowCandidates = ConvCandidateGenerationWindow(im, pixelCandidates, window_method);
            case 'mergeIntegral'
                windowCandidates = MergeIntegralCandidateGenerationWindow(im, pixelCandidates, window_method);
                %windowCandidates = filterWindows(windowCandidates);
            case 'connectedComponents'
                windowCandidates = ConnectedComponents(pixelCandidates);
            case 'correlation'
                windowCandidates = CorrCandidateGenerationWindow(im, pixelCandidates, window_method, grayscaleTemps);
            case 'subtraction'
                windowCandidates = SubsCandidateGenerationWindow(im, pixelCandidates, window_method, grayscaleTemps);
            case 'maskchamfer'
                windowCandidates = MaskChamferGenerationWindow(pixelCandidates, mask_templates);
            case 'none'
                
            otherwise
                error('Incorrect window method defined');
                return
        end
        
        % Filter window candidates
        switch decision_method
            case 'difference'
                windowCandidates = filterCandidatesDifference(im, windowCandidates, grayscaleTemps, 0.2);
            case 'correlation'
                windowCandidates = filterCandidatesCorr(im, windowCandidates, grayscaleTemps, 0.7);
            case 'convolution'
                windowCandidates = filterCandidatesConvolution(pixelCandidates, windowCandidates, mask_templates, 0.02);
            case 'chamfer'
                windowCandidates = filterCandidatesChamfer(pixelCandidates, windowCandidates, mask_templates, 0.45);
            case 'none'
                
            case 'filterWindows'
                windowCandidates = filterWindows(windowCandidates);
            case 'CC'
                im2=im;
                im2=rgb2hsv(im2);imSat = im2;
                imSat(:,:,2) = double(im2(:,:,2)*2);
                imLum = imSat;
                imLum(:,:,3) = double(imSat(:,:,3)*2);
                BW=edgesDetection(imLum, 'gradeMagnitudMorpho', 'bwOtsu');
                load('mask_templates.mat');
                templates=mask_templates;
                windowCandidates =CCchamferTemplateMatching(BW,templates);
                [ pixelCandidates ] = copyPixelsFromWindows(windowCandidates,BW);
            case 'geometricHeuristics'
                windowCandidates = filterCandidatesHough( windowCandidates, pixelCandidates, im );
            otherwise
                error('Incorrect decision method defined');
                return
        end
        
        % %%%%%%%%%%%%%%%% Print candidate windows %%%%%%%%%%%%%%%%
        
%         imshow(imresize(pixelCandidates, 1/RESCALE))
% 
%         for a=1:size(windowCandidates, 1)
%             rectangle('Position',[windowCandidates(a).x ,windowCandidates(a).y ,windowCandidates(a).w,windowCandidates(a).h],'EdgeColor','c');
%         end 
% 
%         waitforbuttonpress;
%         waitforbuttonpress;
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % In order to compute pixel based metrics, we have to use only the
        % pixels inside the windows found.
        [ pixelCandidates ] = copyPixelsFromWindows(windowCandidates,pixelCandidates);
        

        out_file1 = sprintf ('%s/test/pixelCandidates_%06d.png',  output_dir, ii);
	    out_file2 = sprintf ('%s/test/pixelCandidates_%06d.mat', output_dir, ii);

	    imwrite (pixelCandidates, out_file1);
	    save (out_file2, 'windowCandidates');        
    end
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
            
        case 'mean_shift'
            load('clustCent.mat');
            load('clustMembsCell.mat');
            Kms = length(clustMembsCell);
            
            im = NormRGB(double(im));
            
            dists = zeros(size(im,1), size(im,2), Kms);
            for k=1:Kms
                dist_r = im(:,:,1)-clustCent(1,k);
                dist_g = im(:,:,2)-clustCent(2,k);
                dist_b = im(:,:,3)-clustCent(3,k);
                dists(:,:,k) = dist_r.^2 + dist_g.^2 + dist_b.^2;
            end
            [~, mins] = min(dists, [], 3);

            for i=1:size(im,1)
                for j=1:size(im,2)
                    im(i,j,:) = clustCent(:,mins(i,j));
                end
            end
            
            imhsv = rgb2hsv(im);
            im_h = imhsv(:,:,1);
            im_s = imhsv(:,:,2);
            im_v = imhsv(:,:,3);

            v_th = [0.1*255 1*255];

            r_th = [0.96    0.04     0.1];
            red_pixelCandidates = (im_h > r_th(1) | im_h < r_th(2)) & im_s > r_th(3);

            b_th = [0.56    0.76     0.1];
            blue_pixelCandidates = im_h > b_th(1) & im_h < b_th(2) & im_s > b_th(3);

            pixelCandidates = red_pixelCandidates | blue_pixelCandidates;

            pixelCandidates(round(size(pixelCandidates, 1)/2):end, :) = 0;
        case 'kmeans'
            im=uint8(im);
            pixelCandidates=kmeans (im);   
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
        windowCandidates = [ windowCandidates; IntegralSlidingWindow(iImg, 4*RESCALE, sizes(s), sizes(s), 0.5, 1) ];
        windowCandidates = NonMaxS(windowCandidates, 0.2, 'mean');
    end
    windowCandidates = NonMaxS(windowCandidates, 0.2, 'mean');
end

function [windowCandidates] = MergeIntegralCandidateGenerationWindow(im, pixelCandidates, window_method)
    iImg = cumsum(cumsum(double(pixelCandidates)),2);
    global RESCALE;
    windowCandidates = IntegralSlidingWindow(iImg, 10*RESCALE, 40*RESCALE, 40*RESCALE, 0.6, 1);

    new_windowCandidates = NonMaxS(windowCandidates, 0.3, 'merge');

    while length(new_windowCandidates) ~= length(windowCandidates)
        windowCandidates = new_windowCandidates;
        new_windowCandidates = NonMaxS(windowCandidates, 0.3, 'merge');
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
    scales = [0.6]; %0.8 1.0 1.2 1.4];
    windowCandidates = [];
    threshods = [0.7 0.7 0.7 0.7];
    
    im = rgb2gray(im);

    for s=1:size(scales,2)
        templates = {imresize(templates{1}, scales(s)) imresize(templates{2}, scales(s)) imresize(templates{3}, scales(s)) imresize(templates{4}, scales(s))}; 
        windowCandidates = [windowCandidates; templateCorrelation(im, templates, threshods)];
    end
    pick = max_nms(windowCandidates, 0.05);
    windowCandidates = windowCandidates(pick);
end

function [windowCandidates] = SubsCandidateGenerationWindow(im, pixelCandidates, window_method, templates )
    scales = [0.4 0.6]; %0.8 1.0 1.2 1.4];
    windowCandidates = [];
    threshods = [0.68 0.88 0.44 0.43];
    
    im = rgb2gray(im);
    
    for s=1:size(scales,2)
        templates = {imresize(templates{1}, scales(s)) imresize(templates{2}, scales(s)) imresize(templates{3}, scales(s)) imresize(templates{4}, scales(s))}; 
        windowCandidates = [windowCandidates; templateSubstraction(im, templates, threshods)];
    end
    pick = min_nms(windowCandidates, 0.05);
    windowCandidates = windowCandidates(pick);
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
