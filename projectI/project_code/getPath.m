function p = getPath(i)
% When called with i=-1, it returns the numbers of path available (withouth
% considering the dummy path 0
% Otherwise, it returns the corresponding path
switch i
    case -1
        p = 4;
    case 0 %% Dummy path
        p = [1 1; 2 2];
    case 1
        p = linspace(0, 10, 11)' .* ones(1,2);
    case 2
        p = linspace(0, 10, 21)' .* ones(1,2);
    case 3
        x = linspace(0, 2*pi, 30);
        px = 4*sin(x) + 5;
        py = 4*cos(x) + 5;
        p = [px' py'];
    case 4
        x = linspace(0, 2*pi, 60);
        px = 4*sin(x) + 5;
        py = 4*cos(x) + 5;
        p = [px' py'];
end
        
        