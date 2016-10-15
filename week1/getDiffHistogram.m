function [output_args] = getDiffHistogram(pathSignals, pathBackground) 
    backgroundHists = [];
    f = dir(pathBackground);
    for i=1:size(f,1)
        if f(i).isdir==0,
            if strcmp(f(i).name(end-8:end),'yHist.mat')==1,
                backgroundHists = [backgroundHists ; f(i)];
            end
        end
    end
    
    
    f = dir(pathBackground);
    for j=1:size(f,1)
        if f(j).isdir==1,
            fsub = (dir(f(j)));
            for i=1:size(f,1)
                if f(i).isdir==0,
                    if strcmp(f(i).name(end-8:end),'yHist.mat')==1,
                        bg = 
                        backgroundHists = [backgroundHists ; f(i)];
                        
                    end
                end
            end
    end
end


function [ diff ] = calcDiffHistogram( hist1, hist2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    diff = sum(hist1 .* hist2);
end

