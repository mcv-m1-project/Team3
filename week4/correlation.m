function [ corr ] = correlation( bb, template )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    corr = template .* bb;
    corr = sum(sum(corr));

end

