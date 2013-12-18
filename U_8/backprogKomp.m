function backprogKomp
    train = dlmread('pendigits-training.txt');
    test = dlmread('pendigits-testing.txt');
    train = [train(:, 1:16)./100 train(:, 17)];
    gamma = 1;
    k = 4;
    one = ones(length(train), 1);
    W1 = rand(17,k)
    W2 = rand(k+1,10)
    E = 1;
    iterationen = 0;
    while E > 0.01
        o_2 = zeros(1,10);
        iterationen = iterationen+1
        %sigmoid = (1 + exp(-matrix)).^(-1)
        for m = 1:length(train)
            v = [train(m, 17)==0 train(m, 17)==1 train(m, 17)==2 train(m, 17)==3 train(m, 17)==4 train(m, 17)==5 train(m, 17)==6 train(m, 17)==7 train(m, 17)==8 train(m, 17)==9];
            o_1 = [(1 + exp(-[train(m, 1:16) 1]*W1)).^(-1) 1];            
            o_2 = o_2+sum(1 + exp(-(o_1* W2))).^(-1)*v;
           
            
        end
        E = sum(1/2*(o_2-v).^2);
            
        W2_t = W2(1:k);
        e = (o_2-train(17))';
        o_2 = o_2';
        o_1 = o_1';
        %for t=1:10
            %Berechnung W2
            %delt_2 = diag((o_2(t).*(1-o_2(t))).*e);
            D_2 = diag((o_2.*(1-o_2)).*e);
            delt_2 = D_2*e;
            
            W2 = W2 - (gamma*o_1*delt_2');
            
            %Berechnung W1
            temp = o_1(1:k,:).*(1-o_1(1:k,:));
            D_1 = diag(temp);
            delt_1 = D_1 *W2_t * delt_2;
            o_d = [sum(train(:,1:16)) 1];
            W1 = W1-(gamma*delt_1*o_d)';
        %end
        W1
        W2
        
    end
end