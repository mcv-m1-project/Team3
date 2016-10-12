function Guillem_best_th()
    % Guillem_best_th
    % Function to find a good threshold.
    %
    % [] = Guillem_best_th()
    %
    %    Parameter name      Value
    %    --------------      -----
    %
    % The function finds the best threshold for each image.
    
    % For each image in the train set
    train_set = '../SplitDataset/train';
    
    files = ListFiles(train_set);
    
    nFiles = size(files, 1);
    disp(sprintf('Training with %d Files', nFiles));
    
    for i=1:nFiles
        if (mod(i, 25) == 0)
            i
        end
        
        % Read file
        im = imread(strcat(train_set,'/',files(i).name));
        im_r = im(:,:,1);
        im_g = im(:,:,2);
        im_b = im(:,:,3); 
        mask = imread(strcat(train_set, '/mask/mask.',strrep(files(i).name, '.jpg', '.png'))) > 0;
        gt = strcat(train_set, '/gt/gt.',strrep(files(i).name, '.jpg', '.txt'));
        
        fid = fopen(gt);
        bboxes=textscan(fid,'%f %f %f %f %s','delimiter',' ');
        fclose(fid);
        
        imshow(im);
        segmentation = zeros(size(mask));
        
        for j=1:length(bboxes{1})
                        
            bbox = [bboxes{1}(j) bboxes{2}(j) bboxes{3}(j) bboxes{4}(j)];
            label = bboxes{5}(j);
            
            % The mask may contain two signals. Use only the one
            % corresponding to the current bounding box
            mask_signal = zeros(size(mask)) > 1;
            mask_signal(bbox(1):bbox(3), bbox(2):bbox(4)) = mask(bbox(1):bbox(3), bbox(2):bbox(4)) > 0;
            
            if sum(mask_signal(:)) == 0 % there is no mask for this signal :(
                continue;
            end 
            
            % mean intensity on the red channel for that signal
            mean_r = mean(im_r(mask_signal));
            % mean intensity on the green channel for that signal
            mean_g = mean(im_g(mask_signal));
            % mean intensity on the blue channel for that signal
            mean_b = mean(im_b(mask_signal));
            
            mean_w = mean([mean_r mean_g mean_b]);
            

            mask_signal(mask_signal) = xor(mask_signal(mask_signal), (im_r(mask_signal) > mean_w & im_g(mask_signal) > mean_w & im_b(mask_signal) > mean_w));
            
            k = waitforbuttonpress;
            imshow(mask_signal)
            
            if strcmp(label, 'A') || strcmp(label, 'B') || strcmp(label, 'C')
                % Define threshold to find red signals
                th_r = min(im_r(mask_signal));
                th_g = mean(im_g(mask_signal));
                th_b = mean(im_b(mask_signal));
                color = 'red';
                thresh = [th_r, th_g, th_b]
                pixelCandidates = CandidateGenerationPixel_Color(im, thresh, color);
            else
                th_r = mean(im_r(mask_signal));
                th_g = mean(im_g(mask_signal));
                th_b = min(im_b(mask_signal));
                color = 'blue';
                thresh = [th_r, th_g, th_b]
                pixelCandidates = CandidateGenerationPixel_Color(im, thresh, color);
            end

            
            
            segmentation = segmentation | pixelCandidates;
        end
        
        k = waitforbuttonpress;
        imshow(segmentation);
        k = waitforbuttonpress;
    end
    
end

function [pixelCandidates] = CandidateGenerationPixel_Color(im, thresh, color)

    im=double(im);
    
    if strcmp(color, 'blue')
        pixelCandidates = im(:,:,1) < thresh(1) & im(:,:,2) < thresh(2) & im(:,:,3) > thresh(3);
    else
        pixelCandidates = im(:,:,1) > thresh(1) & im(:,:,2) < thresh(2) & im(:,:,3) < thresh(3);
    end
    
end  