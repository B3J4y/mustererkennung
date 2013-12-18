function wineq
    wines = dlmread('winequality-red.txt', ';');
    ind = 1:11;
    figure;
    %idxVec = 1:11;
    hold on;
    minVec = zeros(1,11) + 5000;
    %einzelne Kombinationen
    for i=ind
        comb = combnk(ind, i);
        [len, ~] = size(comb);
        for com = 1:len
           mod = LinearModel.fit(wines(:,comb(com, :)), wines(:,end));
           minVec(1, i) = min(mod.SSE, minVec(1, i));
           plot(i, mod.SSE);
        end
        
        
        %combData = wines(:,comb');
        %Lineare Regression
        
    end
    plot(1:11, minVec, '--r*');
    axis([0 12 650 1050])
    hold off;
    %plot(wines(:,12), wines(:,1:11), 'o')
    %surf(xes, wines(:,12), wines(:,1:11))
end