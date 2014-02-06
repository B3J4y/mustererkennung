function digits()
    global globdigits;
    globdigits = dlmread('digits-training.txt');
    aufgabe = 'a'
    [position] = writeDigits();
    pause;
    aufgabe = 'b'
    compression = 10
    nmf(compression);
    pause;
    compression = 20
    [W, H] = nmf(compression);
    pause;
    aufgabe = 'c'
    findPic(W, H, position);
end

function[] = findPic(W, H, position)
    global globdigits;
    figure();
    for i=1:10
        subplot(5,4,(1+2*(i-1)));
        globdigits((position(:,i)-16):(position(:,i)-1),:);
        image(uint8(globdigits((position(:,i)-16):(position(:,i)-1),:)*255));
        subplot(5,4,2*i);
        image(reshape(W*H(:,position(:,i)/17)*255,16,12));
    end
end

function[W, H] = nmf(compression)
    global globdigits;
    digits = globdigits;
    digits([17:17:length(digits)], :) = [];
    V = [];
    for i= 1:16:length(digits)
        V = [V, reshape(digits(i:i+15,:),[],1)];
    end
    W = rand(16*12, compression);
    H = rand(compression, length(digits)/16);
    Vt = W*H;
    E = 0;
    while(E<200)
        [len, dim] = size(digits);
            for a=1:compression
                for i=1:size(V,1)
                    W(i,a) = W(i,a)*sum(sum((V(i,:)./Vt(i,:).*H(a,:))));
                end
            end
            for a=1:compression
                deltaW = sum(W(:,a));
                for i=1:size(V,1)
                    W(i,a) = W(i,a)/deltaW;
                end
            end
            for a=1:compression
                for my=1:len/16
                    H(a,my) = H(a,my) * sum(sum((V(:,my)./Vt(:,my).*W(:,a))));
                end
            end

        Vt = W*H;
        %sum(sum(abs(V-Vt)))
        E=E+1
    end
    drawW(W);
end

function[] = drawW(W)
    [len, dim] = size(W);
    figure()
    for i=1:size(W,2)
        subplot(2, size(W,2)/2, i);
        image(reshape(W(:,i),16,12)*255)
    end
end

function[position] = writeDigits()
    global globdigits;
    digits = globdigits;
    singleDigits = unique(digits([17:17:length(digits)], :), 'rows');
    singleDigits = singleDigits(2:end, :);
    [~, n] = ismember(digits,singleDigits, 'rows');
    figure()
    position = [];
    for i= 1:10
        subplot(2,5,i);
        position = [position , find(n==i, 1)];
        digits((position(:,i)-16):(position(:,i)-1),:);
        image(uint8(digits((position(:,i)-16):(position(:,i)-1),:)*255));
    end
end