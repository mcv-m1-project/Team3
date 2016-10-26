function [ windowCandidates ] = SlidingWindow( im, step, iWinPx, jWinPx, thr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    [rows, cols] = size(im);
    % Number of windows in the i and j dimensions
    iWins = idivide(int32(rows) - (iWinPx - step), int32(step), 'floor');
    jWins = idivide(int32(cols) - (jWinPx - step), int32(step), 'floor');
    
    windowCandidates = [];
    
    for i = 1 : iWins
        for j = 1 : jWins
            ii = i*step + 1;
            jj = j*step + 1;
            filRatio = sum ( im(ii:ii+iWinPx, jj:jj+jWinPx) ) / (iWinPx*jWinPx);
            if filRatio > thr
                windowCandidates(end+1) = struct('x',double(jj),'y',double(ii),'w',double(jWinPx),'h',double(iWinPx));
            end
        end
    end
end

