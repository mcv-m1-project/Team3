function [ mat ] = struct2nmsmat( windowCandidates, confidences )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    
    mat = struct2cell(windowCandidates);
    mat = cell2mat(mat);
    mat = transpose(mat);
    mat = [mat confidences];
    mat(:,3:4) = mat(:,1:2) + mat(:,3:4);
    
end

