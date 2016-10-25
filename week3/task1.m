function task1 (pixelCandidates)
    BB = regionprops(pixelCandidates,'BoundingBox','FilledArea');
    imshow(pixelCandidates)
    hold on;
    for i=1:size(BB,1)
        if BB(i).FilledArea > 50 && BB(i).BoundingBox(3)/BB(i).BoundingBox(4)>0.5  && BB(i).BoundingBox(3)/BB(i).BoundingBox(4)<1.5
            rectangle('Position',[BB(i).BoundingBox(1),BB(i).BoundingBox(2),BB(i).BoundingBox(3),BB(i).BoundingBox(4)],'EdgeColor','y');
        end
    end
end
