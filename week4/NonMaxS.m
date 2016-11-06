function [ boxes_nms ] = NonMaxS( boxes, overlapTh, nms_method )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    boxes_nms = [];
    
    if ~isempty(boxes)
        pick = [];
        
        x1 = [boxes.x];
        y1 = [boxes.y];
        x2 = x1 + [boxes.w];
        y2 = y1 + [boxes.h];
        
        area = (x2-x1) .* (y2-y1);
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
            w = max(0.0, xx2-xx1+1);
            h = max(0.0, yy2-yy1+1);
            
            % Compute the ratio of overlap
            overlap = (w .* h) ./ area(idx(1:last-1));
            
            switch nms_method
                case 'mean'
                    % Average the bboxes that overlap
                    keep_x = [ boxes(i).x boxes(idx(overlap > overlapTh & overlap < 1)).x ];
                    mean_keep_x = mean(keep_x);
                    keep_y = [ boxes(i).y boxes(idx(overlap > overlapTh & overlap < 1)).y ];
                    mean_keep_y = mean(keep_y);
                    keep_w = [ boxes(i).w boxes(idx(overlap > overlapTh & overlap < 1)).w ];
                    mean_keep_w = max(keep_w);
                    keep_h = [ boxes(i).h boxes(idx(overlap > overlapTh & overlap < 1)).h ];
                    mean_keep_h = max(keep_h);
                    new = struct('x',mean_keep_x,'y',mean_keep_y,'w',mean_keep_w,'h',mean_keep_h);
                case 'merge'
                    % Merge the boxes that overlap in one super box
                    keep_x = [ boxes(i).x boxes(idx(overlap > overlapTh & overlap < 1)).x ];
                    mean_keep_x = min(keep_x);
                    keep_y = [ boxes(i).y boxes(idx(overlap > overlapTh & overlap < 1)).y ];
                    mean_keep_y = min(keep_y);
                    keep_x2 = [ x2(i) x2(idx(overlap > overlapTh & overlap < 1)) ];
                    mean_keep_w = max(keep_x2)-mean_keep_x;
                    keep_y2 = [ y2(i) y2(idx(overlap > overlapTh & overlap < 1)) ];
                    mean_keep_h = max(keep_y2)-mean_keep_y;
                    new = struct('x',mean_keep_x,'y',mean_keep_y,'w',mean_keep_w,'h',mean_keep_h);
            end
            
            boxes_nms = [boxes_nms ; new];

            % Delete all indexes from the index list that have
            idx([last find(overlap > overlapTh)]) = [];
        end
    end
    

end

