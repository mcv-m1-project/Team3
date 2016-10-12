function [ output_args ] = getSignalHist( destPath, groups )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    getSignalsHist_nosequenombreponer_lohaceporgrupocolor( 'ycbcr', destPath, groups);
    getSignalsHist_nosequenombreponer_lohaceporgrupocolor( 'rgb', destPath, groups);
    getSignalsHist_nosequenombreponer_lohaceporgrupocolor( 'xyz', destPath, groups);
    getSignalsHist_nosequenombreponer_lohaceporgrupocolor( 'cielab', destPath, groups);
    getSignalsHist_nosequenombreponer_lohaceporgrupocolor( 'hsv', destPath, groups);


end

