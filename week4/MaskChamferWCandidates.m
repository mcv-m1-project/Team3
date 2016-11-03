function [ windowCandidates ] = MaskChamferWCandidates( pixel_candidates )
%MaskChamferWCandidates Summary of this function goes here
%   Detailed explanation goes here

    edg = edge(pixel_candidates, 'Canny', 0.1, 3);
    %[imi, imj] = size(edg);
    dist = bwdist(edg);

    load('templates.mat');

    windowCandidates = [];

    % For each template
    for t=1:size(templates, 2)
        template = im2double(templates{t} > 0);
        template = imdilate(template, ones(9,9)); % Dilate the template a little bit
        [ti, tj] = size(template);

        template = flipud(fliplr(template));
        C = conv2(dist,template,'same');

        [ColumnMin, Y]= min(C);
        [Gmin, X]= min(ColumnMin);
        min_x = X;
        min_y = Y(X);

        min_x = min_x - uint16(ti/2); %
        min_y = min_y - uint16(tj/2); %

        windowCandidates = [windowCandidates; struct('x', min_x, 'y', min_y, 'w', ti, 'h', tj)];
    end    
end

