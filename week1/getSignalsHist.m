function [ output_args ] = getSignalHist( destPath, groups )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    saveSignalColorspaceHist('ycbcr', destPath, groups);
    saveSignalColorspaceHist('rgb', destPath, groups);
    saveSignalColorspaceHist('xyz', destPath, groups);
    saveSignalColorspaceHist('cielab', destPath, groups);
    saveSignalColorspaceHist('hsv', destPath, groups);


end

