function backprog
    backprogA();
end

function backprogA
    clc;
    clear;

    data = dlmread('pendigits-training.txt');
    training = data(1:60,:);
    testing = data(61:90, :);
    
    global k;
    global gamma;
    k = 16;              % hidden units  (4, 8, 16)
    gamma = 1;        % scaling-factor
    max_E = 1;        %train network until sum of squared errors is smaller than max_E
    E = 100;
    % training(101:end,:) = [];                % reduce trainingsize in development
    % testing(10:end,:) = [];
    [nr, ~] = size(training);

    % step 1: expand scalar output to binary vector
    training_result = zeros(size(training,1),10);
    idx = sub2ind(size(training_result), (1:size(training_result,1))', training(:,end)+1);
    training_result(idx) = 1;
    % each row in training_result represents the 10 outputclasses
    % 0 at (ml)index i indiciates this input is NOT supposed to be the number (i-1)
    % 1 at (ml)index i indiciates this input is supposed to be the number (i-1)
    % credit:  http://stackoverflow.com/questions/6276252/how-to-efficiently-access-change-one-item-in-each-row-of-a-matrix

    %remove last row (results) from training
    training(:,end) = [];

    % step 2: normalize inputdata to [0,1] in each category/column
    maxt = max([training; testing(:,1:end-1)]);
    mint = min([training; testing(:,1:end-1)]);
    training = (training - (repmat(mint,nr,1)))./repmat(maxt,nr,1);
    
    E_train = max_E;        %initialize E with a value greater than max_E
    E_test = max_E+1;
    E = 100;
    W_1_overline = zeros(size(training,2)+1,k)-0.5;
    W_2_overline = zeros(k+1, 10)-0.5;
    while E> 10
        % apply backprop-algo for every training-row on network while sum of
        % squared errors is greater than max_E
        E=0;

        % feed forward train
        o__hat = [training, ones(length(training), 1)];
        net_o_1 =  o__hat*W_1_overline;
        o_1 = 1./(1+exp(-net_o_1)); % outputvector of hidden units (size k)

        o_1_hat = [o_1, ones(length(training), 1)];
        net_o_2 = o_1_hat*W_2_overline;
        o_2 = 1./(1+exp(-net_o_2)); % outputvector of output units (size 10)



        E = sum((sum(1/2 * (o_2'-training_result').^2)))
        e = sum(o_2-training_result);
        for trainitem = 1:size(training,1)
            % backprop
            W_1 = W_1_overline(1:end-1,:);
            W_2 = W_2_overline(1:end-1,:);

            D_2 = diag(o_2(trainitem, :).*(1-o_2(trainitem, :)));
            D_1 = diag(o_1(trainitem, :).*(1-o_1(trainitem,:)));

            d_2 = D_2 * e';
            d_1 = D_1 * W_2 * d_2;

            deltaW_2 = transpose(-gamma * d_2 * o_1_hat(trainitem,:));
            deltaW_1 = transpose(-gamma * d_1 * o__hat(trainitem,:));

            W_1_overline = W_1_overline + deltaW_1;
            W_2_overline = W_2_overline + deltaW_2;



        end
        %write out E
        E
    end
end

function [E, W_1_overline, W_2_overline] = trainData(training, testing, w1, w2)
    global k;
    global gamma;
    

    
    

    while E > 10


        %iterationen
    end
end