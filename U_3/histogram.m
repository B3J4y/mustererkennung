function histogram()
    first = [1 1 1 1 1 1 1 1 1 1];
    histog = first;
    for i = 2:100
        histog = [histog first*i];
    end
    
    ew =  mean(histog);
    var = std(histog);
    
    subplot(2, 5,1);
    hist(histog, 100);
    
    mean(histog)
    std(histog)
    
    title(['EW: ' num2str(ew) ' Var: ' num2str(var)]);
    xlabel(['Entropie ' ]);
    
    for i = 2:10
        for j = 1:10
            histog(find(histog == (1+j*i),1, 'first'))= floor(30+j*i/2);
        end
        for j = 1:10
            histog(find(histog == (100-j*i),1, 'first'))= floor(70-j*i/2);
        end
        subplot(2, 5,i);
        hist(histog, 100);
        title(['EW: ' num2str(mean(histog)) ' Var: ' num2str(std(histog))]);
    end
end