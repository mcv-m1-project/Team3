function [ output_args ] = dataset2mat( pathGt, pathImg, pathMask )
%Read the dataset and store it into a cell array Format: {Image; mask; BoundingBox}
%arguments:  pathGT: directory of the gt
%            pathImg: directory of the images
%            pathMask: directory of the image masks
%return:     cell array containing all the dataset data
    
    % List files of the directory
    files = dir(pathImg);
    files = files(3:end-2);
    
    for i = 1 : length(files)
        if (strcmp(files(i).name(1:1), '0'))
            % Open GT file and get bounding boxes
            fid = fopen(strcat(pathGt,'gt.', files(i).name(1:end-3), 'txt'));
            
            it = 1;
            while ~feof(fid)
                % Read line from the ground truth file
                tline = fgetl(fid);
                cline = strsplit(tline);
                
                % cast the bounding box info into floats
                bb{it,1} = { str2num(cline{1}), str2num(cline{2}), str2num(cline{3}), str2num(cline{4}), cline{5} };
                it = it + 1;
            end
            fclose(fid);
            
            % Read image and mask
            image = imread(strcat(pathImg, files(i).name));
            mask = imread(strcat(pathMask, 'mask.', files(i).name(1:end-3), 'png'));
            
            % Store each sample of the dataset into the cell array {image, mask, boundingbox}
            dataset{i, 1} = {image, mask, bb};
            
            % Clear the bb cell array
            bb = {};
        end
    end
    % Save the cell array into a mat
    %save('tDataset', 'dataset');
    
    output_args = dataset;
end

