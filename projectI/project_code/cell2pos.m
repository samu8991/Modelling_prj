function r = cell2pos(p, l, show, center)
    arguments
        p(1,1) double {mustBePositive};
        l(1,1) double {mustBePositive} = 10;
        show(1,1) logical = false;
        center(1,1) logical = true;
    end
    p = p-1;
    x = floor(p/l);
    y = mod(p,l);
    
    r = [x y 1 1];
    if show
         rectangle('Position', r, 'FaceColor',"g");
         if center
            x = x+.5;
            y = y+.5;
            %plot(x, y, 'o', "MarkerEdgeColor", [214 125 0]/350, "MarkerSize", 20);
            plot(x, y, 's', "color", 0.7 * [0 1 0], "markersize", 8, 'markerfacecolor', 0.7* [0 1 0]);    
         end
    end
    
    r = r(1:2)+.5;
end