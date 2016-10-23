function [ output_args ] = configurationSearch( directory, pixel_method, window_method, decision_method )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    for i=1:5:30
       disp( sprintf( 'Diamond size %d', i ) )
       element = strel('diamond', i);
       TrafficSignDetection(directory, pixel_method, window_method, decision_method, element); 
    end
    
    for i=3:3:30
        disp( sprintf( 'Octagon size %d', i ) )
       element = strel('octagon', i);
       TrafficSignDetection(directory, pixel_method, window_method, decision_method, element); 
    end
    
    
    for i=1:5:30
       disp( sprintf( 'Square size %d', i ) )
       element = strel('square', i);
       TrafficSignDetection(directory, pixel_method, window_method, decision_method, element); 
    end
    
    for i=1:5:30
        disp( sprintf( 'Disk size %d', i ) )
       element = strel('disk', i, 8);
       TrafficSignDetection(directory, pixel_method, window_method, decision_method, element); 
    end
    
    
    
    

end

