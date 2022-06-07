function p = pos2cell(x, y, show, l)
    arguments
        x(1,1) double {mustBePositive};
        y(1,1) double {mustBePositive};
        show(1,1) logical = false;
        l(1,1) double {mustBePositive} = 10;
    end
    xCell = floor(x);
    yCell = floor(y);
    p = xCell*l + yCell + 1;
    if show
        plot(x, y, 'd', "MarkerFaceColor", [0 0 170]/255, "MarkerEdgeColor", [214 125 0]/350, "MarkerSize", 10, "LineWidth", 1);
    end
end