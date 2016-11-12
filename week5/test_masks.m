function [ output_args ] = test_masks( input_args )

    directory = '../SplitDataset/train/';
    files = ListFiles(directory);

    nFiles = size(files, 1);
    
    all = zeros(1236,1628);
    
    for i=1:nFiles
        i
        im = imread(strcat(directory,'/',files(i).name));
        
        % Accumulate pixel performance of the current image %%%%%%%%%%%%%%%%%
        pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
        
        all = all | pixelAnnotation;
    end

    imshow(all);

end

