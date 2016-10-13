function [ output_args ] = task2(pathGt, pathImg, pathMask)
%Task 2 - week 1
%arguments:  pathGT: directory of the gt
%            pathImg: directory of the images
%            pathMask: directory of the image masks
    
    % Read the dataset
    dataset = dataset2mat(pathGt, pathImg, pathMask);
    
    %groups = groupClasses(dataset);
    
    % Split data into train and validation
    dataSplit = split(dataset, 0.7);
    
    trainSplit = dataSplit{1,1};
    valSplit = dataSplit{2,1};
    save('trainSplit.mat', 'trainSplit');
    save('valSplit.mat', 'valSplit');
    
    
    CreateSplitFolder(trainSplit, valSplit);    
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

function CreateSplitFolder(trainSplit, valSplit)
    % CreateSplitFolder
    % Function to create the folders containing the train and val splits. 
    %
    % [] = createSplitFolder(trainSplit, valSplit)
    %
    %    Parameter name     Value
    %    --------------     -----
    %    'trainSplit'       Cell array containing train images
    %    'valSplit'         Cell array containing val images
    %

    % create split folders
    mkdir('../', 'SplitDataset/');
    mkdir('../SplitDataset/', 'train/mask');
    mkdir('../SplitDataset/', 'val/mask');
    mkdir('../SplitDataset/', 'train/gt');
    mkdir('../SplitDataset/', 'val/gt');
    
    disp(sprintf('Creating train and val directories.'));
    
    % copy files in train split directory
    for i=1:size(trainSplit, 1)% for each label
        for j=1:size(trainSplit{i,1},1) % for each image
            img_filename = trainSplit{i,1}{j,1}{1,1};
            img_mask = strrep(img_filename, '/train/', '/train/mask/mask.');
            img_mask = strrep(img_mask, '.jpg', '.png');
            img_gt = strrep(img_filename, '/train/', '/train/gt/gt.');
            img_gt = strrep(img_gt, '.jpg', '.txt');
            
            copyfile(img_filename, strrep(img_filename, 'DataSetDelivered', 'SplitDataset'));
            copyfile(img_mask, strrep(img_mask, 'DataSetDelivered', 'SplitDataset'));
            copyfile(img_gt, strrep(img_gt, 'DataSetDelivered', 'SplitDataset'));
        end
    end
    
    % copy files in val split directory
    for i=1:size(valSplit, 1)% for each label
        for j=1:size(valSplit{i,1},1) % for each image
            img_filename = valSplit{i,1}{j,1}{1,1};
            img_mask = strrep(img_filename, '/train/', '/train/mask/mask.');
            img_mask = strrep(img_mask, '.jpg', '.png');
            img_gt = strrep(img_filename, '/train/', '/train/gt/gt.');
            img_gt = strrep(img_gt, '.jpg', '.txt');
            
            copyfile(img_filename, strrep(img_filename, 'DataSetDelivered/train/', 'SplitDataset/val/'));
            copyfile(img_mask, strrep(img_mask, 'DataSetDelivered/train/', 'SplitDataset/val/'));
            copyfile(img_gt, strrep(img_gt, 'DataSetDelivered/train/', 'SplitDataset/val/'));
        end
    end
end
