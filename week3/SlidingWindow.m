function [ windowCandidates ] = SlidingWindow( im, step, iWinPx, jWinPx, thr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    [rows, cols] = size(im);
    % Number of windows in the i and j dimensions
    iWins = idivide(int32(rows) - (iWinPx - step), int32(step), 'floor');
    jWins = idivide(int32(cols) - (jWinPx - step), int32(step), 'floor');
    
    windowCandidates = [];
    
    %imshow(im);
    %hold on;
    
    for i = 0 : iWins-1
        for j = 0 : jWins-1
            ii = i*step + 1;
            jj = j*step + 1;
            filRatio = ( sum ( sum(im(ii:ii+iWinPx-1, jj:jj+jWinPx-1)) ) ) / (iWinPx*jWinPx);
            %rectangle('Position',[jj ,ii ,jWinPx,iWinPx],'EdgeColor','y');
            %waitforbuttonpress;
            if filRatio > thr
                windowCandidates = [ windowCandidates; struct('x',double(jj),'y',double(ii),'w',double(jWinPx),'h',double(iWinPx)) ];
            end
        end
    end
end

