function showRoom(l, n, showMarkers)
    arguments
       l double = 10;
       n double {mustBePositive} = 1;
       showMarkers logical = false;
    end
    figure
    clf
    hold on
    xlim([0, 10])
    ylim([0 10])
    grid on
    p = 1;
    for i=0:l-1
        for ii=0:l-1
            text(i+.3, ii+.5, num2str(p));
            if showMarkers
                plot(i+.5, ii+.5, 'o', "color",'#FF00FF', "markersize", 15);
            end
            p = p + 1;
        end
    end
end