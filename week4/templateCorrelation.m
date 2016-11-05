function [ windowCandidates ] = templateCorrelation( im, templates, thr )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    global RESCALE;

    windowCandidates = [];
    [ni, nj] = size(im);
    [ki, kj] = size(templates{1});
    
    imshow(im);
    waitforbuttonpress;
    imshow(templates{1});
    waitforbuttonpress;
    imshow(templates{2});
    waitforbuttonpress;
    imshow(templates{3});
    waitforbuttonpress;
    imshow(templates{4});
    waitforbuttonpress;
    
    % Compute the correlation for each template
    corr1 = normxcorr2(templates{1}, im);
    corr2 = normxcorr2(templates{2}, im);
    corr3 = normxcorr2(templates{3}, im);
    corr4 = normxcorr2(templates{4}, im);
    
%     imshow(templates{1});
%     waitforbuttonpress;
    imshow(corr1);
    [ypeak, xpeak] = find(corr1==max(corr1(:)));
    hold on
    plot(xpeak,ypeak,'r.','MarkerSize',50);
    waitforbuttonpress;
    
    hold off
    imshow(corr2);
    [ypeak, xpeak] = find(corr2==max(corr2(:)));
    hold on
    plot(xpeak,ypeak,'r.','MarkerSize',50);
    waitforbuttonpress;

    hold off
    imshow(corr3);
    [ypeak, xpeak] = find(corr3==max(corr3(:)));
    hold on
    plot(xpeak,ypeak,'r.','MarkerSize',50);
    waitforbuttonpress;
    
    hold off
    imshow(corr4);
    [ypeak, xpeak] = find(corr4==max(corr4(:)));
    hold on
    plot(xpeak,ypeak,'r.','MarkerSize',50);
    waitforbuttonpress;
    hold off

    
%     figure, surf(corr1), shading flat
%     waitforbuttonpress;
    
    % Get central crop of the correlation
    i_dif = ceil(ki/2);
    j_dif = ceil(kj/2);
    corr1 = corr1(i_dif:ni+i_dif, j_dif:nj+j_dif);
    
    [ColMax, Y]= max(corr1);
    [RowMax, X]= max(ColMax);
    max_x = X;
    max_y = Y(X);

    max_x = max_x - uint16(ki/2); % 100/2 = 50
    max_y = max_y - uint16(kj/2); % 100/2 = 50
    
    %isSign = (corr1 > thr) | (corr2 > thr) | (corr3 > thr) | (corr4 > thr); 
     

    % get the BB original coordinates
%     [rows cols] = find(isSign == 1);
%     rows = rows - double(idivide(int32(ki), 2, 'ceil'));
%     cols = cols - double(idivide(int32(kj), 2, 'ceil'));

    % Convert to original coordinates
    max_y = max_y / RESCALE;
    max_x = max_x / RESCALE;
    ki = ki / RESCALE;
    kj = kj / RESCALE;

    rows = num2cell(max_y);
    cols = num2cell(max_x);

    % store the values on the output struct
    [windowCandidates(1:length(rows)).x] = deal(cols{:});
    [windowCandidates(1:length(rows)).y] = deal(rows{:});
    [windowCandidates(1:length(rows)).w] = deal(ki); 
    [windowCandidates(1:length(rows)).h] = deal(kj);

    windowCandidates = transpose(windowCandidates);

end

