function [ output_args ] = task1( pathGt, pathMask )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   myData = readData('train/gt/', 'train/mask/');


    files = dir(pathGt);
    error=0;
    gtObjs = [];
    for i=1:length(files)
        if (strcmp(files(i).name(1:1), 'g'))
            fid = fopen(strcat(pathGt, files(i).name));
            
            %files(i).name
            data=textscan(fid,'%f %f %f %f %s','delimiter',' ');
            fclose(fid);
            
            for j=1:length(data{1})
                try
                    mask = imread(strcat(pathMask, 'mask', files(i).name(3:end-3), 'png'));
                    gtObjs = [gtObjs; getObjData(data{1}(j),data{2}(j),data{3}(j),data{4}(j),data{5}(j), mask, files(i).name)];
                catch
                    error = error+1;
                end
            end
        end
    end
    
    %error
    %output_args = gtObjs;
    
    
    c= unique(gtObjs(:,5));
    y = zeros(size(c,1),1);
    for i = 1:size(c,1)
        for j=1:size(gtObjs(:,5),1)
           if (strcmp(gtObjs(j,5),c(i)))
              y(i) = y(i) +1; 
           end
        end
    end
    clases = c;
    reps = y;
    
    %sprintf(' reps
    %clases
    %gtObjs
   
    disp( sprintf('maxSize: %f ', max(cell2mat(gtObjs(:,3)))));
    disp( sprintf('minSize: %f ', min(cell2mat(gtObjs(:,3)))));
    disp( sprintf('avgSize: %f ', mean(cell2mat(gtObjs(:,3)))));
    disp( sprintf('stdSize: %f \n', std(cell2mat(gtObjs(:,3)))));
    
    disp( sprintf('maxAspectRatio: %f ', max(cell2mat(gtObjs(:,4)))));
    disp( sprintf('minAspectRatio: %f ', min(cell2mat(gtObjs(:,4)))));
    disp( sprintf('avgAspectRatio: %f ', mean(cell2mat(gtObjs(:,4)))));
    disp( sprintf('stdAspectRatio: %f \n', std(cell2mat(gtObjs(:,4)))));
    
    disp (sprintf('Frequency of Appearance:\n'));
    for i=1:size(c,1)
        disp (sprintf('%s: %f \n', cell2mat(clases(i)), reps(i)));
    end
    
    %output_args = [gtObjs, clases, reps];
    
end


function [ output_args ] = getObjData(x1, y1, x2, y2, type, mask, name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    width = (x2-x1);
    height = (y2-y1);
    size = (x2-x1)*(y2-y1);
    formFactor = (x2-x1)/(y2-y1);
    type = type;
    img = mask(uint8(x1):uint8(x2), uint8(y1):uint8(y2));
    fillingRatio = sum(img(:)) / numel(img);

    output_args = [ width, height, size, formFactor, type, fillingRatio, name];
end




