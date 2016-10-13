%%Function used to extract the local maxima (peaks) from histograms. Later
%%these peaks will be used to find the threshold 

allfiles = dir('signalsRelacionado');
xHist(1:512)=0:511;
for i=3:size(allfiles,1)
    allfilesGroup = dir(strcat('signalsRelacionado\',allfiles(i).name));
    mkdir(strcat('peaks\',allfiles(i).name));
    for j=4:size(allfilesGroup,1)
       load(strcat('signalsRelacionado\',allfiles(i).name,'\',allfilesGroup(j).name));
       [pks,locs] = findpeaks(yHist); %returns a vector with the local maxima (peaks).
       C = strsplit(allfilesGroup(j).name,'_');
       save(strcat('peaks\',allfiles(i).name,'\',cell2mat(C(1)),'.mat'),'pks');
       
       yHist_smooth=yHist;
       for z=1:10
           yHist_smooth=smooth(yHist_smooth); %smooths the data in the column vector using a moving average filter
       end
       [pks_smooth,locs_smooth] = findpeaks(yHist_smooth);
       save(strcat('peaks\',allfiles(i).name,'\',cell2mat(C(1)),'_smooth.mat'),'pks_smooth');
       
    end
end