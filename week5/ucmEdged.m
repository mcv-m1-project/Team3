function edged = ucmEdged( im )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

ucm2_scg = im2ucm(im,'fast');

edged = imdilate(ucm2_scg,strel(ones(3))) > 0.6;
edged = imresize(edged, 0.5);



end


