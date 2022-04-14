function showRoom(l, n)
    arguments
       l double = 10;
       n double {mustBePositive} = 1;
    end
    figure(n)
    clf
    hold on
    xlim([0, 10])
    ylim([0 10])
    grid on
    p = 1;
    for i=0:l-1
        for ii=0:l-1
            text(i+.3, ii+.5, num2str(p));
            p = p + 1;
        end
    end
end