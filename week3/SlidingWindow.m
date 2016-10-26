function [ output_args ] = SlidingWindow( im, step, iWinPx, jWinPx )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    [rows, cols] = size(im);
    % Number of windows in the i and j dimensions
    iWins = idivide(int32(rows), int32(step), 'floor') - (iWinPx - 1);
    jWins = idivide(int32(cols), int32(step), 'floor') - (jWinPx - 1);
    
    for i = 0 : iWins
        for j = 0 : jWins
            ii = i*step;
            jj = j * step;
            
            im(ii:ii+iWinPx, jj:jj+jWinPx) ;
        end
    end
    
    

end

