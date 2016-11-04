function [ windowCandidates ] = MaskChamferWCandidates( templates, dist)
%MaskChamferWCandidates Summary of this function goes here
%   Detailed explanation goes here

    windowCandidates = [];

    % For each template
    for t=1:size(templates, 2)
        template = double(templates{t} > 0);
        %template = imdilate(template, ones(9,9)); % Dilate the template a little bit
        [ti, tj] = size(template);

        template = flipud(fliplr(template));
        C = conv2(dist,template,'same');

        [min_y, min_x] = find(C==min(C(:)));
        Gmin = C(min_y, min_x);

        min_x = min_x - uint16(ti/2); %
        min_y = min_y - uint16(tj/2); %

        windowCandidates = [windowCandidates; struct('x', double(min_x), 'y', double(min_y), 'w', ti, 'h', tj, 'min', Gmin/(ti*tj))];
    end
    
    % Store only the bbox with the lowest min -> the one which matches the
    % best
    pick = min_nms(windowCandidates, 0.2);
    windowCandidates = windowCandidates(pick);
end

