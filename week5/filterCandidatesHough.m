function [ windowCandidates ] = filterCandidatesHough( windowCandidates, pixelCandidates )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    for i = 0: size(windowCandidates, 1)
        ii = windowCandidates(i).y;
        jj = windowCandidates(i).x;
        iiSize = windowCandidates(i).h;
        jjSize = windowCandidates(i).w;
        crop = pixelCandidates(ii:ii+iiSize, jj:jj+jjSize);
        BW = edge(crop, 'Canny');
        
        [H theta rho] = hough(BW);
        
        peaks = houghpeaks(H, 3);
        
        lines = houghlines(BW, theta, rho, peaks);
        
        if size(lines, 1) ~= 0
            disp('sadasdd')
        end
    end
    

end

