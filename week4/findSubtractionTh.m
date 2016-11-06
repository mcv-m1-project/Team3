function [ output_args ] = findSubtractionTh( directory )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
files = ListFiles(directory);
    nFiles = size(files, 1);
    disp(sprintf('Training with %d Files', nFiles));
    
    load('grayscaleTemps.mat');
    
    mask_templates = grayscaleTemps;

    results1 = [];
    results2 = [];
    results3 = [];
    results4 = [];

    %---------- START DATASET -------------
    for i=1:nFiles

        if (mod(i, 25) == 0)
            i
        end

        % Read file
        im = imread(strcat(directory,'/',files(i).name));
        im = rgb2gray(im);
        pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
        [windowAnnotations, signals] = LoadAnnotations(strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt'));
                
        for a=1:size(windowAnnotations, 1)

            win_i = int16(windowAnnotations(a).y-2);                win_i = max(1, win_i);
            win_i_end = win_i + int16(windowAnnotations(a).h+4);    win_i_end = min(win_i_end, size(pixelAnnotation, 1));
            win_j = int16(windowAnnotations(a).x-2);                win_j = max(1, win_j);
            win_j_end = win_j + int16(windowAnnotations(a).w+4);    win_j_end = min(win_j_end, size(pixelAnnotation, 2));
            
            try
                window = im2double( im(win_i:win_i_end, int16(win_j:win_j_end)) );
            catch
                a = 1
            end
            
            switch signals{a}
                case 'A' % up triangle
                    template = double(mask_templates{3}>0);
                    template = imresize(template, size(window));
                    result3 = imabsdiff(template, window);
                    result3 = sum(result3(:));
                    result3 = result3 / (size(window,1)*size(window,2)*255);
                    results3 = [results3; result3];
                case 'B' % down triangle
                    template = double(mask_templates{4}>0);
                    template = imresize(template, size(window));
                    result4 = imabsdiff(template, window);
                    result4 = sum(result4(:));
                    result4 = result4 / (size(window,1)*size(window,2)*255);
                    results4 = [results4; result4];
                case 'C' % circle
                    template = double(mask_templates{1}>0);
                    template = imresize(template, size(window));
                    result1 = imabsdiff(template, window);
                    result1 = sum(result1(:));
                    result1 = result1 / (size(window,1)*size(window,2)*255);
                    results1 = [results1; result1];
                case 'D' % circle
                    template = double(mask_templates{1}>0);
                    template = imresize(template, size(window));
                    result1 = imabsdiff(template, window);
                    result1 = sum(result1(:));
                    result1 = result1 / (size(window,1)*size(window,2)*255);
                    results1 = [results1; result1];
                case 'E' % circle
                    template = double(mask_templates{1}>0);
                    template = imresize(template, size(window));
                    result1 = imabsdiff(template, window);
                    result1 = sum(result1(:));
                    result1 = result1 / (size(window,1)*size(window,2)*255);
                    results1 = [results1; result1];
                case 'F' % square
                    template = double(mask_templates{2}>0);
                    template = imresize(template, size(window));
                    result2 = imabsdiff(template, window);
                    result2 = sum(result2(:));
                    result2 = result2 / (size(window,1)*size(window,2)*255);
                    results2 = [results2; result2];
            end
            
%             template = imresize(template, size(window));
%             result = template.*window;
%             result = sum(result(:));
%             result = result / (size(window,1)*size(window,2));
%             results = [results; result];
        end        
        
    end
    %---------- END DATASET -------------
    disp('Results template 1');
    min(results1(:))
    max(results1(:))
    mean(results1(:))
    std(results1(:))
    disp('Results template 2');
    min(results2(:))
    max(results2(:))
    mean(results2(:))
    std(results2(:))
    disp('Results template 3');
    min(results3(:))
    max(results3(:))
    mean(results3(:))
    std(results3(:))
    disp('Results template 4');
    min(results4(:))
    max(results4(:))
    mean(results4(:))
    std(results4(:))

end

