function [ output_args ] = full_train_mean_shift( input_args )
%FULL_TRAIN_MEAN_SHIFT Summary of this function goes here
%   Detailed explanation goes here
    directory = '../SplitDataset/train/';
    files = ListFiles(directory);

    nFiles = size(files, 1
    Xall = [];
    tic
    for i=1:nFiles
        i
        I = imread(strcat(directory,'/',files(i).name));
        I = imresize(I, 0.5);

        I = NormRGB(double(I));
        %I = rgb2hsv(I);
        
        X = reshape(I,size(I,1)*size(I,2),3); % Color Features
        %X = reshape(I(:,:,1:2),size(I,1)*size(I,2),2); % Color Features
        X = unique(X, 'rows');
        
        Xall = [Xall;X];
        %Xall = unique(Xall, 'rows');Xall
        %size(Xall)
    end

    size(Xall)
    Xall = unique(Xall, 'rows');
    toc
    
    %% MEAN-SHIFT
    bandwidth = 0.05; %norm_rgb = 0.05;
    % MeanShiftCluster
    tic
    [clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(Xall',bandwidth);
    Kms = length(clustMembsCell)
    toc
    
    %% Image
    im = imread('../SplitDataset/train/00.005938.jpg');
    %im = imread('../SplitDataset/train/00.005004.jpg');
    imorig = imresize(im, 0.5);
    im = NormRGB(double(imorig));
%     im = rgb2hsv(im);

    tic
    dists = zeros(size(im,1), size(im,2), Kms);
    for k=1:Kms
        dist_r = im(:,:,1)-clustCent(1,k);
        dist_g = im(:,:,2)-clustCent(2,k);
        dist_b = im(:,:,3)-clustCent(3,k);
        dists(:,:,k) = dist_r.^2 + dist_g.^2 + dist_b.^2;
    end
    [~, mins] = min(dists, [], 3);
    
    for i=1:size(im,1)
        for j=1:size(im,2)
            im(i,j,:) = clustCent(:,mins(i,j));
        end
    end
    toc
    
end

