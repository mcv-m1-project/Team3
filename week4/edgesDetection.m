function [ BW ] = edgesDetection( I, edges, color)
    switch color
        case 'bw'
            I=im2bw(I);
        case 'bwOtsu'
            level = graythresh(I);
            I = im2bw(I,level);
        case 'gray'
            I=rgb2gray(I);
        otherwise
            error('Color name not valid.');
    end
    
    switch edges
        case 'Sobel'
            BW = edge(I,'Sobel');
        case 'Prewitt'
            BW = edge(I,'Prewitt');
        case 'Canny'
            BW = edge(I,'Canny');
        case 'Roberts'
            BW = edge(I,'Roberts');
        case 'log'
            BW = edge(I,'log');
        case 'gradeMagnitud'
          [Gx, Gy] = imgradientxy(I);
          [BW, Gdir] = imgradient(Gx, Gy);
        case 'gradeMagnitudSobel'
          [BW,Gdir] = imgradient(I,'sobel');
        case 'gradeMagnitudPrewitt'
          [BW,Gdir] = imgradient(I,'prewitt') ;
        case 'gradeMagnitudCentral'
          [BW,Gdir] = imgradient(I,'central') ;
        case 'gradeMagnitudIntermediate'
          [BW,Gdir] = imgradient(I,'intermediate');
        case 'gradeMagnitudRoberts'
          [BW,Gdir] = imgradient(I,'roberts');
        otherwise
           error('Edges detector method not valid.');
    end    
        



end

