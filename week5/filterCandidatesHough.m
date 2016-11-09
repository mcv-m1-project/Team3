function [ windowCandidates ] = filterCandidatesHough( windowCandidates, pixelCandidates, im )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    addpath('circular_hough')
    
    for i = 1: size(windowCandidates, 1)
        ii = int32(windowCandidates(i).y);
        jj = int32(windowCandidates(i).x);
        iiSize = int32(windowCandidates(i).h);
        jjSize = int32(windowCandidates(i).w);
        crop = [];
        crop = imcrop(pixelCandidates, [jj ii jjSize iiSize]);
        BW = edge(crop, 'Canny');
        cropGray = rgb2gray( imcrop(im, [jj ii jjSize iiSize]) );
        
        if size(cropGray, 1) < 32 && size(cropGray, 2) < 32
            cropGray = imresize(cropGray, [33 33]);
        end
%         fltr4img = [1 1 1 1 1; 1 2 2 2 1; 1 2 4 2 1; 1 2 2 2 1; 1 1 1 1 1];
%         fltr4img = fltr4img / sum(fltr4img(:));
%         cropGray = filter2( fltr4img , cropGray );
        radRange = [jjSize/4  jjSize/2]
        [accum circen cirrad] = CircularHough_Grd(cropGray, [10 70]);
        
%         figure(1); imagesc(cropGray); axis image;
%         title('Accumulation Array from Circular Hough Transform');
        figure; imagesc(BW); colormap('gray'); axis image;
        hold on;
        plot(circen(:,1), circen(:,2), 'r+');
        for k = 1 : size(circen, 1),
            DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
        end
        hold off;
%         title(['Raw Image with Circles Detected ', ...
%         '(center positions and radii marked)']);
%         figure(3); surf(accum, 'EdgeColor', 'none'); axis ij;
%         title('3-D View of the Accumulation Array');
        waitforbuttonpress;
        
        
        
%         
%         
%         
%         
%         [H theta rho] = hough(BW, 'Theta', -90:5:89);
%         
%         peaks = houghpeaks(H, 3);
%         
%         lines = houghlines(BW, theta, rho, peaks, 'MinLength', 10);
%         
%         if size(lines, 2) == 3
%             isT = isTriangle(lines);
%             if isT
%                 disp('is triangle')
%             end
%         end
%         if size(lines, 2) <= 1
%             disp('circle')
%         end
%         
%         % SHOW THE DETECTED LINES
%         imshow(crop), hold on
%         max_len = 0;
%         for k = 1:length(lines)
%            xy = [lines(k).point1; lines(k).point2];
%            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%            % Plot beginnings and ends of lines
%            plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%            plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%            % Determine the endpoints of the longest line segment
%            len = norm(lines(k).point1 - lines(k).point2);
%            if ( len > max_len)
%               max_len = len;
%               xy_long = xy;
%            end
%         end
%         waitforbuttonpress;
%         close all;
%         
     end
    

end

