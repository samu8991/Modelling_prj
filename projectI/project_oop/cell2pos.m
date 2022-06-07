function r = cell2pos(p, l, center, show)
    arguments
        p(1,1) double {mustBePositive};
        l(1,1) double {mustBePositive} = 10;
        center(1,1) logical = true;
        show(1,1) logical = false;
    end
    x = floor(p/l);
    y = mod(p,l)-1;
    if center 
        x = x+.5;
        y = y+.5;
        r = [x y];
        if show
            plot(x, y, 'o', "MarkerEdgeColor", [214 125 0]/350, "MarkerSize", 20);
        end
    else
        r = [x y 1 1];
        if show
            rectangle('Position', r, 'FaceColor',"r");
        end
    end
end