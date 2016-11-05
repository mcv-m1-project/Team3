function [ output_args ] = filterCandidates( path, templates, th)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    f = dir(path);
    finalCandidates = [];
    
    for i=1:size(f,1)
        
        if f(i).isdir==0,
            if strcmp(f(i).name(end-2:end),'mat')==1,
                
                load(strcat(path,f(i).name));
                im = imread(strcat(path, f(i).name(1:end-3),'png'));
                
                %hold on;
                imshow(im);
                pause(0.2);
                imEdge = edge(im, 'Canny');
                
                
                               
                
                for j=1:size(windowCandidates,1)
                    
                    inix = windowCandidates(j).x;
                    iniy = windowCandidates(j).y;
                    w = windowCandidates(j).w;
                    h = windowCandidates(j).h;
                    endx = inix + w-1;
                    endy = iniy + h-1;
                    
                    newSize = max(w,h);
                    wpad = (max(w,h)-w)/2;
                    hpad = (max(w,h)-h)/2;
                    newim = zeros(max(w,h), max(w,h));
                    
                    newim( hpad+1:hpad+h,wpad+1:wpad+w) = imEdge(iniy:endy, inix:endx);
                    
                    
                    
  
                    %imshow(imEdge(iniy:endy, inix:endx));
                    %pause(0.2);
                    
                    dist = bwdist(newim);%== 0;
                    %imshow(dist);
                    %pause(0.2);
                    %dist = imEdge(iniy:endy, inix:endx);
                    found = false;
                    for k=1:size(templates,2)
                        auxTemp = single(imresize(templates{k}, [max(h,w), max(h,w)]));
                        
                        auxTemp = edge(auxTemp, 'Canny');
                        %imshow(auxTemp);
                        %pause(0.2);
                        %auxTemp = imresize(imfill(templates{k}>0), [h w]);
                        
                        mult = dist .* auxTemp;
                        val = sum(sum(mult)); 
                        
                        if(val < th)
                            found = true;                            
                        end  
                    end
                    
                    if found == true 
                        finalCandidates = [finalCandidates; windowCandidates(j)];
                        rectangle('Position', [inix, iniy, w, h], 'EdgeColor', 'g');
                    else
                        rectangle('Position', [inix, iniy, w, h], 'EdgeColor', 'r');
                    end
                end
                
                pause(0.2);
                %hold off;
            end
        end
    end


end

