function [ output_args ] = testPau( pathGt, pathImg )
%TESTPAU Summary of this function goes here
%   Detailed explanation goes here
    error=0;
    files = dir(pathGt);
    bigPicture = uint8(zeros(1,1,3));
    cnt = 0;
    margin = 20;
    inix=1;
    iniy=1;
    maxHeight = 1;
    for i=1:length(files)
        if (strcmp(files(i).name(1:1), 'g'))
            fid = fopen(strcat(pathGt, files(i).name));
            
            %files(i).name
            data=textscan(fid,'%f %f %f %f %s','delimiter',' ');
            fclose(fid);

            for j=1:length(data{1})
                try
                    x1 = uint16(data{1}(j));
                    y1 = uint16(data{2}(j));
                    x2 = uint16(data{3}(j));
                    y2 = uint16(data{4}(j));
                    img = imread(strcat(pathImg, files(i).name(4:end-3), 'jpg'));
                    crop = img(x1-margin:x2+margin, y1-margin:y2+margin, :);
                    width = (x2+margin)-(x1-margin);
                    height = (y2+margin)-(y1-margin);
                    bigPicture(inix:inix+width, iniy:iniy+height,:) = crop(:,:,:);
                    if(height > maxHeight)
                        maxHeight = height;
                    end
                    inix = inix+width;
                    cnt = cnt+1;
                    if cnt > 25 
                        inix=1;
                        iniy = iniy + maxHeight;
                        cnt=0;
                        maxHeight = 1;
                    end
                catch
                    error = error+1;
                end
            end
        end
    end
    
    error
    imwrite(bigPicture, 'testMargin.jpg');

end

