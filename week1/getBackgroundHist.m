function [ output_args ] = getBackgroundHist( imgPaths, maskPaths, destPath)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[rgb_yHist, rgb_xHist] = getAcumHist(imgPaths, maskPaths, 'RGB');
[hsv_yHist, hsv_xHist] = getAcumHist(imgPaths, maskPaths, 'hsv');
[xyz_yHist, xyz_xHist] = getAcumHist(imgPaths, maskPaths, 'xyz');
[ycbcr_yHist, ycbcr_xHist] = getAcumHist(imgPaths, maskPaths, 'ycbcr');
[lab_yHist, lab_xHist] = getAcumHist(imgPaths, maskPaths, 'cielab');

save(strcat(destPath,'/rgb_yHist.mat'), 'rgb_yHist');
save(strcat(destPath,'/rgb_xHist.mat'), 'rgb_xHist');
save(strcat(destPath,'/hsv_xHist.mat'), 'hsv_xHist');
save(strcat(destPath,'/hsv_yHist.mat'), 'hsv_yHist');
save(strcat(destPath,'/xyz_yHist.mat'), 'xyz_yHist');
save(strcat(destPath,'/xyz_xHist.mat'), 'xyz_xHist');
save(strcat(destPath,'/ycbcr_xHist.mat'), 'ycbcr_xHist');
save(strcat(destPath,'/ycbcr_yHist.mat'), 'ycbcr_yHist');
save(strcat(destPath,'/lab_yHist.mat'), 'lab_yHist');
save(strcat(destPath,'/lab_xHist.mat'), 'lab_xHist');


end

