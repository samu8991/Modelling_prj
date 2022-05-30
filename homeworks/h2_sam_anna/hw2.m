clc
clear
close all

N = 50; %numero di misurazioni
dim_theta = 5;
data = load("data_exam_1A.mat");
in = data.input_data;
out = data.output_data;

%% Obj function

objPoly.typeCone = 1;
objPoly.dimVar = dim_theta + N;
objPoly.degree = 1;
objPoly.noTerms = 1;
objPoly.supports = zeros(1,N+dim_theta);% noTerms * dimVar
objPoly.supports(3) = 1;
objPoly.coef = 1;
ineqPolySys = cell(1,N-2);

%% Constraints
for k = 3:N
    ineqPolySys{k-2}.typeCone = 1;
    
    ineqPolySys{k-2}.dimVar = dim_theta + N;
    
    ineqPolySys{k-2}.degree = 2;
    
    ineqPolySys{k-2}.noTerms = 9;
    
    ineqPolySys{k-2}.supports = zeros(9,dim_theta + N);
    
    ineqPolySys{k-2}.supports(2,k+N) = 1;
    ineqPolySys{k-2}.supports(3,1) = 1;
    ineqPolySys{k-2}.supports(4,1) = 1;
    ineqPolySys{k-2}.supports(4,k-1+N) = 1;
    ineqPolySys{k-2}.supports(5,2) = 1;
    ineqPolySys{k-2}.supports(6,2) = 1;
    ineqPolySys{k-2}.supports(4,k-2+N) = 1;
    ineqPolySys{k-2}.supports(7,3) = 1;
    ineqPolySys{k-2}.supports(8,4) = 1;
    ineqPolySys{k-2}.supports(9,5) = 1;

    ineqPolySys{k-2}.coef = [out(k); -1; out(k-1); 
                             -1;out(k-2); -1; -in(k);...
                             -in(k-1);-in(k-2)];
end
lbd = [-1e10,-1e10,-1e10,-1e10,-1e10,-1*ones(1,N)];
ubd = [1e10,1e10,1e10,1e10,1e10,1*ones(1,N)];
param.relaxOrder = 2;
[param,SDPobjValue,POP,cpuTime,SDPsolverInfo,SDPinfo] = sparsePOP(objPoly,ineqPolySys,lbd,ubd,param);
