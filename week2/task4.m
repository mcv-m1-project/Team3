function  task4( train_set )
    % Implement Histogram Back Projection
    % ARGUMENTS:
    %   - train_set:        Path where the train set is located.  
    
    files = ListFiles(train_set);
    nFiles = size(files, 1);
    disp(sprintf('Training with %d Files', nFiles));
    
    bins = 64;
    
    red_hist = zeros(bins);
    blue_hist = zeros(bins);
    rb_hist = zeros(bins);
    
    %---------- START DATASET -------------
    for i=1:nFiles
        if (mod(i, 25) == 0)
            i
        end
        
        % Read the image
        im = imread(strcat(train_set,'/',files(i).name));
%         imshow(im);
%         k = waitforbuttonpress;
        % Convert the image into HSV
        im = rgb2hsv(im);
        im_h = im(:,:,1);
        im_s = im(:,:,2);
        im_v = im(:,:,3);

        % Read the mask image
        mask = imread(strcat(train_set, '/mask/mask.',strrep(files(i).name, '.jpg', '.png'))) > 0;
        gt = strcat(train_set, '/gt/gt.',strrep(files(i).name, '.jpg', '.txt'));
        
        % read the gt txt file
        fid = fopen(gt);
        bboxes=textscan(fid,'%f %f %f %f %s','delimiter',' ');
        fclose(fid);
        
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
                continue
            end
                        
            % build 2D histogram for the image
            im_hist = buildHist(im_h(mask_signal), im_s(mask_signal), bins);
            % end 2D histogram
            
            % for the red traffic signs (A, B, C)
            if strcmp(label, 'A') || strcmp(label, 'B') || strcmp(label, 'C')
                red_hist = red_hist + im_hist;
            elseif strcmp(label, 'D') || strcmp(label, 'F') % for the blue sign (D, F)
                blue_hist = blue_hist + im_hist;
            elseif strcmp(label, 'E') % for the red and blue sign (E)
                rb_hist = rb_hist + im_hist;
            end
        end
    
    end
    red_hist = red_hist ./ sum(red_hist(:));
    blue_hist = blue_hist ./ sum(blue_hist(:));
    rb_hist = rb_hist ./ sum(rb_hist(:));
    %---------- END DATASET -------------

    load('red_hist.mat');
    load('blue_hist.mat');
    load('rb_hist.mat');
    
    red_hist(:,1:10) = 0;
    blue_hist(:,1:10) = 0;
    rb_hist(:,1:10) = 0;
    
    %---------- EVAL DATASET -------------
    for i=1:nFiles
        if (mod(i, 25) == 0)
            i
        end
        
        % Read the image
        im = imread(strcat(train_set,'/',files(i).name));
        imshow(im);
        k = waitforbuttonpress;
        % Convert the image into HSV
        im = rgb2hsv(im);
        im_h = im(:,:,1);
        im_s = im(:,:,2);
        im_v = im(:,:,3);

        % Read the mask image
        mask = imread(strcat(train_set, '/mask/mask.',strrep(files(i).name, '.jpg', '.png'))) > 0;
        
        segmentation = zeros(size(mask));
        segmentation = reshape(segmentation, [size(segmentation, 1)*size(segmentation, 2), 1]);
        
        pixels = [im_h(:) im_s(:)];
        pixels = ceil(pixels*bins); % from pixels to bins
        pixels(pixels==0) = 1;
        
        mean_red = mean(red_hist(:));
        mean_blue = mean(blue_hist(:));
        mean_rb = mean(rb_hist(:));
        
        for p=1:size(segmentation, 1)
            if (mod(p, 10000) == 0)
                p
            end
            hist_i = pixels(p,1);
            hist_j = pixels(p,2);
            %segmentation(p) = (blue_hist(hist_i, hist_j) > 0.001);
            segmentation(p) = (red_hist(hist_i, hist_j) > 0.007) | (blue_hist(hist_i, hist_j) > 0.007) | (rb_hist(hist_i, hist_j) > 0.007);
        end
        segmentation = reshape(segmentation, size(mask));
        imshow(segmentation);
        k = waitforbuttonpress;
    end
    %---------- END EVAL -------------
        
end

function im_hist = buildHist(im_h, im_s, bins)
    pixels = [im_h(:) im_s(:)];
    hist_indexes = ceil(pixels*bins); % From pixels to bins
    hist_indexes(hist_indexes<1) = 1; % make 0 indexes become 1
    im_hist = zeros(bins);
    for p=1:size(hist_indexes,1)
        im_hist(hist_indexes(p,1), hist_indexes(p,2)) = im_hist(hist_indexes(p,1), hist_indexes(p,2)) + 1;
    end
end
