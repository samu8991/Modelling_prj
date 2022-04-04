%% Modelling project
%clear 
close all
clc
%% Dati
n = 25;
l = 10;
p = l^2;
r = 8;
sigma = 0.5;
P_t = 25;

%% Deployment di tipo a
seed = 12;

R = [1 10];
s = rand(n,2)*range(R) + min(R); 
A = init_A(s,n,p,P_t,sigma);
mu = mutual_coherence(A);
ret = 0.5*(1+1/mu);
 
%% Creazione di Q
% Computation of d_in due to the fact that eps must be included between 0
% and 1/max(d_in). Done in this way there's duplicate code!
% Two sensors are connected if the distance between them is <= r
d_in = zeros(n,1);
for i = 1:n-1
    for j = i+1:n
        if norm(s(i,:)-s(j,:)) <= r
            d_in(i) = d_in(i)+1;
            d_in(j) = d_in(j)+1;
        end
    end 
end
R = [0,1/max(d_in)];
eps = rand(1,1)*range(R)+ min(R);
Q = init_Q(s,r,n,eps);
G=digraph(Q);
%plot(G)
%% Deployment di tipo b
% verified = false;
% vertice_griglia_5_by_5 = zeros(1,2);
% while ~verified
%     vertice_griglia_5_by_5 = randi([1,10],[1,2]);
%     if vertice_griglia_5_by_5(1) + 5 <= 10 && vertice_griglia_5_by_5(2) + 5 <= 10
%         verified = true;
%     end
% end
% s = zeros(n,2);
% 
% s(1,2) = vertice_griglia_5_by_5(2);
% s(1,1) = vertice_griglia_5_by_5(1);
% for i = 1:n-1
%    if(mod(i,5) == 0)
%        s(i+1,1) = s(i,1)+1;
%        s(i+1,2) = vertice_griglia_5_by_5(2);
%    else 
%        s(i+1,1) = s(i,1);
%        s(i+1,2) = s(i,2)+1;
%    end
% 
% end
%% Orthogonalization of A
global Ap tau lambda B
lambda = 1e-4;
tau = 0.7;
Ap = pinv(A);
B = (orth(A'))';
mu = mutual_coherence(B);
ret = 0.5*(1+1/mu);
%% Runtime
T_max = 10000;
x = zeros(p,T_max);
target = [5.7, 7.2];
y = zeros(n,1);
for i = 1:n
    d = norm(target-s(i,:));
    y(i) = RSS(d,P_t,sigma);
end
z = z_feng(y);

x(:,1) = zeros(p,1);
for t = 2:T_max
    x(:,t) = IST_step(x(:,t-1),z,B);
end

% best value
max_val = max(x(:,end));
index = find(x(:, end) == max_val);
x_i = floor(index / 10) + .5;
y_i = mod(index, 10) + .5;
% plot(x_i, y_i, 's', "color", max_val * [1 0 0], "markersize", 8, 'markerfacecolor', max_val * [1 0 0]); 

return 

%% Plot
%stem(x(:,T_max))

figure
grid on;
hold on;
xlim([1 10])
ylim([1 10])

%markers
for i=1:9
    for     j=1:9
        plot(i + .5, j + .5, 'o', "color",'#FF00FF', "markersize", 10);
    end
end

% gt .5
for i=1:length(x(:,T_max))
   if abs(x(i, T_max)) >= 0.5
        x_i = floor(i / 10) + .5
        y_i = mod(i,10) + .5
        plot(x_i, y_i, 's', "color", x(i) * [0 1 0], "markersize", 8, 'markerfacecolor', x(i) * [0 1 0]); 
   end
end

% Real target
plot(target(1), target(2), 'db', "markersize", 8, 'markerfacecolor', 'b'); 
%% Functions
function ret = RSS(d,P_t,sigma)
    eta = randn(1)*sigma;
    if d > 8
        ret = P_t - 58.5 - 33 *log10(d)+ eta;
    else
        ret = P_t - 40.2 - 20*log10(d)+ eta;
    end
end

function A = init_A(s,n,p,P_t,sigma)
    A = zeros(n,p);
    l = 10;

    for i = 1:p % Per ogni cella
        t = [ floor(i/l), mod(i,l) ]; % posiziono il target
        for ii = 1:n % per ogni sensore
            d = norm(s(ii,:)-t(1,:)); % calcolo la distanza dal sensore del target
            A(ii, i) = RSS(d, P_t, sigma); % e la RSS di quel sensore per quella posizione del target
        end
    end
end

function [Q,d_in] = init_Q(s,r,n,eps)
    d_in = zeros(n,1);
    Q = eye(n);
    for i = 1:n-1
        for j = i+1:n
            if norm(s(i,:)-s(j,:)) <= r
                d_in(i) = d_in(i)+1;
                d_in(j) = d_in(j)+1;
                if i ~= j
                    Q(i,j) = eps;
                    Q(j,i) = eps;
                else
                    Q(i,j) = 1-eps*d_in(i);
                end
            end
        end
    end
end
function z = z_feng(y)
    global B Ap
    z = B*Ap*y;
end
function r = IST_step(x_0,y,A)
    global tau lambda
    r = x_0 + tau*A'*(y-A*x_0);
    assert(length(r) == 100);
    for i = 1:length(r)
        if(abs(r(i)) <= lambda)
            r(i) = 0;
        else
            r(i) = r(i) - sign(r(i))*lambda; 
        end
    end
end