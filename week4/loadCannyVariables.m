function [ output_args ] = loadCannyVariables( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [y, Fs] = audioread('canny.wav');
    sound(y, Fs);

end

