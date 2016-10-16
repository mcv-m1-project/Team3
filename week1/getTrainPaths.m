function [ imgPaths, maskPaths ] = getTrainPaths( path )
    files = dir(path);
    imgPaths = [];
    maskPaths = [];
    for i=1:length(files)
        if (length(files(i).name) > 4 && strcmp(files(i).name(end-2:end), 'jpg'))
            imgPaths = [imgPaths; strcat(path, files(i).name)];
            mask = strcat(path, 'mask/mask.', files(i).name(1:end-3), 'png');
            maskPaths = [maskPaths; mask];            
        end
    end
end

