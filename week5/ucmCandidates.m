function [ windowCandidates ] = ucmCandidates( im, th )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% Read an input image
I = imread(im);

% tic;
% Test the 'fast' version, which takes around 5 seconds in mean
[candidates_scg, ucm2_scg] = im2mcg(I,'fast');
% toc;


% Bboxes is a matrix that contains the four coordinates of the bounding box
% of each candidate in the form [up,left,down,right]. See folder bboxes for
% more function to work with them

% Show results
% figure;
% subplot(1,2,1)
% imshow(I), title('Image')
% subplot(1,2,2)
% 
% 
% windows = [];
% imshow(imdilate(ucm2_scg,strel(ones(3))),[]), title('Candidate + Box')
% hold on
windowCandidates = [];
for i=1:size(candidates_scg.scores,1)
    if(candidates_scg.scores(i) > th)
        try
            id1 = i;
            x = candidates_scg.bboxes(id1,1);
            y = candidates_scg.bboxes(id1,2);
            w = candidates_scg.bboxes(id1,3)-x;
            h = candidates_scg.bboxes(id1,4)-y;
            windowCandidates = [windowCandidates; struct('x',double(x),'y',double(y),'w',double(w),'h',double(h))];
        catch
            
        end
%         plot([candidates_scg.bboxes(id1,4) candidates_scg.bboxes(id1,4) candidates_scg.bboxes(id1,2) candidates_scg.bboxes(id1,2) candidates_scg.bboxes(id1,4)]*2,...
%         [candidates_scg.bboxes(id1,3) candidates_scg.bboxes(id1,1) candidates_scg.bboxes(id1,1) candidates_scg.bboxes(id1,3) candidates_scg.bboxes(id1,3)]*2,'r-')

    end
end


end

