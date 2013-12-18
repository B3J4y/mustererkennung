function maxExp
    %Cluster erstellen
    clust1var = 5;
    clust1mean = -5;
    clust1 = randn(100,2).*clust1var + clust1mean;
    clust2var = 2;
    clust2mean = 5;
    clust2 = randn(100,2).*clust1var + clust2mean;
    global clust;
    clust = [[clust1(:,1); clust2(:,1)] [ clust1(:,2); clust2(:,2)]];
    plot(clust(:,1), clust(:,2), '.')
    pause;
    
    %Varianz und Mittelwert schätzen
    var1 = floor(randn(1)*10);
    mean1 = floor(randn(1)*10);
    var2 = floor(randn(1)*10);
    mean2 = floor(randn(1)*10);
    
    %Erster Schritt
    [cl1, cl2] = expStep(mean1, mean2, cov(clust), cov(clust))
    bool = true;
    %Solange bis die Größe der Matrizen gleich bleibt
    while bool
        size1 = size(cl1(:,1));
        size2 = size(cl2(:,1));
        [cl1, cl2] = expStep(mean(cl1), mean(cl2), cov(cl1), cov(cl2));
        if size1 == size(cl1(:,1))
           if  size2 == size(cl2(:,1))
               bool = false;
           end
        end
    end
    title ('Ende');
    

end
%Funktion, die den einzelnen expectation maximization step ausführt
function [cluster1, cluster2] = expStep(mean1 , mean2, cov1, cov2)
    global clust
    res = [mvnpdf(clust, mean1, cov1) mvnpdf(clust, mean2, cov2)]
    maxres = max(res, [], 2);
    clust1 = [];
    clust2 = [];
    %Zuordnung zu den einzelnen Klassen
    for i=1:200
        index = find(res(i,:)==maxres(i,1));
        if index == 1
            clust1 = [clust1; clust(i,:)];
        else 
            clust2 = [clust2; clust(i,:)];
        end 
    end
    plot(clust1(:,1),clust1(:,2),'.', clust2(:,1),clust2(:,2), '.');
    title(['Size1: ' num2str(size(clust1)) ' Size2: ' num2str(size(clust2))]);
    pause;
    cluster1 = clust1;
    cluster2 = clust2;
end