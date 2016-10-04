function [ output_args ] = readData( pathGt, pathMask )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   myData = readData('train/gt/', 'train/mask/');


    files = dir(pathGt);
    
    gtObjs = [];
    for i=1:length(files)
        if (strcmp(files(i).name(1:1), 'g'))
            fid = fopen(strcat(pathGt, files(i).name));
            
            data=textscan(fid,'%f %f %f %f %s','delimiter',' ');
            fclose(fid);
            for j=1:length(data{1})
                try
                    mask = imread(strcat(pathMask, 'mask', files(i).name(3:end-3), 'png'));
                    gtObjs = [gtObjs; gtObject(data{1}(j),data{2}(j),data{3}(j),data{4}(j),data{5}(j), mask)];
                catch
                end
            end
        end
    end
    
    output_args = gtObjs;
    
end

