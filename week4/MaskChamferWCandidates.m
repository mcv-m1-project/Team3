function [ windowCandidates ] = MaskChamferWCandidates( templates, dist)
%MaskChamferWCandidates Summary of this function goes here
%   Detailed explanation goes here

    windowCandidates = [];

    % For each template
    for t=1:size(templates, 2)
        template = double(templates{t});
        template = double(edge(template, 'Canny'));
        [ti, tj] = size(template);

        template = flipud(fliplr(template));
        C = conv2(dist,template,'same');

        [coords_y, coords_x] = find((C./(ti*tj))<0.5); % Threshold found in findChamferTh.m
        
        for i=1:size(coords_y,1)
            Gmin = C(coords_y(i), coords_x(i));
%             Gmin/(ti*tj)
            min_x = coords_x(i) - uint16(ti/2); %
            min_y = coords_y(i) - uint16(tj/2); %

            windowCandidates = [windowCandidates; struct('x', double(min_x), 'y', double(min_y), 'w', ti, 'h', tj, 'min', Gmin/(ti*tj))];
        end
    end
    
    % Store only the bbox with the lowest min -> the one which matches the
    % best
    pick = min_nms(windowCandidates, 0.2);
    windowCandidates = windowCandidates(pick);
end

