clc;
clear;

training = dlmread('pendigits-training.txt');
testing = dlmread('pendigits-testing.txt');

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


k = 16;              % hidden units  (4, 8, 16)
gamma = 0.6;        % scaling-factor
max_E = 300;        %train network until sum of squared errors is smaller than max_E
E = max_E+1;        %initialize E with a value greater than max_E

W_1_overline = rand(size(training,2)+1,k);
W_2_overline = rand(k+1, 10);


% apply backprop-algo for every training-row on network while sum of
% squared errors is greater than max_E

while E > max_E
    E=0;
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
        
        d_2 = D_2 * e;
        d_1 = D_1 * W_2 * d_2;

        deltaW_2 = transpose(-gamma * d_2 * o_1_hat);
        deltaW_1 = transpose(-gamma * d_1 * o__hat);

        W_1_overline = W_1_overline + deltaW_1;
        W_2_overline = W_2_overline + deltaW_2;

        %sum up sum of squared errors
        E = E + sum(e.^2/2);

    end
    %write out E
    E
end

%write out weights for debug
%W_1_overline
%W_2_overline

% cut off result digit, and normalize data similar to trainingdata
expectation = testing(:,end);
testing(:,end) = [];
% maxt(end) = [];
% mint(end) = [];
[nr, ~] = size(testing);
testing = (testing - (repmat(mint,nr,1)))./repmat(maxt,nr,1);

% compute confusionmatrix based on training 
confusion = zeros(10,10);
for item = 1:size(testing, 1)

    input = testing(item,:);
    calculus = [input 1]*W_1_overline;
    calculus = 1./(1+exp(-calculus)); % outputvector of output units (size k)

    calculus = [calculus 1]*W_2_overline;
    calculus = 1./(1+exp(-calculus)); % outputvector of output units (size k)
    
    %calculus;
    [val,key] = sort(calculus,'descend');
    % struct('actual_number', expectation(item), 'likelyhood', key-1);

    confusion(expectation(item)+1,key(1)) = confusion(expectation(item)+1,key(1)) + 1; 
end

%write out confusion matrix and regocnition rate
confusion
recognition = sum(diag(confusion))/size(testing,1)
