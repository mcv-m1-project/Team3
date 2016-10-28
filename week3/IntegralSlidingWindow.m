function [ windowCandidates ] = IntegralSlidingWindow( iImg, step, iWinPx, jWinPx, low_thr, high_thr )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    [rows, cols] = size(iImg);
    % Number of windows in the i and j dimensions
    iWins = idivide(int32(rows) - (iWinPx - step), int32(step), 'floor');
    jWins = idivide(int32(cols) - (jWinPx - step), int32(step), 'floor');
    
    windowCandidates = [];
    
    for i = 0 : iWins-1
        for j = 0 : jWins-1
            ii = i*step + 1;
            jj = j*step + 1;
            filRatio = (iImg(ii+iWinPx-1,jj+jWinPx-1) - iImg(ii,jj+jWinPx-1) - iImg(ii+iWinPx-1,jj) + iImg(ii,jj)) / (iWinPx*jWinPx);
            if (filRatio > low_thr) && (filRatio < high_thr)
                windowCandidates = [ windowCandidates; struct('x',double(jj),'y',double(ii),'w',double(jWinPx),'h',double(iWinPx)) ];
            end
        end
    end
end

