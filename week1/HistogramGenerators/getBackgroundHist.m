function [ output_args ] = getBackgroundHist( imgPaths, maskPaths, destPath)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[rgb_yHist, rgb_xHist] = saveBackgroundColorspaceHist(imgPaths, maskPaths, 'RGB');
[hsv_yHist, hsv_xHist] = saveBackgroundColorspaceHist(imgPaths, maskPaths, 'hsv');
[xyz_yHist, xyz_xHist] = saveBackgroundColorspaceHist(imgPaths, maskPaths, 'xyz');
[ycbcr_yHist, ycbcr_xHist] = saveBackgroundColorspaceHist(imgPaths, maskPaths, 'ycbcr');
[lab_yHist, lab_xHist] = saveBackgroundColorspaceHist(imgPaths, maskPaths, 'cielab');

end

