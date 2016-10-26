function [ windowCandidates ] = IntegralSlidingWindow( im, step, iWinPx, jWinPx, thr )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    [rows, cols] = size(im);
    % Number of windows in the i and j dimensions
    iWins = idivide(int32(rows) - (iWinPx - step), int32(step), 'floor');
    jWins = idivide(int32(cols) - (jWinPx - step), int32(step), 'floor');
    
    windowCandidates = [];
    
    for i = 0 : iWins-1
        for j = 0 : jWins-1
            ii = i*step + 1;
            jj = j*step + 1;
            filRatio = im(ii+iWinPx-1,jj+jWinPx-1) - im(ii,jj+jWinPx-1) - im(ii+iWinPx-1,jj) + im(ii,jj)
            if filRatio > thr
                windowCandidates(end+1) = struct('x',double(jj),'y',double(ii),'w',double(jWinPx),'h',double(iWinPx));
            end
        end
    end
end

