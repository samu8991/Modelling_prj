test_n = 50;
test_err = zeros(test_n,1);

rng(12);

for i=1:test_n
    target = rand(2,1) * 10;
    showRoom;
    pos2cell(target(1), target(2))
    localized = runOnce(target, -1);
    test_err(i) = norm(target-localized);  
    name = "Tests"+i;
    save(name);
end
