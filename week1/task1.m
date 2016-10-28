function [ output_args ] = task1( pathGt, pathMask )
%TASK 1 - week 1. Dataset statistics
%arguments:  pathGT: directory of the gt, i.e 'DataSetDelivered/train/gt/'
%            pathMask: directory of the image masks , i.e 'DataSetDelivered/train/masks/'

    files = dir(pathGt); % List all ground truth files  
    error=0;
    gtObjs = [];
    for i=1:length(files)
        if (strcmp(files(i).name(1:1), 'g'))
            fid = fopen(strcat(pathGt, files(i).name));
            
            % Data will have N rows, where N are the number of lines in the
            % ground truth file.
            % data contains: x1, y1, x2, y2, LABEL
            data=textscan(fid,'%f %f %f %f %s','delimiter',' ');
            fclose(fid);
            
            for j=1:length(data{1})
                %try
                    mask = imread(strcat(pathMask, 'mask', files(i).name(3:end-3), 'png')) > 0;                      
                    gtObjs = [gtObjs; getObjData(data{1}(j),data{2}(j),data{3}(j),data{4}(j),data{5}(j), mask, files(i).name)];
                %catch
                    % If there are errosr loading data, count them
                 %   error = error+1;
                %end
            end
        end
    end   
    
    clases = unique(gtObjs(:,5)); % Get the different classes
    reps = zeros(size(clases,1),1); % Matrix of size (number_classes, 1) used to count the number of signals of each type
    for i = 1:size(clases,1)
        for j=1:size(gtObjs(:,5),1)
           if (strcmp(gtObjs(j,5),clases(i)))
              reps(i) = reps(i) +1; 
           end
        end
    end
   
    disp( sprintf('maxSize: %f ', max(cell2mat(gtObjs(:,3)))));
    disp( sprintf('minSize: %f ', min(cell2mat(gtObjs(:,3)))));
    disp( sprintf('avgSize: %f ', mean(cell2mat(gtObjs(:,3)))));
    disp( sprintf('stdSize: %f \n', std(cell2mat(gtObjs(:,3)))));
    
    disp( sprintf('maxWidth: %f ', max(cell2mat(gtObjs(:,1)))));
    disp( sprintf('minWidth: %f ', min(cell2mat(gtObjs(:,1)))));
    disp( sprintf('avgWidth: %f ', mean(cell2mat(gtObjs(:,1)))));
    disp( sprintf('stdWidth: %f \n', std(cell2mat(gtObjs(:,1)))));
    
    disp( sprintf('maxHeight: %f ', max(cell2mat(gtObjs(:,2)))));
    disp( sprintf('minHeight: %f ', min(cell2mat(gtObjs(:,2)))));
    disp( sprintf('avgHeight: %f ', mean(cell2mat(gtObjs(:,2)))));
    disp( sprintf('stdHeight: %f \n', std(cell2mat(gtObjs(:,2)))));
    
    disp( sprintf('maxAspectRatio: %f ', max(cell2mat(gtObjs(:,4)))));
    disp( sprintf('minAspectRatio: %f ', min(cell2mat(gtObjs(:,4)))));
    disp( sprintf('avgAspectRatio: %f ', mean(cell2mat(gtObjs(:,4)))));
    disp( sprintf('stdAspectRatio: %f \n', std(cell2mat(gtObjs(:,4)))));
    
    disp( sprintf('maxFillingRatio: %f ', max(cell2mat(gtObjs(:,6)))));
    disp( sprintf('minFillingRatio: %f ', min(cell2mat(gtObjs(:,6)))));
    disp( sprintf('avgFillingRatio: %f ', mean(cell2mat(gtObjs(:,6)))));
    disp( sprintf('stdFillingRatio: %f \n', std(cell2mat(gtObjs(:,6)))));
    
    disp (sprintf('Frequency of Appearance:'));
    for i=1:size(clases,1)
        disp (sprintf('%s: %f %%', cell2mat(clases(i)), reps(i)/sum(reps(:))*100 ));
    end
    
    if error
       sprintf('Error loading %d images', error); 
    end
    output_args = gtObjs;
    
end


function [ output_args ] = getObjData(x1, y1, x2, y2, type, mask_img, name)
%getObjData - This function computes information for one image
%   Receives the ground truth information of a signal and computes relevant
%   information.
%   Parameter name      Value
%   --------------      -----
%   'x1'                Bounding box x1 coordinate
%   'y1'                Bounding box y1 coordinate
%	'x2'                Bounding box x2 coordinate
%	'y2'            	Bounding box y1 coordinate
%	'type'              Label of the traffic sign
%	'mask_img'          Mask image
%	'name'              Name of the groundtruth file

    width = (x2-x1);
    height = (y2-y1);
    size = (x2-x1)*(y2-y1);
    formFactor = (x2-x1)/(y2-y1);
    
    img = mask_img(uint16(x1):uint16(x2), uint16(y1):uint16(y2));
    
    fillingRatio = sum(img(:)) / numel(img);
    
%     imshow(mask_img);    
%     hold on;
%     % Then, from the help:
%     rectangle('Position',[y1,x1,height,width],'EdgeColor','r');
%     k = waitforbuttonpress;
    
    if fillingRatio == 0.0
        disp( sprintf('filling ratio is zero!') );
    end

    output_args = [ width, height, size, formFactor, type, fillingRatio, name];
end




