function localization = runOnce(target, seed, show_room, show_target, to_workspace)
arguments
    target = [5.7, 7.2];
    seed = 12
    show_room = false
    show_target = false
    to_workspace = false
end

Agent.clear() % necessary

%% Set paramters
n = 25; % - number of agents (sensors)
r = 4; %m - max distance for communication.
p = 100; % - number of cells

if seed >= 0
    rng(seed); % set seed for repetition
end

if show_room
    showRoom;
end

%% Deploy agents
for i=1:n
   Agent;
end
agents = Agent.static.agents;
if to_workspace
    assignin('base', 'agents', agents);
end
plotAgents(agents);

%% Calculate topology
Q = zeros(n);
for i = 1:n-1
    p1 = agents(i).position;
    for ii = i+1:n % For each couple (i-i couples excluded)
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
assignin('base', 'A', A);

%% Runtime DIST
T_max = 10000;
pos2cell(target(1), target(2), true);
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

if show_target
    pos2cell(target(1), target(2), true);
end

best = max(x_avg);
index = find(x_avg == best);
localization = cell2pos(index, 10, true, true);

figure(2);
stem(x_avg);
end