function [ windowC ] = filterCandidatesHough( windowCandidates, pixelCandidates, im )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    addpath('circular_hough')
    windowC = [];
    
    for i = 1: size(windowCandidates, 1)
        ii = int32(windowCandidates(i).y);
        jj = int32(windowCandidates(i).x);
        iiSize = int32(windowCandidates(i).h);
        jjSize = int32(windowCandidates(i).w);
        crop = [];
        crop = imcrop(pixelCandidates, [jj ii jjSize iiSize]);
        BW = edge(crop, 'Canny');
        cropGray = rgb2gray( imcrop(im, [jj ii jjSize iiSize]) );
        
        if size(cropGray, 1) < 32 || size(cropGray, 2) < 32
            cropGray = imresize(cropGray, 3);
        end
%         imshow(cropGray);
%         waitforbuttonpress;
%         fltr4img = [1 1 1 1 1; 1 2 2 2 1; 1 2 4 2 1; 1 2 2 2 1; 1 1 1 1 1];
%         fltr4img = fltr4img / sum(fltr4img(:));
%         cropGray = filter2( fltr4img , cropGray );
        radRange = [double(jjSize/4)  double(jjSize/2)];
        [accum circen cirrad] = CircularHough_Grd(cropGray, radRange, 15, 5);
        
        
        
        if ~isempty(cirrad)
%             figure; imagesc(crop); colormap('gray'); axis image;
%             hold on;
%             plot(circen(:,1), circen(:,2), 'r+');
%             for k = 1 : size(circen, 1),
%                 DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'g-');
%             end
%             hold off;
%             waitforbuttonpress;
             windowC = [windowC ; struct('x', windowCandidates(i).x, 'y', windowCandidates(i).y, 'w', windowCandidates(i).w, 'h', windowCandidates(i).h)];
%             disp('cirlce');
        else
            [H theta rho] = hough(BW, 'Theta', -90:5:89);
            peaks = houghpeaks(H, 3);
            lines = houghlines(BW, theta, rho, peaks, 'MinLength', 10);

            if size(lines, 2) == 3
                isT = isShape(lines, 'Triangle');
                isS = isShape(lines, 'Square');
                if isT
%                     disp('is triangle')
                    windowC = [windowC ; struct('x', windowCandidates(i).x, 'y', windowCandidates(i).y, 'w', windowCandidates(i).w, 'h', windowCandidates(i).h)];
                elseif isS
%                     disp('is square');
                    windowC = [windowC ; struct('x', windowCandidates(i).x, 'y', windowCandidates(i).y, 'w', windowCandidates(i).w, 'h', windowCandidates(i).h)];
                else
%                     disp('nothing detected');
                end
            end

%             % SHOW THE DETECTED LINES
%             imshow(crop), hold on
%             max_len = 0;
%             for k = 1:length(lines)
%                xy = [lines(k).point1; lines(k).point2];
%                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%                % Plot beginnings and ends of lines
%                plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%                plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%                % Determine the endpoints of the longest line segment
%                len = norm(lines(k).point1 - lines(k).point2);
%                if ( len > max_len)
%                   max_len = len;
%                   xy_long = xy;
%                end
%             end
%             waitforbuttonpress;
%             close all;   
        end
    end
    

end

