function l = generateLegend(n, symbols, desc)
arguments
    n % number of rows for the legend
    symbols % contains a list of strings describing LineSpec
    desc % contains a list of strings descibing the legend itslef
end

h = zeros(n,1);
for i = 1:n
   h(i) = plot(NaN, NaN, symbols(i), 'DisplayName', desc(i));
end

l = legend(h);

end