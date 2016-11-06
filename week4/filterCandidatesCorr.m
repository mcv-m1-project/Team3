function [ filteredCandidates ] = filterCandidatesCorr( im, windowCandidates, templates, th )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    filteredCandidates = [];  
    im = rgb2gray(im);


    for i=1:size(windowCandidates,1)
        wc = windowCandidates(i);
        crop = im(wc.y:wc.y+wc.h,wc.x:wc.x+wc.w);
        found = false;
        
        for j=1:size(templates,2)
            tmpl = imresize(templates{j}, [size(crop,1) size(crop,2)]);
            
            
            mult = crop .* tmpl;
            val = sum(sum(mult)); 
            
            val = val/(size(mult,1)*size(mult,2));
                        
            if(val > th ) 
               found = true; 
            end       
        end
        
        if found==true
            filteredCandidates = [ filteredCandidates; windowCandidates(i)];
        end
    end

end

