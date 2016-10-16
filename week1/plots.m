function  plots( results_histograms_path)
load(results_histograms_path);
color=['r','g','b','m','c'];
col=0;
fig=0;
for i=1:(36*5):size(results,1) %%all signal classes
    col=0;
    fig=fig+2;
    precision = [];
    recall = [];
    sensitivity = [];
    fall_out=[];
    for k=0:36:(35*5)%
        col=col+1;
        for j=0:35 %same color space
            
            
            precision = [precision, cell2mat(results(i+j+k,4))];
            recall = [recall, cell2mat(results(i+j+k,7))];
            %ROC
            sensitivity = [sensitivity,cell2mat(results(i+j+k,7))];
            fall_out=[fall_out, (cell2mat(results(i+j+k,10))/(cell2mat(results(i+j+k,10))+cell2mat(results(i+j+k,12))))];
        end
        screensize = get( groot, 'Screensize' );
        %plot Precision / accuracy
        hold on;
        fig1=figure(fig)
        %set(fig1, 'Position', [0 0 screensize(3)/6 screensize(4)/3])
        title('Precision/Recall - Color Space')
        [precision, sortIndex] = sort(precision);
        recall = recall(sortIndex);
        xlabel('Precision') % x-axis label
        ylabel('Recall') % y-axis label
        plot(precision, recall,color(col));
        
        
        legend('cielab','hsv','rgb','xyz','ycbcr');
        hold off;
        %plot ROC
        hold on;
        fig2=figure(fig-1)
        %set(fig2, 'Position', [0 0 screensize(3)/6 screensize(4)/3])
        title('ROC - Color Space')
        [sensitivity, sortIndex] = sort(sensitivity);
        fall_out = fall_out(sortIndex);
        xlabel('Recall') % x-axis label
        ylabel('Fall out') % y-axis label
        plot(sensitivity, fall_out,color(col));
        hold off;
        legend('cielab','hsv','rgb','xyz','ycbcr');
    end
end

end
