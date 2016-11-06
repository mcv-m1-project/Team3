function [ windowCandidates ] = templateCorrelation( im, templates, thrs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    global RESCALE;

    windowCandidates = [];
    [ni, nj] = size(im);
    [ki, kj] = size(templates{1});
    
    % Compute the correlation for each template
    corr1 = normxcorr2(templates{1}, im);
    corr2 = normxcorr2(templates{2}, im);
    corr3 = normxcorr2(templates{3}, im);
    corr4 = normxcorr2(templates{4}, im);
    
     % Get central crop of the correlation
    i_dif = ceil(ki/2);
    j_dif = ceil(kj/2);
    corr1 = corr1(i_dif:ni+i_dif, j_dif:nj+j_dif);
    corr2 = corr2(i_dif:ni+i_dif, j_dif:nj+j_dif);
    corr3 = corr3(i_dif:ni+i_dif, j_dif:nj+j_dif);
    corr4 = corr4(i_dif:ni+i_dif, j_dif:nj+j_dif);

    %[SSD corr1 data] = template_matching(templates{1}, im);
    maxCorr1 = sum( sum ( (templates{1} .* templates{1}) ) );
    %[SSD corr2 data] = template_matching(templates{2}, im);
    maxCorr2 = sum( sum ( (templates{2} .* templates{2}) ) );
    %[SSD corr3 data] = template_matching(templates{3}, im);
    maxCorr3 = sum( sum ( (templates{3} .* templates{3}) ) );
    %[SSD corr4 data] = template_matching(templates{4}, im);
    maxCorr4 = sum( sum ( (templates{4} .* templates{4}) ) );
    
    % Filter the hight values of the correlation
    ypeak = [];
    xpeak = [];
    [ypeakTemp, xpeakTemp] = find(corr1 > thrs(1));  %max(corr1(:)));    
    % store the values on the output struct
    xpeak = xpeakTemp - double(uint16(ki/2));
    ypeak = ypeakTemp - double(uint16(kj/2));      

    for i=1 : size(ypeakTemp);
        windowCandidates = [windowCandidates; struct('x', double(xpeak(i)), 'y', double(ypeak(i)), 'w', kj, 'h', ki)];%, 'max', corr1(ypeakTemp(i),xpeakTemp(i))/maxCorr1)];
    end
    

    [ypeakTemp, xpeakTemp] = find(corr2 > thrs(2)); %max(corr2(:)));
    % store the values on the output struct
    xpeak = xpeakTemp - double(uint16(ki/2));
    ypeak = ypeakTemp - double(uint16(kj/2));      

    for i=1 : size(ypeakTemp);
        windowCandidates = [windowCandidates; struct('x', double(xpeak(i)), 'y', double(ypeak(i)), 'w', kj, 'h', ki)];%, 'max', corr2(ypeakTemp(i),xpeakTemp(i))/maxCorr2)];
    end

    [ypeakTemp, xpeakTemp] = find(corr3 > thrs(3)); %max(corr3(:)));
   
    % store the values on the output struct
    xpeak = xpeakTemp - double(uint16(ki/2));
    ypeak = ypeakTemp - double(uint16(kj/2));      
    for i=1 : size(ypeakTemp);
        windowCandidates = [windowCandidates; struct('x', double(xpeak(i)), 'y', double(ypeak(i)), 'w', kj, 'h', ki)];%, 'max', corr3(ypeakTemp(i),xpeakTemp(i))/maxCorr3)];
    end

    
    [ypeakTemp, xpeakTemp] = find(corr4 > thrs(4));

    % store the values on the output struct
    xpeak = xpeakTemp - double(uint16(ki/2));
    ypeak = ypeakTemp - double(uint16(kj/2));      
    for i=1 : size(ypeakTemp,1);
        windowCandidates = [windowCandidates; struct('x', double(xpeak(i)), 'y', double(ypeak(i)), 'w', kj, 'h', ki)];%, 'max', corr4(ypeakTemp(i),xpeakTemp(i))/maxCorr4)];
    end

end

