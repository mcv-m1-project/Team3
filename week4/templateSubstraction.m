function [ windowCandidates ] = templateSubstraction( im, templates, thr )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    step = 1;
    [rows, cols] = size(im);
    [ti tj] = size(templates{1});
    % Number of windows in the i and j dimensions
    iWins = idivide(int32(rows) - (ti - step), int32(step), 'floor');
    jWins = idivide(int32(cols) - (tj - step), int32(step), 'floor');
    
    windowCandidates = [];
    
    % for each window
    for i = 0 : iWins-1
        for j = 0 : jWins-1
            ii = i*step + 1;
            jj = j*step + 1;
            % compute the difference for each signal
            diff1 = imabsdiff(templates{1}, im(ii:ii+ti-1, jj:jj+tj-1));
            diff2 = imabsdiff(templates{2}, im(ii:ii+ti-1, jj:jj+tj-1));
            diff3 = imabsdiff(templates{3}, im(ii:ii+ti-1, jj:jj+tj-1));
            diff4 = imabsdiff(templates{4}, im(ii:ii+ti-1, jj:jj+tj-1));
            if (filRatio > low_thr) && (filRatio < high_thr)
                windowCandidates = [ windowCandidates; struct('x',double(jj),'y',double(ii),'w',double(jWinPx),'h',double(iWinPx)) ];
            end
        end
    end


end

