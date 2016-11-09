function [ windowCandidates ] = CCchamferTemplateMatching(BW,templates,threshold)
    L = bwlabel(BW);
    Msum(1:max(max(L)))=0;
    signal(1:max(max(L)))=0;
    BB=[];
    windowCandidates=[];
    for z=1:size(templates,2)
        template= imageCrop(templates{1,z});
        template=im2bw(template,graythresh(template));
        for i=1:max(max(L))
            bw2(1:size(BW,1),1:size(BW,2))=0;
            bw2(L==i)=1;
            [bwCrop,bwCropMargin,x,y,w,h]=imageCrop(bw2);
            % imshow(bw2);
            % rectangle('Position',[x,y,w,h],'EdgeColor','r');
            if z==1
                BB=[BB;x y w h];
            end
            resizeIm=imresize(bwCrop,[size(template,1) size(template,2)]);
            level = graythresh(resizeIm);
            I = im2bw(resizeIm,level);
            distanceTransform=bwdist(I)==0;
            M=distanceTransform.*template;
            if   Msum(i)< sum(sum(M))
                Msum(i)=sum(sum(M));
                signal(i)=z;
            end
            %subplot(1,3,1)
            %imshow(distanceTransform);
            %subplot(1,3,2)
            %imshow(template);
            % subplot(1,3,3)
            % imshow(M);
        end
        %[minM,indxMin]=max(Msum);
        %bw2(1:size(BW,1),1:size(BW,2))=0;
        %bw2(L==indxMin)=1;
        %imshow(bw2);
    end
    for j=1:max(max(L))
        if Msum(j)>threshold
            windowCandidates = [ windowCandidates; struct('x',double(BB(j,1)),'y',double(BB(j,2)),'w',double(BB(j,3)),'h',double(BB(j,4))) ];
        end
    end
%     imshow(BW)
%     for a=1:size(windowCandidates,1)
%        rectangle('Position',[windowCandidates(a).x windowCandidates(a).y windowCandidates(a).w windowCandidates(a).h],'EdgeColor','r');
%     end
end

