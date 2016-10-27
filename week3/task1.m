%%
%1st approach: Connected Component Labeling
function [windowCandidates] = task1 (pixelCandidates, meanSize, sdSize, meanFillingRatio, sdFillingRatio, meanAspectRatio, sdAspectRatio)
    BB = regionprops(pixelCandidates,'BoundingBox','FilledArea');
    windowCandidates=[];
%     imshow(pixelCandidates)
%    hold on;
    for i=1:size(BB,1)
        %conditions extracted to analysis of task1 of the week1
        sizeBB=(BB(i).BoundingBox(3)*BB(i).BoundingBox(4));
        aspectRatio=BB(i).BoundingBox(3)/BB(i).BoundingBox(4);
        fillingRatio=((BB(i).FilledArea)/(BB(i).BoundingBox(3)*BB(i).BoundingBox(4)));
        % if sizeBB>=(meanSize-(sdSize/2)) && sizeBB<=(meanSize+(sdSize/2))
        % if aspectRatio>=(meanAspectRatio-(sdAspectRatio/2)) && aspectRatio<=(meanAspectRatio+(sdAspectRatio/2))
         if fillingRatio>=(meanFillingRatio-(sdFillingRatio/2)) && fillingRatio<=(meanFillingRatio+(sdFillingRatio/2))
%             rectangle('Position',[BB(i).BoundingBox(1),BB(i).BoundingBox(2),BB(i).BoundingBox(3),BB(i).BoundingBox(4)],'EdgeColor','y');
            windowCandidates = [ windowCandidates;struct('x',double(BB(i).BoundingBox(1)),'y',double(BB(i).BoundingBox(2)),'w',double(BB(i).BoundingBox(3)),'h',double(BB(i).BoundingBox(4))) ];
        end
    end
end
