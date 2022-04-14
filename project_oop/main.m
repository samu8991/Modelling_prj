%clear all
%clc
Agent.clear()

%% Set paramters
n = 25; % - number of agents (sensors)
r = 4; %m - max distance for communication.
p = 100; % - number of cells
%rng(12); % set seed for repetition

showRoom;

%% Deploy agents
for i=1:n
   Agent;
end
agents = Agent.static.agents;
plotAgents(agents);

%% Calculate topology
Q = zeros(n);
for i = 1:n-1
    p1 = agents(i).position;
    for ii = i+1:n % For each couple
        p2 = agents(ii).position;
        if norm(p1-p2,2) <= r
            Q(i, ii) = 1;
            Q(ii, i) = 1;
        end
    end
end
clear p1 p2;
% Uniform weight ditribution
d = zeros(n,1);
for i=1:n % calculate degree
    d(i) = sum(Q(i,:));
end
maxDeg = max(d);
eps = rand * 1/maxDeg; % 0 < eps < 1/maxDeg;
Q = Q * eps;
for i=1:n
    Q(i,i) = 1-sum(Q(i,:));
end
% clear d maxDeg;
% Set Agents
for i=1:n
    agents(i).setQ(Q(i,:));
end

%% Dictionary setup
A = zeros(n,p);
for i=1:p
    t = cell2pos(i);
    for ii = 1:n
        A(ii, i) = agents(ii).measure(t, p);
    end
end

%% Runtime DIST
T_max = 10000;
%target = [5.7, 7.2];
%Measurements
y = zeros(n,1);
for i = 1:n
    y(i) = agents(i).measure(target);
end
%Feng's theorem
Ap = pinv(A);
B = (orth(A'))';
z = B * Ap * y;
for i = 1:n
    agents(i).feng(B, z);
end

f = waitbar(0, "Simulating");
for t=1:T_max
    if mod(t, 1000) == 0
        waitbar(t/T_max, f, sprintf("t = %d s", t) );
    end
    for a=1:n
       agents(a).DIST_step; 
    end
end
close(f);

%% Show result
x_avg = zeros(p,1);
for i=1:n
   x_avg = x_avg + agents(i).x; 
end
x_avg = x_avg/n;

pos2cell(target(1), target(2));

best = max(x_avg);
index = find(x_avg == best);
cell2pos(index, 10, true, true);
    