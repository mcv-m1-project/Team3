function [ pixelCandidates ] = copyPixelsFromWindows(windows,imagen)
    pixelCandidates(1:size(imagen,1),1:size(imagen,2))=0;
    for i=1:size(windows,1)
        x1=floor(windows(i).x);
        y1=floor(windows(i).y);
        x2=floor(windows(i).x+windows(i).w);
        y2=floor(windows(i).y+windows(i).h);
        if x1<1
            x1=1;
        end
        if y1<1
            y1=1;
        end
        if y2>size(imagen,1)
            y2=size(imagen,1);
        end
        if x2>size(imagen,2)
            x2=size(imagen,2);
        end
        pixelCandidates(y1:y2,x1:x2)=imagen(y1:y2,x1:x2);
    end
end

