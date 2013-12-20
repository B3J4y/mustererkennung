function backprog
    Aufgabe = 'a'
    backprogA(1, 0);

    Aufgabe = 'b'
    backprogA(1, 0.001);

    Aufgabe = 'c'
    backprogC(0.01, 1, 1.5, 0.5);
    Aufgabe = 'd'
    backprogA(0.75, 0.01);
end

function [] =  backprogA(g, momentum)
    TRAINING = 60;
    TESTING = 90;
    data = dlmread('pendigits-training.txt');
    training = data(1:TRAINING, :);
    testing = data(TRAINING+1:TESTING, :);

    % training(101:end,:) = [];                % reduce trainingsize in development
    % testing(10:end,:) = [];
    [nr, ~] = size(training);


    [training_result] = initialResult(training);
    [testing_result] = initialResult(testing);
    % each row in training_result represents the 10 outputclasses
    % 0 at (ml)index i indiciates this input is NOT supposed to be the number (i-1)
    % 1 at (ml)index i indiciates this input is supposed to be the number (i-1)
    % credit:  http://stackoverflow.com/questions/6276252/how-to-efficiently-access-change-one-item-in-each-row-of-a-matrix

    %remove last row (results) from training
    training(:,end) = [];
    training = training./100;
    
    %remove last row (results) from training
    testing(:,end) = [];
    testing = testing./100;

    global k;
    global gamma;
    global alpha;
    
    alpha = momentum;
    k = 16;             % hidden units  (4, 8, 16)
    gamma = g;        % scaling-factor
    max_E = 1.0;        %train network until sum of squared errors is smaller than max_E
    E = max_E + 1;      %initialize E with a value greater than max_E

    W_1_overline = zeros(size(training, 2) + 1, k) - 0.5;
    W_2_overline = zeros(k + 1, 10) - 0.5;

    numOfIterations = 0;


    % apply backprop-algo for every training-row on network while sum of
    % squared errors is greater than max_E
    E_training = 1;
    E_testing = E_training-1;

    % apply backprop-algo for every training-row on network while sum of
    % squared errors is greater than max_E
    
    
    old_delta1= 0;
    old_delta2= 0;
    
    while E_training > E_testing
        numOfIterations = numOfIterations + 1;

        
        [E_training, W_batch_1, W_batch_2, delta1, delta2] = firstStream(training, training_result, W_1_overline, W_2_overline, old_delta1, old_delta2);
        
        W_1_overline = W_1_overline + W_batch_1;
        W_2_overline = W_2_overline + W_batch_2;
        old_delta1 = delta1;
        old_delta2 = delta2;
        [E_testing, ~, ~, ~, ~] = firstStream(testing, testing_result, W_1_overline, W_2_overline, 0, 0);
        
        %write out E
        E_testing;
        E_training;
    end

    E_training
    numOfIterations
end

function [] =  backprogC(gammaMin, gammaMax, u1, d1)
    TRAINING = 60;
    TESTING = 90;
    data = dlmread('pendigits-training.txt');
    training = data(1:TRAINING, :);
    testing = data(TRAINING+1:TESTING, :);

    % training(101:end,:) = [];                % reduce trainingsize in development
    % testing(10:end,:) = [];
    [nr, ~] = size(training);


    [training_result] = initialResult(training);
    [testing_result] = initialResult(testing);
    % each row in training_result represents the 10 outputclasses
    % 0 at (ml)index i indiciates this input is NOT supposed to be the number (i-1)
    % 1 at (ml)index i indiciates this input is supposed to be the number (i-1)
    % credit:  http://stackoverflow.com/questions/6276252/how-to-efficiently-access-change-one-item-in-each-row-of-a-matrix

    %remove last row (results) from training
    training(:,end) = [];
    training = training./100;
    
    %remove last row (results) from training
    testing(:,end) = [];
    testing = testing./100;

    global k;
    global gMin;
    global gMax;
    global u;
    global d;
    
    u= u1;
    d= d1;

    k = 16;             % hidden units  (4, 8, 16)
    gamma1 = zeros(size(training, 2) + 1, k) - 0.0001;        % scaling-factor
    gamma2 = zeros(k + 1, 10) - 0.0001;        
    gMin = gammaMin;
    gMax = gammaMax;
    max_E = 1.0;        %train network until sum of squared errors is smaller than max_E
    E = max_E + 1;      %initialize E with a value greater than max_E

    W_1_overline = zeros(size(training, 2) + 1, k) - 0.5;
    W_2_overline = zeros(k + 1, 10) - 0.5;

    numOfIterations = 0;


    % apply backprop-algo for every training-row on network while sum of
    % squared errors is greater than max_E
    E_training = 1;
    E_testing = E_training-1;

    % apply backprop-algo for every training-row on network while sum of
    % squared errors is greater than max_E
    
    
    old_gamma1= gamma1;
    old_gamma2= gamma2;
    old_nabla1 = zeros(size(training, 2) + 1, k);
    old_nabla2= zeros(k + 1, 10);
    older_nabla1 = zeros(size(training, 2) + 1, k);
    older_nabla2= zeros(k + 1, 10);
    while E_training > E_testing
        numOfIterations = numOfIterations + 1;

        
        [E_training, W_batch_1, W_batch_2, gamma1, gamma2, nabla1, nabla2] = secondStream(training, training_result, W_1_overline, W_2_overline, gamma1, gamma2, old_gamma1, old_gamma2,old_nabla1, old_nabla2, older_nabla1, older_nabla2);
        
        W_1_overline = W_1_overline + W_batch_1;
        W_2_overline = W_2_overline + W_batch_2;
        
        older_nabla1 = old_nabla1;
        older_nabla2 = old_nabla2;
        old_nabla1 = nabla1;
        old_nabla2 = nabla2;
        old_gamma1 = gamma1;
        old_gamma2 = gamma2;
        [E_testing, ~, ~, ~, ~, ~, ~] = secondStream(testing, testing_result, W_1_overline, W_2_overline, gamma1, gamma2, old_gamma1, old_gamma2,old_nabla1, old_nabla2, older_nabla1, older_nabla2);
        
        %write out E
        E_testing;
        E_training;
    end

    E_training
    numOfIterations
end

function [training_result] = initialResult(training)
    % step 1: expand scalar output to binary vector
    training_result = zeros(size(training,1),10);
    idx = sub2ind(size(training_result), (1:size(training_result,1))', training(:,end)+1);
    training_result(idx) = 1;
end

function[E, W_batch_1, W_batch_2, deltaW_1, deltaW_2] = firstStream(training, training_result, W_1_overline, W_2_overline, old_delta1, old_delta2)
    global k;
    global gamma;
    global alpha;
    
    E=0;
    W_batch_1 =  zeros(size(training, 2) + 1, k);
    W_batch_2 = zeros(k + 1, 10);
    for i = 1:size(training,1)
        trainitem = i;      % select  of the trainingrows for training

        % feed forward
        o__hat = [training(trainitem,:), 1];
        net_o_1 =  o__hat*W_1_overline;
        o_1 = 1./(1+exp(-net_o_1)); % outputvector of hidden units (size k)

        o_1_hat = [o_1, 1];
        net_o_2 = o_1_hat*W_2_overline;
        o_2 = 1./(1+exp(-net_o_2)); % outputvector of output units (size 10)

        % backprop
        W_1 = W_1_overline(1:end-1,:);
        W_2 = W_2_overline(1:end-1,:);

        D_2 = diag(o_2.*(1-o_2));
        D_1 = diag(o_1.*(1-o_1));

        e = o_2'-training_result(trainitem,:)';

        %sum up sum of squared errors
        E = E + sum(e.^2/2);

        d_2 = D_2 * e;
        d_1 = D_1 * W_2 * d_2;

        deltaW_2 = transpose(-gamma * d_2 * o_1_hat) - alpha * old_delta2;
        deltaW_1 = transpose(-gamma * d_1 * o__hat) - alpha * old_delta1;

        W_batch_1 = W_batch_1 + deltaW_1;
        W_batch_2 = W_batch_2 + deltaW_2;



     end
end

function[E, W_batch_1, W_batch_2, deltaW_1, deltaW_2, nabla1, nabla2] = secondStream(training, training_result, W_1_overline, W_2_overline, gamma1, gamma2, gamma_old1, gamma_old2,old_nabla1,old_nabla2, older_nabla1,older_nabla2)
    global k;
    global gMin;
    global gMax;
    global u;
    global d;
    
    E=0;
    W_batch_1 =  zeros(size(training, 2) + 1, k);
    W_batch_2 = zeros(k + 1, 10);
    for i = 1:size(training,1)
        trainitem = i;      % select  of the trainingrows for training
        deltaW_1 = zeros(size(training, 2) + 1, k);
        deltaW_2 = zeros(k + 1, 10); 
        
        % feed forward
        o__hat = [training(trainitem,:), 1];
        net_o_1 =  o__hat*W_1_overline;
        o_1 = 1./(1+exp(-net_o_1)); % outputvector of hidden units (size k)

        o_1_hat = [o_1, 1];
        net_o_2 = o_1_hat*W_2_overline;
        o_2 = 1./(1+exp(-net_o_2)); % outputvector of output units (size 10)

        % backprop
        W_1 = W_1_overline(1:end-1,:);
        W_2 = W_2_overline(1:end-1,:);

        D_2 = diag(o_2.*(1-o_2));
        D_1 = diag(o_1.*(1-o_1));

        e = o_2'-training_result(trainitem,:)';

        %sum up sum of squared errors
        E = E + sum(e.^2/2);

        d_2 = D_2 * e;
        d_1 = D_1 * W_2 * d_2;
        
        nabla1 = (d_1 * o__hat)';
        nabla2 = (d_2 * o_1_hat)';
        [len1, dim1] = size(nabla1);
        [len2, dim2] = size(nabla2);
        for i1 = 1:len1
            for j = 1:dim1
                if(old_nabla1(i1,j) * older_nabla1(i1,j)>0)
                    gamma1(i1,j) = min(gamma_old1(i1,j)*u, gMax);
                else if (old_nabla1(i1,j) * older_nabla1(i1,j)>0)
                        gamma1(i1,j) = max(gamma_old1(i1,j)*d, gMin);
                    else
                        gamma1(i1,j) = gamma_old1(i1,j);
                    end
                end
                deltaW_1(i1,j) = transpose(-gamma1(i1,j) * sign(nabla1(i1,j))); 
            end
        end
        for i1 = 1:len2
            for j = 1:dim2
                if(old_nabla2(i1,j) * older_nabla2(i1,j)>0)
                    gamma2(i1,j) = min(gamma_old2(i1,j)*u, gMax);
                else if (old_nabla2(i1,j) * older_nabla2(i1,j)>0)
                        gamma2(i1,j) = max(gamma_old2(i1,j)*d, gMin);
                    else
                        gamma2(i1,j) = gamma_old2(i1,j);
                    end
                end
                deltaW_2(i1,j) = transpose(-gamma2(i1,j) * sign(nabla1(i1,j)));
            end
        end
        %deltaW_2 = transpose(-gamma1 * d_2 * o_1_hat); 
        %deltaW_1 = transpose(-gamma2 * d_1 * o__hat);

        W_batch_1 = W_batch_1 + deltaW_1;
        W_batch_2 = W_batch_2 + deltaW_2;



     end
end
