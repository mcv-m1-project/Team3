function [ pixelCandidates ] = copyPixelsFromWindows(windows,imagen)
    pixelCandidates(1:size(imagen,1),1:size(imagen,2))=0;
    for i=1:size(windows,1)
        x1=windows(i).x;
        y1=windows(i).y;
        x2=windows(i).x+windows(i).w;
        y2=windows(i).y+windows(i).h;
        try
            pixelCandidates(y1:y2,x1:x2)=imagen(y1:y2,x1:x2);
        catch % If the bbox is outside the image
            continue
        end
    end
end

