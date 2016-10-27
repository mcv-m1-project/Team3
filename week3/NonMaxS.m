function [ boxes_nms ] = NonMaxS( boxes, overlapTh )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    boxes_nms = [];
    
    if ~isempty(boxes)
        pick = [];
        
        x1 = [boxes.x];
        y1 = [boxes.y];
        x2 = x1 + [boxes.w];
        y2 = x2 + [boxes.h];
        
        area = (x2-x1+1) .* (y2-y1+1);
        [vals, idx] = sort(y2);
        
        while ~isempty(idx)
            last = length(idx);
            i = idx(last);
            pick = [pick; i];
             
            xx1 = max(x1(i), x1(idx(1:last-1)));
            yy1 = max(y1(i), y1(idx(1:last-1)));
            xx2 = min(x2(i), x2(idx(1:last-1)));
            yy2 = min(y2(i), y2(idx(1:last-1)));
            
            % Compute the width and height of the bounding box
            w = max(0, xx2-xx1+1);
            h = max(0, yy2-yy1+1);
            
            % Compute the ratio of overlap
            overlap = (w .* h) ./ area(idx(1:last-1));
            
            % Average the bboxes that overlap
            keep_x = [ boxes(last).x boxes(overlap > overlapTh).x ];
            mean_keep_x = mean(keep_x);
            keep_y = [ boxes(last).y boxes(overlap > overlapTh).y ];
            mean_keep_y = mean(keep_y);
            keep_w = [ boxes(last).w boxes(overlap > overlapTh).w ];
            mean_keep_w = mean(keep_w);
            keep_h = [ boxes(last).h boxes(overlap > overlapTh).h ];
            mean_keep_h = mean(keep_h);
            
            boxes_nms = [boxes_nms ; struct('x',mean_keep_x,'y',mean_keep_y,'w',mean_keep_w,'h',mean_keep_h)];
       
            % Delete all indexes from the index list that have
            idx(last) = [];
            idx(overlap > overlapTh) = [];
        end
%        boxes_nms = boxes(pick);
    end
    

end

