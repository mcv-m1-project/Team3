function [ output_args ] = chamferTemplateMatching(BW,template,aproach)
    switch aproach
        case 'CC'
            L = bwlabel(BW);
            Msum(1:max(max(L)))=Inf;
            for i=1:max(max(L))
                bw2(1:size(BW,1),1:size(BW,2))=0;
                bw2(L==i)=1;
                [bwCrop,bwCropMargin]=imageCrop(bw2);
                if (size(bwCrop,1)*size(bwCrop,2))>900
                    resizeIm=imresize(bwCropMargin,[size(template,1) size(template,1)]);
                    level = graythresh(resizeIm);
                    I = im2bw(resizeIm,level);
                    distanceTransform=bwdist(I);
                    M=distanceTransform*template;
                    Msum(i)=sum(sum(M));
                end
            end
            [minM,indxMin]=min(Msum);
            bw2(1:size(BW,1),1:size(BW,2))=0;
            bw2(L==indxMin)=1;
            %imshow(bw2);
    end
    
     
end

