function [ output_args ] = cannyFinder( path_mask, path_img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    loadCannyVariables();
    file = fopen('best_canny.txt','w');
    
    f = dir(path_img);
    finalCandidates = [];
    
    for th_low=0:0
        for th_high=9:9
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

                            im = edge(im, 'Canny', [th_low/10 th_high/10], sqrt(sigma));

                            absDiff = absDiff + imabsdiff(mask, im);%/ (size(mask,1)*(size(mask,2))));
                            corrDiff = corrDiff + (mask .* im);% / (size(mask,1)*(size(mask,2))));
                            count = count+1;
                        end

                    end
                end
                absDiff = sum(sum(absDiff))/count;
                corrDiff = sum(sum(corrDiff))/count;

                fprintf(file, 'Canny: th: [%f %f], sigma: sqrt(%f), absDiff: %f, corrDiff: %f\n', th_low/10, th_high/10, sigma, absDiff, corrDiff);
            end
        end
    end
    
    for th=0:10
        for direction =[{'horizontal'} {'vertical'} {'both'}]
            absDiff = 0;
            corrDiff = 0;
            count = 0;
            for i=1:size(f,1)
                if f(i).isdir==0,
                    if strcmp(f(i).name(end-2:end),'jpg')==1,
                        im = rgb2gray(imread(strcat(path_img, f(i).name)));
                        mask = imread(strcat(path_mask, 'mask.', f(i).name(1:end-3), 'png')) > 0;

                        mask = edge(mask, 'Canny');

                        im = edge(im, 'Sobel', th/10, cell2mat(direction));

                        absDiff = absDiff + imabsdiff(mask, im);%/ (size(mask,1)*(size(mask,2))));
                        corrDiff = corrDiff + (mask .* im);% / (size(mask,1)*(size(mask,2))));
                        count = count+1;
                    end

                end
            end
            absDiff = sum(sum(absDiff))/count;
            corrDiff = sum(sum(corrDiff))/count;

            fprintf(file, 'Sobel: th: %f, direction: %s, absDiff: %f, corrDiff: %f\n', th/10, cell2mat(direction), absDiff, corrDiff);
        end
    end
    
    
    for th=0:10
        for direction =[{'horizontal'} {'vertical'} {'both'}]
            absDiff = 0;
            corrDiff = 0;
            count = 0;
            for i=1:size(f,1)
                if f(i).isdir==0,
                    if strcmp(f(i).name(end-2:end),'jpg')==1,
                        im = rgb2gray(imread(strcat(path_img, f(i).name)));
                        mask = imread(strcat(path_mask, 'mask.', f(i).name(1:end-3), 'png')) > 0;

                        mask = edge(mask, 'Canny');

                        im = edge(im, 'Prewitt', th/10, cell2mat(direction));

                        absDiff = absDiff + imabsdiff(mask, im);%/ (size(mask,1)*(size(mask,2))));
                        corrDiff = corrDiff + (mask .* im);% / (size(mask,1)*(size(mask,2))));
                        count = count+1;
                    end

                end
            end
            absDiff = sum(sum(absDiff))/count;
            corrDiff = sum(sum(corrDiff))/count;

            fprintf(file, 'Prewitt: th: %f, direction: %s, absDiff: %f, corrDiff: %f\n', th/10, cell2mat(direction), absDiff, corrDiff);
        end
    end
    
    
    for th=0:10
        absDiff = 0;
        corrDiff = 0;
        count = 0;
        for i=1:size(f,1)
            if f(i).isdir==0,
                if strcmp(f(i).name(end-2:end),'jpg')==1,
                    im = rgb2gray(imread(strcat(path_img, f(i).name)));
                    mask = imread(strcat(path_mask, 'mask.', f(i).name(1:end-3), 'png')) > 0;

                    mask = edge(mask, 'Canny');

                    im = edge(im, 'Roberts', th/10, cell2mat(direction));

                    absDiff = absDiff + imabsdiff(mask, im);%/ (size(mask,1)*(size(mask,2))));
                    corrDiff = corrDiff + (mask .* im);% / (size(mask,1)*(size(mask,2))));
                    count = count+1;
                end

            end
        end
        absDiff = sum(sum(absDiff))/count;
        corrDiff = sum(sum(corrDiff))/count;

        fprintf(file, 'Roberts: th: %f, absDiff: %f, corrDiff: %f\n', th/10, absDiff, corrDiff);
    end
    
    for th_low=0
        for th_high=9:9
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

                            im = edge(im, 'log', [th_low/10 th_high/10], sqrt(sigma));

                            absDiff = absDiff + imabsdiff(mask, im);%/ (size(mask,1)*(size(mask,2))));
                            corrDiff = corrDiff + (mask .* im);% / (size(mask,1)*(size(mask,2))));
                            count = count+1;
                        end

                    end
                end
                absDiff = sum(sum(absDiff))/count;
                corrDiff = sum(sum(corrDiff))/count;

                fprintf(file, 'Log: th: [%f %f], sigma: sqrt(%f), absDiff: %f, corrDiff: %f\n', th_low/10, th_high/10, sigma, absDiff, corrDiff);
            end
        end
    end
    


end

