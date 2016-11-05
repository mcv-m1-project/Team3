function [ filteredCandidates ] = filterCandidatesChamfer(  pixelCandidates, windowCandidates, templates, th)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    filteredCandidates = [];
    im = edge(pixelCandidates, 'Canny');
    

    for i=1:size(windowCandidates,1)
        wc = windowCandidates(i);
        crop = im(wc.y:wc.y+wc.h,wc.x:wc.x+wc.w);
        dist = bwdist(crop);
        found = false;
        
        for j=1:size(templates,2)
            tmpl = single(imresize(templates{j}, [size(crop,1) size(crop,2)]));
            
            
            mult = dist .* tmpl;
            val = sum(sum(mult));
            val = val/sum(size(mult));
                        
            if(val < th ) 
               found = true; 
            end       
        end
        
        if found==true
            filteredCandidates = [ filteredCandidates; windowCandidates(i)];
        end
    end
end
