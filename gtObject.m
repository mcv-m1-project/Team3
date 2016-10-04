classdef gtObject
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        size
        formFactor
        fillingRatio
        type
    end
    
    methods
        function obj = gtObject(x1, y1, x2, y2, type, mask)
            obj.size = (x2-x1)*(y2-y1);
            obj.formFactor = (x2-x1)/(y2-y1);
            obj.type = type;
            img = mask(uint8(x1):uint8(x2), uint8(y1):uint8(y2));
            obj.fillingRatio = sum(img(:)) / numel(img);
        end
    end
    
end

