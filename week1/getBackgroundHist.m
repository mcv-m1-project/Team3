function [ output_args ] = getBackgroundHist(destPath, groups)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

saveBackgroundColorspaceHist('RGB', destPath, groups);
saveBackgroundColorspaceHist('hsv', destPath, groups);
saveBackgroundColorspaceHist('xyz', destPath, groups);
saveBackgroundColorspaceHist('ycbcr', destPath, groups);
saveBackgroundColorspaceHist('cielab', destPath, groups);

end

