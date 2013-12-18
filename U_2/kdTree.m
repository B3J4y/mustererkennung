function kdTree()
    global kdt;
    
    global point1;
    global bestpoint1;
    global nodeCount;
    
    nodeCount = 0;
    point1 = [0.2, 0.3];
    point2 = [0.5, 0.5];
    point3 = [0.9, 0.3];
    points = dlmread('Matlab/U_2/points.txt');
    vars = var(points);
    axis = find(vars==max(vars));
    med = median(points(:,axis))
    left = node(points(points(:,2)<med, :));
    right = node(points(points(:,2)>med, :));
    kdt = struct('med',med, 'axis', axis, 'left', left, 'right', right);
    
    search(kdt, point1);
    nearest = [bestpoint1, nodeCount];
    nodeCount = 0;
    search(kdt, point2);
    nearest = [nearest; bestpoint1, nodeCount];
    nodeCount = 0;
    search(kdt, point3);
    nearest = [nearest; bestpoint1, nodeCount];
end

function[myNodes] = node(inpNode)
    if(size(inpNode, 1) <= 1)
       myNodes=inpNode; 
    else
        vars = var(inpNode);
        axis = find(vars==max(vars));
        med = median(inpNode(:,axis));
        left = node(inpNode(inpNode(:,axis)<med, :));
        right = node(inpNode(inpNode(:,axis)>med, :));
        
        myNodes = struct('med',med, 'axis', axis, 'left', left, 'right', right);
        
    end
    

end

function [] = search(inpNode, point)
    global bestpoint1;
    global nodeCount;
    
    nodeCount = nodeCount + 1;
    if(inpNode.med > point(inpNode.axis))
        if(~isstruct(inpNode.left))
          if(~isempty(bestpoint1))
              dist1 = sqrt(sum((bestpoint1 - point).^2));
              dist2 = sqrt(sum((inpNode.left - point).^2));
              if(dist1 > dist2)
                bestpoint1 = inpNode.left;
              end
          else 
              bestpoint1 = inpNode.left;
          end
          return
        end
        search(inpNode.left, point);
        better(inpNode, point, inpNode.right);
    else
        if(~isstruct(inpNode.right))
          if(~isempty(bestpoint1))
              dist1 = sqrt(sum((bestpoint1 - point).^2));
              dist2 = sqrt(sum((inpNode.right - point).^2));
              if(dist1 > dist2)
                bestpoint1 = inpNode.right;
              end
          else 
              bestpoint1 = inpNode.right;
          end
          return
        end
        search(inpNode.right, point);
        better(inpNode, point, inpNode.left);
    end;
end

function[] = better(inpNode, point, direction)
    global bestpoint1;

    dist = sqrt(sum((bestpoint1 - point).^2));
    if(inpNode.axis==1)
        dist2 =sqrt((inpNode.med-bestpoint1(1)).^2);
    else
        dist2 = sqrt((inpNode.med-bestpoint1(2)).^2);
    end
    if(dist > dist2)
        search(direction, point);
    else 
        return
    end 
end