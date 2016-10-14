function [ bw ] = applyThreshold( th, img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    bw = zeros(size(img,1), size(img,2));
    for i=1:size(th,1)
        for j=1:size(th(1),1)
            bwAux = img(:,:,j) >= th(i, j, 1) & img(:,:,j) <= th(i, j, 2);
            bw = bw | bwAux;
        end
    end
end

