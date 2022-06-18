function res = cell2pos(p, l, show, offset)
    arguments
        p(1,1) double {mustBePositive};
        l(1,1) double {mustBePositive} = 10;
        show(1,1) logical = false;
        offset(2,1) double {mustBeInRange(offset, 0, 1)} = [0.5 0.5]; % Offset for the position inside a single cell
    end
    p = p-1;
    x = floor(p/l);
    y = mod(p,l);
    
    res = [x + offset(1), y + offset(2)];
    r = [x y 1 1];
    if show
         rectangle('Position', r, 'FaceColor',"g");
         %plot(x, y, 'o', "MarkerEdgeColor", [214 125 0]/350, "MarkerSize", 20);
         plot(res(1), res(2), 's', "color", 0.7 * [0 1 0], "markersize", 8, 'markerfacecolor', 0.7* [0 1 0]);    
    end
end