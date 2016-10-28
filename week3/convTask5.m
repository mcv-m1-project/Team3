function [ windowCandidates ] = convTask5( pixelCandidates, step, iWinPx, jWinPx, low_thr, high_thr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %[rows, cols] = size(im);
    % Number of windows in the i and j dimensions
    %iWins = idivide(int32(rows) - (iWinPx - step), int32(step), 'floor');
    %jWins = idivide(int32(cols) - (jWinPx - step), int32(step), 'floor');
    %windowCandidates = struct;
    
    h1 = double(ones(iWinPx, 1));
    h2 = double(ones(jWinPx, 1));
    
    output_args = conv2(h1, h2, double(pixelCandidates), 'same');
    output_args = output_args ./ (iWinPx * jWinPx);
    
    [rows cols] = find(output_args > low_thr & output_args < high_thr);
    
    rows = rows - double(idivide(int32(iWinPx), 2, 'floor'));
    cols = cols - double(idivide(int32(jWinPx), 2, 'floor'));
    
    rows = num2cell(rows);
    cols = num2cell(cols);
    
    [windowCandidates(1:length(rows)).x] = deal(rows{:});
    [windowCandidates(1:length(rows)).y] = deal(cols{:});
    [windowCandidates(1:length(rows)).w] = deal(jWinPx); %deal(rows{:});
    [windowCandidates(1:length(rows)).h] = deal(iWinPx); %deal(rows{:});
    
%     windowCandidates = [];
%     for i = 1 : size(rows, 1)
%         windowCandidates = [windowCandidates; struct('x',cols(i),'y',rows(i),'w',double(jWinPx),'h',double(iWinPx))];
%     end
    
%     
%     windowCandidates()
    
    
    
%    windowCandidates = [];
    
    
%     for i = 0 : iWins-1
%         for j = 0 : jWins-1
%             ii = i*step + 1;
%             jj = j*step + 1;
%             %filRatio = ( sum ( sum(im(ii:ii+iWinPx-1, jj:jj+jWinPx-1)) ) ) / (iWinPx*jWinPx);
%             
%             if filRatio > thr
%                 windowCandidates = [ windowCandidates; struct('x',double(jj),'y',double(ii),'w',double(jWinPx),'h',double(iWinPx)) ];
%             end
%         end
%     end


end

