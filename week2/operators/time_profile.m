im = imread('1_mask.jpg');
im = rgb2gray(im);
im = logical (im);
se = [1 1 1; 1 0 1; 1 1 1];

% Measure time for matlab imdilate
tic;
for i=1:100
    imdilate(im, se);
end
total_time = toc;
fprintf('Total time imdilate (s): %f\n', total_time);

% Measure time for my_imdilate
tic;
for i=1:100
    my_imdilate(im, se);
end
total_time = toc;
fprintf('Total time my_imdilate (s): %f\n', total_time);

% Measure time for matlab imdilate
tic;
for i=1:100
    imerode(im, se);
end
total_time = toc;
fprintf('Total time imerode (s): %f\n', total_time);

% Measure time for matlab imdilate
tic;
for i=1:100
    my_imerode(im, se);
end
total_time = toc;
fprintf('Total time my_imerode (s): %f\n', total_time);