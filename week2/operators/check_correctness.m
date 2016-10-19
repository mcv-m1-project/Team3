function [ ] = check_correctness( im, se, type )
    
    seL = strel(se);
    switch type
        case 'dilate'
            my_I = my_imdilate(im, se);
            %my_I = code_online(im, se);
            I = imdilate(im, seL);
        case 'erode'
            my_I = my_imerode(im, se);
            I = imerode(im, seL);
        otherwise
            disp ('wrong option')
    end
    
    imshow(I);
    waitforbuttonpress;
    imshow(my_I);
    waitforbuttonpress;
    
    diff = I - my_I;
    imshow(diff);
    waitforbuttonpress;
    
    if any(diff(:) > 0)
        disp('different')
    else
        disp('equal')
    end


end

