function [ output_args ] = chamferTemplateMatching(BW,templates,aproach)
    switch aproach
        case 'CC'
            L = bwlabel(BW);
            Msum(1:max(max(L)))=0;
            signal(1:max(max(L)))=0;
            for z=1:size(templates,2)   
                template= imageCrop(templates{1,z});             
                for i=1:max(max(L))
                    bw2(1:size(BW,1),1:size(BW,2))=0;
                    bw2(L==i)=1;
                    [bwCrop,bwCropMargin]=imageCrop(bw2);
                    resizeIm=imresize(bwCrop,[size(template,1) size(template,2)]);
                    level = graythresh(resizeIm);
                    I = im2bw(resizeIm,level);
                    distanceTransform=bwdist(I)==0;
                    M=distanceTransform.*template;
                    if   Msum(i)< sum(sum(M))
                        Msum(i)=sum(sum(M));
                        signal(i)=z;
                    end
    %                 subplot(1,3,1)
    %                 imshow(distanceTransform);
    %                 subplot(1,3,2)
    %                  imshow(template);
    %                 subplot(1,3,3)
    %                 imshow(M);
                end
                [minM,indxMin]=max(Msum);
                bw2(1:size(BW,1),1:size(BW,2))=0;
                bw2(L==indxMin)=1;
                imshow(bw2);
         end     
    end
    
     
end

