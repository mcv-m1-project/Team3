function [ output_args ] = test_global_mean_shift( input_args )
    load('clustCent.mat');
    load('clustMembsCell.mat');
    Kms = length(clustMembsCell)
    
    directory = '../SplitDataset/val/';
    files = ListFiles(directory);
    
    addpath('evaluation')

    nFiles = size(files, 1);
    
    global RESCALE;         RESCALE = 0.5;
    
    pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
    
    % morf element
    element=strel('diamond',4*RESCALE);

    for i=1:nFiles
        i
        %im = imread('../SplitDataset/train/00.005938.jpg');
        %im = imread('../SplitDataset/train/00.005004.jpg');
        im = imread(strcat(directory,'/',files(i).name));
        
        imorig = imresize(im, RESCALE);
        im = NormRGB(double(imorig));
        im = im2double(im);
        
        % Accumulate pixel performance of the current image %%%%%%%%%%%%%%%%%
        pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
        pixelAnnotation = imresize(pixelAnnotation, RESCALE);
        
        %tic
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
        %toc
% 
%         imshow(im);
%         waitforbuttonpress;

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

        %pixelCandidates = pixelCandidates & im_v > v_th(1) & im_v < v_th(2);
        
%         imshow(pixelCandidates);
%         waitforbuttonpress;
        
        pixelCandidates(round(size(pixelCandidates, 1)/2):end, :) = 0;
        
%         imshow(pixelCandidates);
%         waitforbuttonpress;
        
        % MORF
        pixelCandidates = morf(pixelCandidates, element);

%         imshow(pixelCandidates);
%         waitforbuttonpress;
        
        [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
        pixelTP = pixelTP + localPixelTP;
        pixelFP = pixelFP + localPixelFP;
        pixelFN = pixelFN + localPixelFN;
        pixelTN = pixelTN + localPixelTN;
        
    end
    
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);

    disp(sprintf('PIXEL INFORMATION'));
    disp(sprintf('Precision: %f', pixelPrecision));
    disp(sprintf('Accuracy: %f', pixelAccuracy));
    disp(sprintf('Specificity: %f', pixelSpecificity));
    disp(sprintf('Sensitivity (Recall): %f', pixelSensitivity));
    disp(sprintf('F1 score: %f', pixelF1));
    disp(sprintf('TP: %f', pixelTP));
    disp(sprintf('FP: %f', pixelFP));
    disp(sprintf('FN: %f', pixelFN));

end

