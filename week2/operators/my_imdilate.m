function [ imdilated ] = my_imdilate( im, se )
% checks if the implemented morphological operators have the same results
% as the matlab ones
% Parameters:
%           im: image to be dilated
%           se: structuring element represented as a logical matrix

    [rows cols] = size(im);
    [se_i se_j] = size(se);
    
    % Compute center of the SE
    cent_i = floor( (size(se, 1) / 2) + 1);
    cent_j = floor( (size(se, 2) / 2) + 1);
    
    % Temporary array
    temp = zeros( 1, sum(se(:)) );
    
    % Create matrix for the dilated image
    imdilated = im(:,:);
    
    % For each pixel outside the boundaries
    for j = cent_j : cols-(se_j-cent_j)
        for i = cent_i : rows-(se_i-cent_i)
            jj = j - cent_j + 1;
            ii = i - cent_i + 1;
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
            imdilated(i,j) = max(temp);
        end
    end
end
