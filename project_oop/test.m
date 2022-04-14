test_n = 50;
test_err = zeros(test_n,1);

for i=1:test_n
    target = rand(2,1) * 10
    pos2cell(target(1), target(2))
    main
    pause
end