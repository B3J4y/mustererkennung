function backprogXor
    o = [0 0; 0 1; 1 0; 1 1];
    one = [1;1;1;1];
    gamma = 2;
    
    W1 = rand(3,2);
    W2 = rand(3,1);
    E = 1;
    iterationen = 0;
    while E > 0.01
        %sigmoid = (1 + exp(-matrix)).^(-1)
        o_1 = [(1 + exp(-[o one]*W1)).^(-1) one]; 
        o_2 = (1 + exp(-(o_1* W2))).^(-1);

        E = sum(1/2*(o_2-[0;1;1;0]).^2);
        iterationen = iterationen+1
        W2_t = W2(1:2);
        e = (o_2-[0;1;1;0]);

        %delt_2 = (o_2.*(1-o_2))*e
        for t=1:4
            %Berechnung W2
            delt_2 = (o_2(t).*(1-o_2(t))).*e;
            W2 = W2 - (gamma*o_1(t,:)*delt_2(t))';
            
            %Berechnung W1
            temp = o_1(t,1:2).*(1-o_1(t,1:2));
            D_1 = diag(temp);
            delt_1 = D_1 *W2_t * delt_2(t, :);
            o_d = [o one];
            W1 = W1-(gamma*delt_1*o_d(t, :))';
        end
        
    end
    W1
    W2
    o_2
    iterationen
end