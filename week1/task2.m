function [ output_args ] = task2(pathGt, pathImg, pathMask)
%Task 2 - week 1
%arguments:  pathGT: directory of the gt
%            pathImg: directory of the images
%            pathMask: directory of the image masks
    
    % Read the dataset
    dataset = dataset2mat(pathGt, pathImg, pathMask);
    
    groups = groupClasses(dataset);
    save('groups.mat', 'groups');
    % Split data into train and validation
    dataSplit = split(dataset, 0.7);
    
    trainSplit = dataSplit{1,1};
    valSplit = dataSplit{2,1};
    
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
