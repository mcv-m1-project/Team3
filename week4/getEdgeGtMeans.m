function [means] = getEdgeGtMeans( pathGt, pathImg, pathMask, method, color)
    dataset = dataset2mat(pathGt, pathImg, pathMask);
    
    classCircle = {};
    classSquare = {};
    classUpTriangle = {};
    classDownTriangle = {};
    
    meanx = 93;
    meany = 88;
    
    for i = 1 : length(dataset)
        for j = 1 : size(dataset{1,1}{3}{1},1)
            inix = dataset{i,1}{3}{j}{1};
            endx = dataset{i,1}{3}{j}{3};
            iniy = dataset{i,1}{3}{j}{2};
            endy = dataset{i,1}{3}{j}{4};
            
            fullIm = imread(dataset{i,1}{2}) > 0;
            im = fullIm(inix:endx, iniy:endy);
            im = imresize(im, [meanx, meany]);
            %im = edgesDetection(im, method, color);
            imshow(im);
            pause(.0001);
            
            switch dataset{i,1}{3}{j}{5}
                case 'A' 
                    classUpTriangle{end+1,1} = im;
                case 'B' 
                    classDownTriangle{end+1,1} = im;
                case 'C' 
                    classCircle{end+1,1} = im;
                case 'D' 
                    classCircle{end+1,1} = im;
                case 'E' 
                    classCircle{end+1,1} = im;
                case 'F' 
                    classSquare{end+1,1} = im;
            end
        end
        
    end
    
    groups = {classCircle; classSquare; classUpTriangle; classDownTriangle; };
    

    means = {};
    for i=1:size(groups,1)
        
        avg = uint16(groups{i}{1});
        for j=2:size(groups{i},1)-1
            avg = avg + uint16(groups{i}{j});
        end
        %means{i} =  (avg./size(groups{i},1));
        means{i} = (double(avg)./double(max(max(avg))));
    end
end
