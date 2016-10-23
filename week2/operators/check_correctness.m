function [ ] = check_correctness( im, se, type )
% checks if the implemented morphological operators have the same results
% as the matlab ones
% Parameters:
%           im: image for the test
%           se: structuring element represented as a logical matrix
%           type: (accepted values: 'dilate' or 'erode') string indicating the type of test
    
    % test dilate or erode
    switch type
        case 'dilate'
            my_I = my_imdilate(im, se);
            %my_I = code_online(im, se);
            I = imdilate(im, se);
        case 'erode'
            my_I = my_imerode(im, se);
            I = imerode(im, se);
        otherwise
            disp ('wrong option')
    end
    
    % Show the difference image
    diff = I - my_I;
    imshow(diff);
    
    % verify if there is any difference
    if any(diff(:) > 0)
        disp('different')
    else
        disp('equal')
    end
    
end

