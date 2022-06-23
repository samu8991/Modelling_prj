function gde = metric_GDE(out, show, N)
arguments
    out
    show = false;
    N = 6;
end

gde = timeseries;
gde.time = out.tout;

y0_global = ones(N, 1) * out.y0.data';
y_global = [out.y1.data'
            out.y2.data'
            out.y3.data'
            out.y4.data'
            out.y5.data'
            out.y6.data' ];

gde.data = (y_global - y0_global)';

if show
   plot(gde);
   legend("s1", "s2", "s3", "s4", "s5", "s6");
   title("Global Disagreement Error");
end

end