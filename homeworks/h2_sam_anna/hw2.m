clc
clear
close all

N = 50; %numero di misurazioni
dim_theta = 5;
%% Obj function

objPoly.typeCone = 1;
objPoly.dimVar = dim_theta + N;
objPoly.degree = 1;
objPoly.noTerms = 1;
objPoly.supports = [1,zeros(2:N)];% noTerms * dimVar
objPoly.coef = 1;

%% Constraints
ineqPolySys{1}.typeCone = 1;
ineqPolySys{1}.dimVar = dim_theta + N;
ineqPolySys{1}.degree = 1;
ineqPolySys{1}.noTerms = 9;
ineqPolySys{1}.supports = [0,0,0; 1,0,0; 0,1,0; 0,0,1; ...
2,0,0; 0,2,0; 0,1,1; 0,0,2];
ineqPolySys{1}.coef = [19; -17; 8; -14; 6; 3; -2; 3];


