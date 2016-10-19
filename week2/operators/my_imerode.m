function [ imeroded ] = my_imerode( im, se )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    [rows cols] = size(im);
    [se_i se_j] = size(se);
    center = floor((size(se)+1)/2);
    temp = zeros( 1, sum(se(:)) );
    
    imeroded = im(:,:);
    
    for j = center(2) : cols-(se_j-center(2))
        for i = center(1) : rows-(se_i-center(1))
            jj = j - center(2) + 1;
            ii = i - center(1) + 1;           
            count = 1;
            for k = 1 : se_j
                for z = 1 : se_i
                    if se(z, k) == 1
                        temp(1, count) = im(ii+z-1, jj+k-1);
                        count = count + 1;
                    end
                end
            end
            imeroded(i,j) = min(temp);
        end
    end
end

