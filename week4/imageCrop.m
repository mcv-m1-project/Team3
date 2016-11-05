function [recorte, imMargenes,x,y,w,h]= imageCrop(BW)


% BW = BW(:,:,1);

[M,N]=size(BW);

horPro=sum(BW,2); 

% 
% figure;
% subplot(2,1,1);imshow(BW);
% title('Image');
% 
% subplot(2,1,2);plot(horPro, 'r-');
% title('Horizontal Projection');

primero=0;
segundo=0;
pr=99999;
se=99999;
for i=1:size(horPro,1)
    if (horPro(i)~=0 & primero==0)
        pr=i-1;
        primero=1;
    end
    if (horPro(i)==0 & segundo==0 & primero==1)
        se=i;
        segundo=1;
    elseif(segundo==1 & horPro(i)~=0)
        segundo=0;
        se=99999;
    end
end
if pr == 0
    pr=1;
end
if se==99999
    se=M;
end
BW=imcrop(BW,[1,pr,N,se-pr]);


[M,N]=size(BW);
verPro=sum(BW,1); 
% 
% figure;
% subplot(2,1,1);imshow(BW);
% title('Image');
% 
% subplot(2,1,2);plot(verPro, 'r-');
% title('Vertical Projection');

primero=0;
segundo=0;
pri=99999;
seg=99999;
for i=1:size(verPro,2)
    if (verPro(i)~=0 & primero==0)
        pri=i-1;
        primero=1;
    end
    if (verPro(i)==0 & segundo==0 & primero==1)
        seg=i;
        segundo=1;
    elseif(segundo==1 & verPro(i)~=0)
        segundo=0;
         seg=99999;
    end
end
if pri == 0
    pri=1;
end
if seg==99999
    seg=N;
end
recorte=imcrop(BW,[pri,1,seg-pri,M]);

%Añadimos margenes para imagen cuadrada

[M,N]=size(recorte);
if M>N
    imMargenes=zeros(M,M);
    marg=fix((M-N)./2)+1;
    imMargenes(:,marg:(marg+N-1))=recorte;
elseif N>M
    imMargenes=zeros(N,N);
    marg=fix((N-M)./2)+1;
    imMargenes(marg:(marg+M-1),:)=recorte;
elseif N==M
    imMargenes=recorte;
end

%imshow(recorte)
x=pri; 
y=pr;
w=(seg-pri);
h=(se-pr);

