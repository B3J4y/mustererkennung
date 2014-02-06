function carEvalutaion()
    global training;
    training = reshape(textread('cardata_training.txt', '%s'),7,1000)';
    
    eliminationProcess(training)
end

function [struc] = eliminationProcess(table)
    counts = countMembers(table(:,end), unique(table(:,end)))
    entropie = determineEntropie(counts, length(table))
    max = determineMaximum(table(:,1:end-1), entropie)
    struc = eliminateRows(table, max)
end
function[result] = eliminateRows(table, max)
    structs = [];
    uniques = unique(table(:,max));
    for i=1:length(uniques)
        myTable= table(find(ismember(table(:,max), uniques(i,:))), :);
        test = unique(myTable(:,end));
        if(length(test) == 1)
            structs = [structs; struct(uniques(i), test(1))];
        else
            myTable(:,max) = [];
            under = eliminationProcess(myTable)
            structs = [structs; struct(uniques(i), under)];
        end
    end
    result = struct(structs)
end
function[counts] = countMembers(column, uniques)

    counts = [];
    for i=1:length(uniques)
        test = find(ismember(column, uniques(i,:)));
        counts = [counts; length(test)];
    end
end

function[entropie] = determineEntropie(unCount, all)
    res = (unCount./all).*log2(unCount./all);
    entropie = abs(sum(res));
end

function[maximum] = determineMaximum(table, entropie)
    [len, dim] = size(table);
    result = [];
    for i= 1: dim
        unCount= countMembers(table(:,i), unique(table(:,i)));
        result = [result ; determineGain(table, table(:,i), unCount, entropie)];
    end
    result
    maximum = find(result==max(result))
end

function[gain] = determineGain(table, row, unCount, entropie)
    uniques = unique(row);
    gain = entropie;
    for i= 1: length(uniques)
        trainUniqRow =table(find(ismember(row, uniques(i,:))),end); 
        wholeCount = countMembers(trainUniqRow, unique(trainUniqRow));
        E_S_t = determineEntropie(wholeCount,length(table(find(ismember(row, unique(row))),end)));
        gain = gain - (length(trainUniqRow)/length(row) *E_S_t);
    end
end