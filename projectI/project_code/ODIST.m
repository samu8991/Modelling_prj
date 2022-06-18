function [estimatePath, succ_rate, distance] = ODIST(T_max, stopThreshold, targetPath, showPlots)
arguments
    T_max {mustBePositive} % maximum time for each iteration of DIST
    stopThreshold = 1e-4; % early stopping threshold
    targetPath = 0 % an integer or a matrix containing the path of the target. Each row contains a position (x,y)
    showPlots = true;
end
%% Settings
n = 25;
p = 100;

if sum(size(targetPath)) == 2
    targetPath = getPath(targetPath);
end
estimatePath = zeros(size(targetPath));
size_tp = size(targetPath);
pathLength = size_tp(1);


first_index = pos2cell(targetPath(1,1), targetPath(1,2));
x0 = zeros(p,1);
x0(first_index) = 1;

%% Metrics settings
distance = zeros(pathLength, 1);
n_successful = 0;

%% Runtime
for i = 1:length(targetPath)
    target = targetPath(i,:); % move it though the diagonal
    fprintf("Positioning target in (%6.3f, %6.3f)", target(1), target(2));
    
    [x, ~, ~, ~, ~, s, ~] = DIST(T_max, stopThreshold, x0, target, 1, false, 0, 'm', 2);
    x0 = x';
    
    [~, b] = max(x);
    
    if b == pos2cell(target(1), target(2))
       n_successful = n_successful + 1; 
    end
    
    xEst= cell2pos(b);
    estimatePath(i,:) = xEst;
    fprintf(" - best estimate: (%6.3f, %6.3f)\n", xEst(1), xEst(2));
    
    % metrics
    distance(i) = norm(target-xEst, 2);
end

succ_rate = n_successful / i;

%% Plots
if showPlots
    showRoom;
    plotPath(targetPath);
    plotPath(estimatePath, 'r');
    plotAgents(s,n);
    generateLegend(2, ["-r", "-b"], ["Real path", "Estimated path"]);
end

end