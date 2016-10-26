%%
%1st approach: Connected Component Labeling
function [windowCandidates] = task1 (pixelCandidates)
    BB = regionprops(pixelCandidates,'BoundingBox','FilledArea');
    windowCandidates=[];
    imshow(pixelCandidates)
    hold on;
    for i=1:size(BB,1)
        %conditions extracted to analysis of task1 of the week1
        if (BB(i).BoundingBox(3)*BB(i).BoundingBox(4))>850 && (BB(i).BoundingBox(3)*BB(i).BoundingBox(4))<55850 &&((BB(i).FilledArea*100)/(BB(i).BoundingBox(3)*BB(i).BoundingBox(4))) > 0.4 && BB(i).BoundingBox(3)/BB(i).BoundingBox(4)>0.6  && BB(i).BoundingBox(3)/BB(i).BoundingBox(4)<2.4
            rectangle('Position',[BB(i).BoundingBox(1),BB(i).BoundingBox(2),BB(i).BoundingBox(3),BB(i).BoundingBox(4)],'EdgeColor','y');
            windowCandidates = [ windowCandidates;struct('x',double(BB(i).BoundingBox(1)),'y',double(BB(i).BoundingBox(2)),'w',double(BB(i).BoundingBox(3)),'h',double(BB(i).BoundingBox(4))) ];
        end
    end
end
