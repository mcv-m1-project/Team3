%%
%1st approach: Connected Component Labeling
function [windowCandidates] = ConnectedComponents (pixelCandidates)
    BB = regionprops(pixelCandidates,'BoundingBox','FilledArea');
    
    windowCandidates=[];
%     imshow(pixelCandidates)
%     hold on;
    for i=1:size(BB,1)
        %conditions extracted to analysis of task1 of the week1
        sizeBB=(BB(i).BoundingBox(3)*BB(i).BoundingBox(4));
        width=BB(i).BoundingBox(3);
        height=BB(i).BoundingBox(4);
        aspectRatio=BB(i).BoundingBox(3)/BB(i).BoundingBox(4);
        fillingRatio=((BB(i).FilledArea)/(BB(i).BoundingBox(3)*BB(i).BoundingBox(4)));
        % if width>=20 && width<=350 && height>=20 && height<=345 
        if sizeBB>=1900 && sizeBB<=14900
        % if aspectRatio>=0.8 && aspectRatio<=1.5
        %if (fillingRatio>=0.2 && fillingRatio<=0.508) || (fillingRatio>=0.7 && fillingRatio<=0.8) || (fillingRatio>=0.9 && fillingRatio<=1)
         %  rectangle('Position',[BB(i).BoundingBox(1),BB(i).BoundingBox(2),BB(i).BoundingBox(3),BB(i).BoundingBox(4)],'EdgeColor','y');
            windowCandidates = [ windowCandidates;struct('x',double(BB(i).BoundingBox(1)),'y',double(BB(i).BoundingBox(2)),'w',double(BB(i).BoundingBox(3)),'h',double(BB(i).BoundingBox(4))) ];
        end
    end
end
