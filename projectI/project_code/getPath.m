function p = getPath(i)

switch i
    case 0
        p = [1 1; 2 2];
    case 1
        p = linspace(0, 10, 11)' .* ones(1,2);
    case 2
        p = linspace(0, 10, 21)' .* ones(1,2);
end
        
        