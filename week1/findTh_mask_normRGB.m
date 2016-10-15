function findTh_mask_normRGB( train_set )
    % findTh_mask_normRGB
    % Function to find the best threshold in normRGB color space
    %
    %
    %    Parameter name      Value
    %    --------------      -----
    %
    % The function finds the best threshold for each image.
    
    % List images
    files = ListFiles(train_set);
    nFiles = size(files, 1);
    disp(sprintf('Training with %d Files', nFiles));
    
    red_thresh = [];
    blue_thresh = [];
    
    % for each file
    for i=1:nFiles
        if (mod(i, 25) == 0)
            i
        end
        
        % Read file
        im = double(imread(strcat(train_set,'/',files(i).name)));
        
        % normalize RGB
        im = NormRGB(im);
        im_r = im(:,:,1);
        im_g = im(:,:,2);
        im_b = im(:,:,3);
        
        % read the image mask
        mask = imread(strcat(train_set, '/mask/mask.',strrep(files(i).name, '.jpg', '.png'))) > 0;
        gt = strcat(train_set, '/gt/gt.',strrep(files(i).name, '.jpg', '.txt'));
        
        % read the gt txt file
        fid = fopen(gt);
        bboxes=textscan(fid,'%f %f %f %f %s','delimiter',' ');
        fclose(fid);
        
        segmentation = zeros(size(mask));
        
        % for each bounding box in the image
        for j=1:length(bboxes{1})
            % get the current bounding box
            bbox = [bboxes{1}(j) bboxes{2}(j) bboxes{3}(j) bboxes{4}(j)];
            label = bboxes{5}(j);
            
            % The mask may contain two signals. Use only the one
            % corresponding to the current bounding box
            mask_signal = zeros(size(mask)) > 1;
            mask_signal(bbox(1):bbox(3), bbox(2):bbox(4)) = mask(bbox(1):bbox(3), bbox(2):bbox(4)) > 0;
            
            % If the mask is empty, skip the current image
            if sum(mask_signal(:)) == 0 
                continue;
            end 
            
            %mask_signal(mask_signal) = xor(mask_signal(mask_signal), (im_r(mask_signal) > 0.27 & im_g(mask_signal) > 0.27 & im_b(mask_signal) > 0.27));
            
%           imshow(mask_signal)
%           k = waitforbuttonpress;
            
            % for the red traffic signs (A, B, C)
            if strcmp(label, 'A') || strcmp(label, 'B') || strcmp(label, 'C')
                % Define threshold to find red signals
                % Get the min value of the red channel inside the mask
                th_r = min(im_r(mask_signal));
                % Get the mean of the green channel inside the mask
                th_g = mean(im_g(mask_signal));
                % Get the mean of the blue channel inside the mask
                th_b = mean(im_b(mask_signal));
                color = 'red';
                
                % Store the thresholds
                thresh = [th_r, th_g, th_b]
                red_thresh = [red_thresh; thresh];
                pixelCandidates = CandidateGenerationPixel_Color(im, thresh, color);
            % for the red and blue sign (E)
            elseif strcmp(label, 'E')
                % red
                % Get the min value of the red channel inside the mask
                th_r = min(im_r(mask_signal));
                % Get the mean of the green channel inside the mask
                th_g = mean(im_g(mask_signal));
                % Get the mean of the blue channel inside the mask
                th_b = mean(im_b(mask_signal));
                color = 'red';
                
                % Store the thresholds
                thresh = [th_r, th_g, th_b]
                red_thresh = [red_thresh; thresh];
                % Evaluate the thresholds
                pixelCandidates = CandidateGenerationPixel_Color(im, thresh, color);
                
                % blue
                % Get the mean of the red channel inside the mask
                th_r = mean(im_r(mask_signal));
                % Get the mean of the green channel inside the mask
                th_g = mean(im_g(mask_signal));
                % Get the min of the blue channel inside the mask
                th_b = min(im_b(mask_signal));
                color = 'blue';
                
                % Store the thresholds
                thresh = [th_r, th_g, th_b]
                blue_thresh = [blue_thresh; thresh];
                % Evaluate the thresholds
                pixelCandidates = pixelCandidates | CandidateGenerationPixel_Color(im, thresh, color);
            % for the blue signs(D, F)
            else
                % Get the mean of the red channel inside the mask
                th_r = mean(im_r(mask_signal));
                % Get the mean of the green channel inside the mask
                th_g = mean(im_g(mask_signal));
                 % Get the min of the blue channel inside the mask
                th_b = min(im_b(mask_signal));
                color = 'blue';
                
                % Store thresholds
                thresh = [th_r, th_g, th_b]
                blue_thresh = [blue_thresh; thresh];
                % Evaluate the thresholds
                pixelCandidates = CandidateGenerationPixel_Color(im, thresh, color);
            end

            segmentation = segmentation | pixelCandidates;
        end
        
%         subplot(1,2,1), imshow(im);
%         subplot(1,2,2), imshow(segmentation);
%         imshow(im);
%         a = ginput(1)
%         im(int16(a(2)), int16(a(1)), :)
%         k = waitforbuttonpress;
    end
    disp(sprintf('Red th: '));
    mean(red_thresh)
    disp(sprintf('Red th: '));
    mean(blue_thresh)
end

function [pixelCandidates] = CandidateGenerationPixel_Color(im, thresh, color)

    im=double(im);
    
    if strcmp(color, 'blue')
        pixelCandidates = im(:,:,1) < thresh(1) & im(:,:,2) < thresh(2) & im(:,:,3) > thresh(3);
    else
        pixelCandidates = im(:,:,1) > thresh(1) & im(:,:,2) < thresh(2) & im(:,:,3) < thresh(3);
    end
    
end  