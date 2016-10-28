function [ out_windows ] = filterWindows( in_windows )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
out_windows = [];
for i=1:size(in_windows,1)
    size = in_windows(i).w * in_windows(i).h;
    aspectRatio = in_windows(i).w / in_windows(i).h;
    
    if(size < 56000 && size >  900 && aspectRatio > 0.7 && aspectRatio < 2.3)
       out_windows = [out_windows; in_windows(i)]; 
    end
end

