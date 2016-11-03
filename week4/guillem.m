% im = rgb2gray(imread('../SplitDataset/train/01.001796.jpg'));
im = imread('../SplitDataset/train/mask/mask.01.001796.png')>0;
imshow(im);
waitforbuttonpress
edg = edge(im, 'Canny', 0.1, 3);

template = im2double(rgb2gray(imread('/home/guillem/Desktop/triangle.png')));
template = imdilate(template, ones(9,9));
%imshow(template);
[ti, tj] = size(template);

% debug
[imi, imj] = size(im);
% edg = zeros([imi, imj]);
% edg(100:99+ti,400:399+tj) = template;

imshow(edg);
waitforbuttonpress;

dist = bwdist(edg);

% dist = dist./max(dist(:)); % Normalize 0-1
imshow(dist./max(dist(:)));
waitforbuttonpress

% flip because convolution flips the kernel
template = flipud(fliplr(template));
C = conv2(dist,template,'same');
% C = (C-min(C(:)))./max(C(:)); % normalize 0-1
imshow((C-min(C(:)))./max(C(:))); % normalize 0-1
waitforbuttonpress

%[cols rows] = find(C < 0.0001);
[ColumnMin, Y]= min(C);
[Gmin, X]= min(ColumnMin);
min_x = X;
min_y = Y(X);

min_x = min_x - 50; % 100/2 = 50
min_y = min_y - 50; % 100/2 = 50



windowCandidates = [];
windowCandidates = [windowCandidates; struct('x', min_x, 'y', min_y, 'w', ti, 'h', tj)];

imshow(im)
for a=1:size(windowCandidates, 1)
    rectangle('Position',[windowCandidates(a).x ,windowCandidates(a).y ,windowCandidates(a).w,windowCandidates(a).h],'EdgeColor','c');
end
hold on
plot(min_x,min_y,'r.','MarkerSize',20) 
waitforbuttonpress
