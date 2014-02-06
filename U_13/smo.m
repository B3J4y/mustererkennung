function smo()
    global training;
    training = dlmread('points-training.txt');
    
    global b;
    global alpha;
    
    alpha = zeros(200,1);
    b = 0;
    C=1.5;
    tolerance = 0.5;
    boolGes = 0;
    i=0;
    while i<101
        i= i + 1;
        iP = 0;
        iQ = 0;
        for p= 1: 200
            for q = 1:200
                exp1 = f_a(training(p,1:2)) - training(p,3) + tolerance;
                exp2 = f_a(training(q,1:2)) - training(q,3) - tolerance;
                bool1 = exp1 < exp2;
                bool2 = (alpha(p,1) < C) && (training(p,3) == 1);
                bool3 = (alpha(p,1) > 0) && (training(p,3) == -1);
                bool4 = (alpha(q,1) < C) && (training(q,3) == -1);
                bool5 = (alpha(q,1) > 0) && (training(q,3) == 1);
                boolGes = bool1 && (bool2 || bool3) && (bool4 || bool5);
                if(boolGes == 1)
                    iP = p;
                    iQ = q;
                    break

                end
            end
            if(boolGes == 1)
                break
            end
        end
        if(iP == 0)
            break
        end
        exp1 = (f_a(training(iQ,1:2)) - training(iQ,3)) - (f_a(training(iP,1:2)) - training(iP,3));
        exp2 = (scal(training(iP, :), training(iP,:))) - 2*(scal(training(iP, :), training(iQ,:))) + (scal(training(iQ, :), training(iQ,:)));
        n = exp1 / exp2;

        bool1 = ((alpha(iP,:) + training(iP,3)*n)>=0) && (alpha(iQ,:) - training(iQ,3)*n)<=C;
        while ~ bool1
            n = n-0.1;
            bool1 = ((alpha(iP,:) + training(iP,3)*n)>=0) && (alpha(iQ,:) - training(iQ,3)*n)<=C;
        end

        alpha(iP,:) = (alpha(iP,:) + training(iP,3)*n);
        alpha(iQ,:) = (alpha(iQ,:) - training(iQ,3)*n);
    end
    alpha
end

function [sum] = scal(x, y)
    sum = (x(:,1)*y(:,1) + x(:,2)*y(:,2));
end

function [ret] =  f_a(x)
    global b;
    global alpha;
    global training;
    
    ret = b+ sum(training(:,3).*alpha.*(x(:,1)*training(:,1) + x(:,2)*training(:,2)));
end