function plotPath(p, color)
arguments
    p
    color = 'b'
end

% We assume to have as many rows as points in the path and 2 columns, one
% for x and the other for y

l = size(p);
for i=1:l(1)-1
    %d = p(i+1,:) - p(i,:);
    %quiver(p(i,1), p(i,2), d(1), d(2), 'Color', color, 'AutoScale', 'off', 'MaxHeadSize', .5);
    arrow(p(i,:), p(i+1,:), 'Color', color, 'TipAngle', 10, 'BaseAngle', 30, 'Width', 0.5);
end

end