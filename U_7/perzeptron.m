function perzeptron
    global grades
    global plotg
    plotg = 0;
    grades = dlmread('klausur.txt');
    grades = [grades zeros(length(grades), 1)+1];
    global t
    t=0;
    clf;
    %randomisiertert Vektor
    randnums = [rand(1,2)];
    global w
    w = [[0 0]; randnums/norm(randnums)]
    hold on
    %Plot Daten
    plot1 = plot(grades(find(grades(:,2)==0), 1 ), grades(find(grades(:,2)==0), 3), 'ro');
    plot2 = plot(grades(find(grades(:,2)==1), 1 ), grades(find(grades(:,2)==1), 3), 'go');
    %Plot w und Orthogonale
    plotw = [plot(w(:,1), w(:,2), '-bo') plot(w(:,2), -w(:,1 ), '--bo') plot(fliplr(-w(:,2)), w(:,1 ), '--bo')] ;
    set(plotw,'Visible', 'off');
    %adjusting
    while t<15
        s = t;
        adj();
        plotw = [plot(w(:,1), w(:,2), '-bo') plot(w(:,2), -w(:,1 ), '--bo') plot(fliplr(-w(:,2)), w(:,1 ), '--bo')] ;
        if s ~= t
            pause;
        end
        if t < 15 
            set(plotw,'Visible', 'off');
        end
    end
    axis equal;
    
    
    
    %hold off
end

function adj
    global grades
    global w
    global t
    global plotg
    plotg
    if plotg ~= 0
        set(plotg,'Visible', 'off');
    end
    randgrade = grades(floor(rand(1)*length(grades))+1, :);
    plotg = plot(randgrade(:,1), randgrade(:,3), '*');
    dot(randgrade(1, [1 3]), w(2,:))
    if randgrade(1,2)
        if dot(randgrade(1, [1 3]), w(2,:)) > 0
            return
        else 
            w(2, :) = randgrade(1, [1 3]) + w(2,:);
            t = t+1;
        end
    else
        if dot(randgrade(1, [1 3]), w(2,:)) <= 0
            return
        else 
            w(2, :) =  w(2,:) - randgrade(1, [1 3]) ;
            t = t + 1;
        end
    end
end