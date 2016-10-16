function [ output_args ] = task2(pathGt, pathImg, pathMask, pathSplit)
%Task 2 - week 1
%arguments:  pathGT: directory of the gt
%            pathImg: directory of the images
%            pathMask: directory of the image masks
%            pathSplit: directory where the split folder will be generated.
%               it must end with '/'.
    
    % Read the dataset
    dataset = dataset2mat(pathGt, pathImg, pathMask);
    
    % Split data into train and validation
    dataSplit = split(dataset, 0.7);
    
    trainSplit = dataSplit{1,1};
    valSplit = dataSplit{2,1};
    save('trainSplit.mat', 'trainSplit');
    save('valSplit.mat', 'valSplit');
        
    CreateSplitFolder(trainSplit, valSplit, pathSplit);    
end

function [ output_args ] = groupClasses(dataset)
%Group the samples by label into different cell arrays
%arguments:  dataset: cell array containing the dataset
%return:     cell array with the samples divided into classes
    
    % Cell arrays for each label
    classA = {};
    classB = {};
    classC = {};
    classD = {};
    classE = {};
    classF = {};
    
    for i = 1 : length(dataset)
        % Read the label of each sample and store into cell array
        switch dataset{i,1}{1,3}{1,1}{1,5}
            case 'A' 
                classA{end+1,1} = dataset{i,1};
            case 'B' 
                classB{end+1,1} = dataset{i,1};
            case 'C' 
                classC{end+1,1} = dataset{i,1};
            case 'D' 
                classD{end+1,1} = dataset{i,1};
            case 'E' 
                classE{end+1,1} = dataset{i,1};
            case 'F' 
                classF{end+1,1} = dataset{i,1};
        end
    end
    output_args = {classA; classB; classC; classD; classE; classF};
end


function [ output_args ] = split( dataset, trainRatio)
%Split the dataset into training and validation sets
%arguments:  dataset: cell array containing the dataset
%            trainRatio: desired percentage of training
%return:     cell array with the train and validation split

    % Group the samples into classes
    classes = groupClasses(dataset);
    
    % Cell arrays to store train and validation splits
    trainSplit = {};
    valSplit = {};
    
    for i = 1 : length(classes)
        % Get the number of training samples
        tNum = round(length(classes{i,1}) * trainRatio);
        
        % Generate a random permutation of the ith class
        perm = randperm(length(classes{i,1}));
        newClasses = classes{i,1}(perm);
        
        % Store the splits for each class
        trainSplit{end+1,1} = newClasses(1:tNum);
        valSplit{end+1,1} = newClasses(tNum+1:end);
       
    end
    output_args = {trainSplit; valSplit};
end

function CreateSplitFolder(trainSplit, valSplit, pathSplit)
    % CreateSplitFolder
    % Function to create the folders containing the train and val splits. 
    %
    % [] = createSplitFolder(trainSplit, valSplit)
    %
    %    Parameter name     Value
    %    --------------     -----
    %    'trainSplit'       Cell array containing train images
    %    'valSplit'         Cell array containing val images
    %    'pathSplit'        Folder where the 'train' and 'val' sets will be
    %    created.

    % create split folders
    mkdir(pathSplit);
    mkdir(strcat(pathSplit, 'train/mask'));
    mkdir(strcat(pathSplit, 'val/mask'));
    mkdir(strcat(pathSplit, 'train/gt'));
    mkdir(strcat(pathSplit, 'val/gt'));
    
    disp(sprintf('Creating train and val directories.'));
    
    % copy files in train split directory
    for i=1:size(trainSplit, 1)% for each label
        for j=1:size(trainSplit{i,1},1) % for each image
            img_filename = trainSplit{i,1}{j,1}{1,1}; % get image path and name
            % get the path of the mask
            img_mask = strrep(img_filename, '/train/', '/train/mask/mask.');
            img_mask = strrep(img_mask, '.jpg', '.png');
            % get the path of the ground truth
            img_gt = strrep(img_filename, '/train/', '/train/gt/gt.');
            img_gt = strrep(img_gt, '.jpg', '.txt');
            
            % Get the name of every file
            img_name = strsplit(img_filename, '/'); img_name = img_name(end);
            mask_name = strsplit(img_mask, '/'); mask_name = mask_name(end);
            gt_name = strsplit(img_gt, '/'); gt_name = gt_name(end);
            
            % Get the names where to copy the new files
            img_dest_name = strcat(pathSplit, 'train/', img_name);
            mask_dest_name = strcat(pathSplit, 'train/mask/', mask_name);
            gt_dest_name = strcat(pathSplit, 'train/gt/', gt_name);
            
            % copy the original files to the split desitnation
            copyfile(img_filename, img_dest_name{1});
            copyfile(img_mask, mask_dest_name{1});
            copyfile(img_gt, gt_dest_name{1});
        end
    end
    
    % copy files in val split directory
    for i=1:size(valSplit, 1)% for each label
        for j=1:size(valSplit{i,1},1) % for each image
            img_filename = trainSplit{i,1}{j,1}{1,1}; % get image path and name
            % get the path of the mask
            img_mask = strrep(img_filename, '/train/', '/train/mask/mask.');
            img_mask = strrep(img_mask, '.jpg', '.png');
            % get the path of the ground truth
            img_gt = strrep(img_filename, '/train/', '/train/gt/gt.');
            img_gt = strrep(img_gt, '.jpg', '.txt');
            
            % Get the name of every file
            img_name = strsplit(img_filename, '/'); img_name = img_name(end);
            mask_name = strsplit(img_mask, '/'); mask_name = mask_name(end);
            gt_name = strsplit(img_gt, '/'); gt_name = gt_name(end);
            
            % Get the names where to copy the new files
            img_dest_name = strcat(pathSplit, 'val/', img_name);
            mask_dest_name = strcat(pathSplit, 'val/mask/', mask_name);
            gt_dest_name = strcat(pathSplit, 'val/gt/', gt_name);
            
            % copy the original files to the split desitnation
            copyfile(img_filename, img_dest_name{1});
            copyfile(img_mask, mask_dest_name{1});
            copyfile(img_gt, gt_dest_name{1});
        end
    end
end
