function Loesung01a
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
    k = 16;             % hidden units  (4, 8, 16)
    gamma = 1.0;        % scaling-factor
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

    while E_training > E_testing
        numOfIterations = numOfIterations + 1;
        [E_testing, ~, ~] = firstStream(testing, testing_result, W_1_overline, W_2_overline);
        [E_training, W_batch_1, W_batch_2] = firstStream(training, training_result, W_1_overline, W_2_overline);
        W_1_overline = W_1_overline + W_batch_1;
        W_2_overline = W_2_overline + W_batch_2;  
        %write out E
        E_training
        E_testing
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

function[E, W_batch_1, W_batch_2] = firstStream(training, training_result, W_1_overline, W_2_overline )
    global k;
    global gamma;
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

        deltaW_2 = transpose(-gamma * d_2 * o_1_hat);
        deltaW_1 = transpose(-gamma * d_1 * o__hat);

        W_batch_1 = W_batch_1 + deltaW_1;
        W_batch_2 = W_batch_2 + deltaW_2;



     end
end

