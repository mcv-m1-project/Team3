function [ filteredCandidates ] = filterCandidatesChamfer(  pixelCandidates, windowCandidates, templates, th)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    filteredCandidates = [];
    im = edge(pixelCandidates, 'Canny');
    

    for i=1:size(windowCandidates,1)
        wc = windowCandidates(i);
        try
            crop = im(wc.y:wc.y+wc.h,wc.x:wc.x+wc.w);
        catch
            continue
        end
        dist = bwdist(crop);
        found = false;
        
        for j=1:size(templates,2)
            tmpl = imresize(templates{j}, size(crop));
            tmpl = double(edge(tmpl, 'Canny'));
            
            val = sum(tmpl.*dist);
            val = sum(val(:))/((size(dist, 1)*size(dist, 2)));
                        
            if(val < th ) 
               found = true; 
            end       
        end
        
        if found==true
            filteredCandidates = [ filteredCandidates; windowCandidates(i)];
        end
    end
end
