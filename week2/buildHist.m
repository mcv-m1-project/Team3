function im_hist = buildHist(im_h, im_s, bins)
%BUILDHIST Creates the H-S histogram of an image.
%   Arguments:
%       im_h:       Hue values in a column vector
%       im_s:       Saturation values in a column vector.
%   Both 'im_h' and 'im_s' must have the same size.

    pixels = [im_h(:) im_s(:)];
    hist_indexes = ceil(pixels*bins); % From pixels to bins
    hist_indexes(hist_indexes<1) = 1; % make 0 indexes become 1
    im_hist = zeros(bins);
    for p=1:size(hist_indexes,1)
        im_hist(hist_indexes(p,1), hist_indexes(p,2)) = im_hist(hist_indexes(p,1), hist_indexes(p,2)) + 1;
    end

end