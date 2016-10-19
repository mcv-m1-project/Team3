function [ imeroded ] = my_imdilate( im, se )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    [rows cols] = size(im);
    [se_i se_j] = size(se);
    %center = floor((size(se)+1)/2);
    cent_i = floor( (size(se, 1) / 2) + 1);
    cent_j = floor( (size(se, 2) / 2) + 1);
    %cent_i = center(1);
    %cent_j = center(2);
    temp = zeros( 1, sum(se(:)) );
    
    imeroded = im(:,:);
    
    for j = cent_j : cols-(se_j-cent_j)
        for i = cent_i : rows-(se_i-cent_i)
            jj = j - cent_j + 1;
            ii = i - cent_i + 1;
            count = 1;
            for k = 1 : se_j
                for z = 1 : se_i
                    if se(z, k) == 1
                        temp(1, count) = im(ii+z-1, jj+k-1);
                        count = count + 1;
                    end
                end
            end
            imeroded(i,j) = max(temp);
        end
    end
end
