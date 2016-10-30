function [ windowCandidates ] = convTask5( pixelCandidates, step, iWinPx, jWinPx, low_thr, high_thr )
% The function computes the sliding window using a convolution
% parameters:   pixelCandidates: target image (grayscale or logical)
%               step: stride of the sliding window
%               iWinPx: width of the window
%               jWinPx: height of the window
%               low_thr: lower boundary for detection
%               high_thr: upper boundary for detection
% 
% return:       windowCandidates: array of structures containing the
%               detected windows
    
    % Convolution matrix
    h1 = double(ones(iWinPx, 1));
    h2 = double(ones(jWinPx, 1));
    
    % compute the convolution by rows and columns in two steps
    conv = conv2(h1, h2, double(pixelCandidates), 'valid');
    conv = conv(1:step:end, 1:step:end);
    % compute filling ratio
    conv = conv ./ (iWinPx * jWinPx);
    
    % get the BB within the thresholds
    [rows cols] = find(conv > low_thr & conv < high_thr);
    
    % get the BB original coordinates
    rows = (step*rows) - double(idivide(int32(iWinPx), 2, 'ceil'));
    cols = (step*cols) - double(idivide(int32(jWinPx), 2, 'ceil'));
    
    rows = num2cell(rows);
    cols = num2cell(cols);
    
    % store the values on the output struct
    [windowCandidates(1:length(rows)).x] = deal(cols{:});
    [windowCandidates(1:length(rows)).y] = deal(rows{:});
    [windowCandidates(1:length(rows)).w] = deal(jWinPx); 
    [windowCandidates(1:length(rows)).h] = deal(iWinPx);
    
    windowCandidates = transpose(windowCandidates);
    
end

