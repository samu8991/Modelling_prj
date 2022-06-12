function t = metric_CtSi(out, agent, threshold)
arguments
    out
    agent
    threshold = 1e-2 % one percent
end

y0 = out.y0;
y = out.find(agent);

err = y0.data - y.data;
logicErr = err <= threshold;

i=0;
while logicErr(end-i) == 1
    i = i+1;
end
i = i-1;
if i <= 0
    i = 1;
end
t = out.tout(end-i);

end