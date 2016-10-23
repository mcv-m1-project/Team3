function [ imeroded ] = my_imerode( im, se )
% checks if the implemented morphological operators have the same results
% as the matlab ones
% Parameters:
%           im: image to be dilated
%           se: structuring element represented as a logical matrix

    [rows cols] = size(im);
    [se_i se_j] = size(se);
    
    % Compute center of the SE
    center = floor((size(se)+1)/2);
    
    % Temporary array
    temp = zeros( 1, sum(se(:)) );
    
    % Create matrix for the eroded image
    imeroded = im(:,:);
    
    % For each pixel outside the boundaries
    for j = center(2) : cols-(se_j-center(2))
        for i = center(1) : rows-(se_i-center(1))
            jj = j - center(2) + 1;
            ii = i - center(1) + 1;           
            count = 1;
            % for each element of the SE
            for k = 1 : se_j
                for z = 1 : se_i
                    if se(z, k) == 1
                        temp(1, count) = im(ii+z-1, jj+k-1);
                        count = count + 1;
                    end
                end
            end
            % Get the maximum value of the SE
            imeroded(i,j) = min(temp);
        end
    end
end

