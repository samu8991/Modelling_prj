clear all
close all
clc

%% Experiment a
% which is the rate of success? When the algorithm is not successful, how
% far is the estimated target?

T_max = 1e5;
stopThreshold = 1e-6;
x0 = 0; % always zero initial state 
target = 0; % Automatic target positioning
showPlots = false; % we don't need the plot for each iteration
seed = 0; % for repeatability of random deployment and target positioning
% NOTE: given the seed, the automatic positioning of the sensors and the
% target will result the same for both IST and DIST algorithms.
% The seed will change with the index of the experiment

n = 25;
p = 100;


%% Localization problem (DIST) %%
% We are going to compute the success rate of the DIST algorithm
n_experiments = 100;

% DIST measures vectors
x = zeros(n_experiments, p);
target = zeros(n_experiments,2); % DIST return a target with size[2,1]
successful = 0;
unsucc = 0;
unsucc_dist = zeros(n_experiments, 1);

for k=[2 1]
    if k == 2 % grid deployment, type A
        first = 1;
        last = n_experiments/2;
    else % random deployment, type B
        first = n_experiments/2 + 1 ;
        last = n_experiments;
    end
    for i = first:last
        fprintf("Cycle %d - ", i);
        seed=i;
        [x(i,:), target(i,:), ~, ~, ~, ~, ~] = DIST(T_max, stopThreshold, x0, 0, k, showPlots, seed);
        [~, xBest_index] = max(x(i,:));
        
        target_index = pos2cell(target(i,1), target(i,2));
        if target_index == xBest_index
            successful = successful + 1;
            fprintf("Successful reference point estimation!\n")
        else
           xpos = cell2pos(xBest_index);
           d = norm(xpos-target(i,:),2);
           unsucc = unsucc + 1;
           unsucc_dist(unsucc) = d;
           fprintf("Unsuccessful! The distance is: %f\n", d);
           fprintf("Target position (%f,%f) - estimated position (%f,%f)\n",target(i,1), target(i,2),xpos(1),xpos(2))
        end
    end
end

successful_rate = successful / n_experiments;
average_dist = mean(unsucc_dist);
variance_dist = var(unsucc_dist);
fprintf("The successfull rate is: %f\n", successful_rate);
fprintf("The average distance when failing is: %f with a variance of %f", average_dist, variance_dist);

%% Tracking problem (ODIST)
last_path = getPath(-1);

for i = 1:last_path
    tp = getPath(i);
    
    [estimatePathRD, n_succRD, distRD] = ODIST(T_max, stopThreshold, tp, 1,false); % ODIST with random deployment
    [estimatePathGD, n_succGD, distGD] = ODIST(T_max, stopThreshold, tp, 2,false); % ODIST with grid deployment
    
    % ODIST data with random deplyment for path i
    dataRD(i).estimatePathRD=estimatePathRD;
    dataRD(i).n_succRD=n_succRD;
    dataRD(i).distRD=distRD;
    dataRD(i).cumulativeDistanceRD=sum(dataRD(i).distRD)
    dataRD(i).succRatioRD=dataRD(i).n_succRD/length(dataRD(i).estimatePathRD)

    %ODIST data with Grid deployment for path i
    dataGD(i).estimatePathGD=estimatePathGD;
    dataGD(i).n_succGD=n_succGD;
    dataGD(i).distGD=distGD;
    dataGD(i).cumulativeDistanceGD=sum(dataGD(i).distGD)
    dataGD(i).succRatioGD=dataGD(i).n_succGD/length(dataGD(i).estimatePathGD)
   
end


%% Result plot (DIST) %%
x_a=linspace(0,100,100);
figure()
plot(x_a,unsucc_dist,'b-*')
xlabel("n_{example}")
ylabel("Distance")
hold on
plot(x_a,average_dist*ones(n_experiments,1),'k')
%%
n_range=10
ranges= zeros(n_range,2);
e_min= min(unsucc_dist);
e_max= max(unsucc_dist);
range_= (e_max-e_min)/n_range;
errors_in_range=zeros(n_range,1);
for i=1:n_range
    if i==1
        start=0;
    end
    ranges(i,1)=start;
    ranges(i,2)=start+range_;
    start=start+range_;
end

for j=1:n_experiments
    for i=1:n_range
        if (unsucc_dist(j)>=e_min+ranges(i,1) && unsucc_dist(j)<e_min+ranges(i,2))
            errors_in_range(i)=errors_in_range(i)+1;
        end
        if (unsucc_dist(j)==e_min+ranges(1,2))
            errors_in_range(i)=errors_in_range(i)+1;
        end
    end
end
errors_in_range=errors_in_range./n_experiments
labels = {}
for i = 1:length(ranges)
   labels{i} = convertStringsToChars(sprintf("%.2f to %.2f", ranges(i,1), ranges(i,2)));
end
lab = categorical(labels);

bar(lab, errors_in_range)

%% Result plot (ODIST)%%

% plot deployment
rng(0)
for i= [1,2]
    showRoom;
    s=deploy(25,10,4,i);
    plotAgents(s)
    if i==1
        title('Random deployment')
    else
        title('Grid deployment')
    end
end

for i = 1 : getPath(-1)
    targetPath=getPath(i);
    showRoom;
    plotPath(targetPath,'g'),hold on
    plotPath(dataGD(i).estimatePathGD,'r'),hold on
    plotPath(dataRD(i).estimatePathRD,'b'),hold on
    generateLegend(3,["-g","-r","-b"],["Target path","Grid deployment" ,"Random deployment"])
    title("Tracking path ",i)
end

%% 
figure
for i = 1:getPath(-1)
    subplot(2,2,i)
    xshow=linspace(0,length(getPath(i)),length(getPath(i)));
    plot(xshow,dataGD(i).distGD,'r-*','DisplayName', 'Grid deployment')
    hold on
    plot(xshow,dataRD(i).distRD,'b-d','DisplayName', 'Random deployment')
    grid on
    xlabel(sprintf("time\npath %d",i))
    ylabel("Distance")
    legend
end



%% plot comulative

figure
for i =1:getPath(-1)
    pt= getPath(i)
    y_showGD=zeros(length(pt),1);
    y_showRD=zeros(length(pt),1);
    x_show=linspace(1,length(pt),length(pt))
    y_showGD=cumsum(dataGD(i).distGD)
    y_showRD=cumsum(dataRD(i).distRD)
    
    subplot(2,2,i)
    
    grid on
    plot(x_show,y_showRD,'b-d','DisplayName', 'Random deployment'); hold on
    plot(x_show,y_showGD,'r-*','DisplayName', 'Grid deployment'); hold on
    grid on
    ylabel("Comulative distance")
    xlabel(sprintf("time\npath %d",i))
    legend
end