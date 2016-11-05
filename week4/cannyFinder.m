function [ output_args ] = cannyFinder( path_mask, path_img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    loadCannyVariables();
    file = fopen('best_canny.txt','w');
    
    f = dir(path_img);
    finalCandidates = [];
    
    for th_low=0:10
        for th_high=th_low+1:20
            for sigma=1:10
                absDiff = 0;
                corrDiff = 0;
                count = 0;
                for i=1:size(f,1)
                    if f(i).isdir==0,
                        if strcmp(f(i).name(end-2:end),'jpg')==1,
                            im = rgb2gray(imread(strcat(path_img, f(i).name)));
                            mask = imread(strcat(path_mask, 'mask.', f(i).name(1:end-3), 'png')) > 0;

                            mask = edge(mask, 'Canny');

                            im = edge(mask, 'Canny', [th_low/20 th_high/20], sqrt(sigma));

                            absDiff = absDiff + imabsdiff(mask, im);
                            corrDiff = corrDiff + (mask .* im);
                            count = count+1;
                        end

                    end
                end
                absDiff = sum(sum(absDiff))/count;
                corrDiff = sum(sum(corrDiff))/count;

                fprintf(file, 'th: [%f %f], sigma: %f, absDiff: %f, corrDiff: %f\n', th_low/20, th_high/20, sigma, absDiff, corrDiff);
            end
        end
    end
    
    


end

