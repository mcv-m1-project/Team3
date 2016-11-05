function findChamferTh( directory )
%findChamferTh Summary of this function goes here
%   Detailed explanation goes here

    files = ListFiles(directory);
    nFiles = size(files, 1);
    disp(sprintf('Training with %d Files', nFiles));
    
    mask_templates = {rgb2gray(imread('mask_templates/circle.png'))>0 rgb2gray(imread('mask_templates/square.png'))>0 rgb2gray(imread('mask_templates/triangle.png'))>0 rgb2gray(imread('mask_templates/triangle_down.png'))>0};

    results = [];
    %---------- START DATASET -------------
    for i=1:nFiles

        if (mod(i, 25) == 0)
            i
        end

        % Read file
        im = imread(strcat(directory,'/',files(i).name));
        pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
        [windowAnnotations, signals] = LoadAnnotations(strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt'));
                
        for a=1:size(windowAnnotations, 1)

            win_i = int16(windowAnnotations(a).y-2);                win_i = max(1, win_i);
            win_i_end = win_i + int16(windowAnnotations(a).h+4);    win_i_end = min(win_i_end, size(pixelAnnotation, 1));
            win_j = int16(windowAnnotations(a).x-2);                win_j = max(1, win_j);
            win_j_end = win_j + int16(windowAnnotations(a).w+4);    win_j_end = min(win_j_end, size(pixelAnnotation, 2));
            
            try
                window = pixelAnnotation(win_i:win_i_end, int16(win_j:win_j_end));
            catch
                a = 1
            end
            edg = edge(window, 'Canny');
            dist = bwdist(edg);
            
            switch signals{a}
                case 'A' % up triangle
                    template = double(mask_templates{3}>0);
                case 'B' % down triangle
                    template = double(mask_templates{4}>0);
                case 'C' % circle
                    template = double(mask_templates{1}>0);
                case 'D' % circle
                    template = double(mask_templates{1}>0);
                case 'E' % circle
                    template = double(mask_templates{1}>0);
                case 'F' % square
                    template = double(mask_templates{2}>0);
            end                    
            
            template = imresize(template, size(dist));
            template = double(edge(template, 'Canny'));

            result = sum(template.*dist);
            result = sum(result(:))/((size(dist, 1)*size(dist, 2)));
            results = [results; result];
        end
        
        result
        
        
    end
    %---------- END DATASET -------------
    
    min(results(:))
    max(results(:))

end
