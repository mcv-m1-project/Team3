im = im2double(imread('cameraman.tif'));
[ni, nj] = size(im);
ker = im(100:140, 180:220);
[ki, kj] = size(ker);
r = normxcorr2(ker, im);
[ri, rj] = size(r);

figure
imshow(r)



i_dif = ceil(ki/2);
j_dif = ceil(kj/2);

r = r(i_dif:ni+i_dif, j_dif:nj+j_dif);

[rows cols] = find(r > 0.8);

% get the BB original coordinates
rows = rows - double(idivide(int32(ki), 2, 'ceil'));
cols = cols - double(idivide(int32(kj), 2, 'ceil'));

rows = num2cell(rows);
cols = num2cell(cols);

% store the values on the output struct
[windowCandidates(1:length(rows)).x] = deal(cols{:});
[windowCandidates(1:length(rows)).y] = deal(rows{:});
[windowCandidates(1:length(rows)).w] = deal(ki); 
[windowCandidates(1:length(rows)).h] = deal(kj);

windowCandidates = transpose(windowCandidates);

figure
imshow(r)

for a=1:size(windowCandidates, 1)
    rectangle('Position',[windowCandidates(a).x ,windowCandidates(a).y ,windowCandidates(a).w,windowCandidates(a).h],'EdgeColor','c');
end 

