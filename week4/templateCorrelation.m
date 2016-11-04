function [ windowCandidates ] = templateCorrelation( im, templates, thr )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    windowCandidates = [];
    [ni, nj] = size(im);
    [ki, kj] = size(templates{1});
    
    % Compute the correlation for each template
    corr1 = normxcorr2(templates{1}, im);
    corr2 = normxcorr2(templates{2}, im);
    corr3 = normxcorr2(templates{3}, im);
    corr4 = normxcorr2(templates{4}, im);
    
    %imshow(corr1);
    %figure, surf(corr1), shading flat
    %waitforbuttonpress;
    
    isSign = (corr1 > thr) | (corr2 > thr) | (corr3 > thr) | (corr4 > thr); 
    
    if any(isSign(:))
        % Get central crop of the correlation
        i_dif = ceil(ki/2);
        j_dif = ceil(kj/2);
        isSign = isSign(i_dif:ni+i_dif, j_dif:nj+j_dif);

        % get the BB original coordinates
        [rows cols] = find(isSign == 1);
        rows = rows - double(idivide(int32(ki), 2, 'ceil'));
        cols = cols - double(idivide(int32(kj), 2, 'ceil'));

        rows = num2cell(rows);
        cols = num2cell(cols);

        % store the values on the output struct
        [windowCandidates(1:length(rows)).x] = deal(cols{:});
        [windowCandidates(1:length(rows)).y] = deal(rows{:});
        [windowCandidates(1:length(rows)).w] = deal(ki); 
        [windowCandidates(1:length(rows)).h] = deal(kj);

        windowCandidates = transpose(windowCandidates);

%         figure
%         imshow(corr)
% 
%         for a=1:size(windowCandidates, 1)
%             rectangle('Position',[windowCandidates(a).x ,windowCandidates(a).y ,windowCandidates(a).w,windowCandidates(a).h],'EdgeColor','c');
%         end
    end
end

