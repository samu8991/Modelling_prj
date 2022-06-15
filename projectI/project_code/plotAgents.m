function plotAgents(s, n, radius, randomColors, showCircle, showIDs, figN)
    arguments
        s 
        n = 25
        radius = 4
        randomColors logical = false;
        showCircle logical = false;
        showIDs logical = false;
        figN = 1; %figure
    end
    hold on
    grid on
    axis('square');
    xlim([0 10]);
    ylim([0 10]);
    l = 0;
    for i=1:n
        switch l
            case 0
                r = [0 0 1];
                l = 1;
            case 1
                r = [0 1 0];
                l = 2;
            case 2
                r = [1 0 0];
                l = 0;
        end 
        c = i/n * r;
        if showIDs
            text(s(i,1), s(i,2), num2str(i), 'Color', c);
        else
            if(randomColors)
                plot(s(i,1), s(i,2), '*', "MarkerSize",10);
            else
                plot(s(i,1), s(i,2), 'r*', "MarkerSize",10);
            end
        end
        if showCircle
            rect = [s(i,1)-radius, s(i,2)-radius, 2*radius, 2*radius];
            rectangle('Position', rect, 'Curvature', [1,1], 'EdgeColor', c, "LineWidth", 0.1, "LineStyle", "-.");
        end
    end
end