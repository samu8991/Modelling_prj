function plotAgents(agents, showIDs, showCircle, n)
    arguments
        agents
        showIDs logical = false;
        showCircle logical = false;
        n = 1; %figure
    end
    hold on
    grid on
    axis('square');
    xlim([0 10]);
    ylim([0 10]);
    l = 0;
    for el=agents
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
        c = el.id/Agent.static.n * r;
        if showIDs
            text(el.position(1), el.position(2), num2str(el.id), 'Color', c);
        else
            plot(el.position(1), el.position(2), '*');
        end
        if showCircle
            r = [el.position(1)-4, el.position(2)-4, 8,8 ];
            rectangle('Position', r, 'Curvature', [1,1], 'EdgeColor', c, "LineWidth", 0.1, "LineStyle", "-.");
        end
    end
end