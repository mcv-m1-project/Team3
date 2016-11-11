function [ isT ] = isShape( lines, shape )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    isT = false;
    
    switch shape
        case 'Triangle'
            % Compute direction vector
            vdir1 = [(lines(1).point1(1) - lines(1).point2(1)) (lines(1).point1(2) - lines(1).point2(2)) ];
            vdir2 = [(lines(2).point1(1) - lines(2).point2(1)) (lines(2).point1(2) - lines(2).point2(2)) ];
            vdir3 = [(lines(3).point1(1) - lines(3).point2(1)) (lines(3).point1(2) - lines(3).point2(2)) ];

            theta12 = acosd((norm(vdir1(1)*vdir2(1)+vdir1(2)*vdir2(2))) / ...
                (sqrt((vdir1(1)^2)+(vdir1(2)^2))*sqrt((vdir2(1)^2)+(vdir2(2)^2))));

            theta13 = acosd((norm(vdir1(1)*vdir3(1)+vdir1(2)*vdir3(2))) / ...
                (sqrt((vdir1(1)^2)+(vdir1(2)^2))*sqrt((vdir3(1)^2)+(vdir3(2)^2))));

            theta23 = acosd((norm(vdir2(1)*vdir3(1)+vdir2(2)*vdir3(2))) / ...
                (sqrt((vdir2(1)^2)+(vdir2(2)^2))*sqrt((vdir3(1)^2)+(vdir3(2)^2))));

            if theta12 < 70 && theta12 > 40 && theta13 < 70 && theta13 > 40 && theta23 < 70 && theta23 > 40
                isT = true;
            end
            
        case 'Square'
            % Compute direction vector
            vdir1 = [(lines(1).point1(1) - lines(1).point2(1)) (lines(1).point1(2) - lines(1).point2(2)) ];
            vdir2 = [(lines(2).point1(1) - lines(2).point2(1)) (lines(2).point1(2) - lines(2).point2(2)) ];
            vdir3 = [(lines(3).point1(1) - lines(3).point2(1)) (lines(3).point1(2) - lines(3).point2(2)) ];

            theta12 = acosd((norm(vdir1(1)*vdir2(1)+vdir1(2)*vdir2(2))) / ...
                (sqrt((vdir1(1)^2)+(vdir1(2)^2))*sqrt((vdir2(1)^2)+(vdir2(2)^2))));

            theta13 = acosd((norm(vdir1(1)*vdir3(1)+vdir1(2)*vdir3(2))) / ...
                (sqrt((vdir1(1)^2)+(vdir1(2)^2))*sqrt((vdir3(1)^2)+(vdir3(2)^2))));

            theta23 = acosd((norm(vdir2(1)*vdir3(1)+vdir2(2)*vdir3(2))) / ...
                (sqrt((vdir2(1)^2)+(vdir2(2)^2))*sqrt((vdir3(1)^2)+(vdir3(2)^2))));

            if (theta12 < 100 && theta12 > 80 && theta13 < 100 && theta13 > 80) && theta23 < 10 || theta23 > 350
                isT = true;
            elseif theta12 < 10 || theta12 > 350 && (theta13 < 100 && theta13 > 80 && theta23 < 350 && theta23 > 10)
                isT = true;
            elseif (theta12 < 100 && theta12 > 80 && theta23 < 100 && theta23 > 80) && theta13 < 10 || theta13 > 350
                isT = true;
            elseif theta12 < 10 || theta12 > 350 && (theta13 < 10 && theta13 > 350 && theta23 < 10 && theta23 > 350)
                isT = true;
            elseif (theta12 < 10 || theta12 > 350) && (theta13 < 10 || theta13 > 350) && (theta23 < 10 || theta23 > 350)
                isT = true;
            end
            
        otherwise
            error('Incorrect shape defined');
            return
    end
end

