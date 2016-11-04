function [ windowCandidates ] = MaskChamferWCandidates( pixel_candidates, templates)
%MaskChamferWCandidates Summary of this function goes here
%   Detailed explanation goes here

    edg = edge(pixel_candidates, 'Canny', 0.1, 3);
    %[imi, imj] = size(edg);
    dist = bwdist(edg);

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

        windowCandidates = [windowCandidates; struct('x', double(min_x), 'y', double(min_y), 'w', ti, 'h', tj, 'min', Gmin/(ti*tj))];
    end
    
    % Store only the bbox with the lowest min -> the one which matches the
    % best
    pick = min_nms(windowCandidates, 0.2);
    windowCandidates = windowCandidates(pick);
end

