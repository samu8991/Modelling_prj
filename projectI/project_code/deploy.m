function s = deploy(n, l, raggio, deployment_type, bottom_left_vertex, min_radius)
arguments    
    n %numero di agenti
    l % lato del quadrato
    raggio % raggio di comunicazione
    deployment_type % 1 per il deployment casuale, 2 per quello a griglia
    bottom_left_vertex = [0.5,0.5];
    min_radius = 1; % minimum radius for the sensors in order not to generate redundancy
end
    s = zeros(n,2);
    if deployment_type == 1
       %% Deployment di tipo a
       cont = true;
        s = unifrnd(0, 10, n, 2); % First generation
        while cont
           cont = false;
           ok = compute_ok(s, raggio, min_radius); % defined later in this file
           for i = 1:n
               if ok(i) == false
                   s(i,:) = unifrnd(0, 10, 1, 2);
                   cont = true;
               end
           end
        end
    elseif deployment_type == 2
        %% Deployment di tipo b
        spacing = [ (l-2*bottom_left_vertex(1))/(sqrt(n)-1)
                    (l-2*bottom_left_vertex(2))/(sqrt(n)-1) ];
                
        % check whtere the deployment is feasible
        if raggio < max(spacing)
            disp("Error! The radius is too little!!!!");
            disp("It must be >= " + max(spacing));
        end
        assert(raggio >= max(spacing));
            
                
        s = zeros(n,2);
        
        s(1,1) = bottom_left_vertex(1);
        s(1,2) = bottom_left_vertex(2);
        for i = 1:n-1
           if(mod(i,sqrt(n)) == 0)
               s(i+1,1) = s(i,1)+spacing(1);
               s(i+1,2) = bottom_left_vertex(2);
           else 
               s(i+1,1) = s(i,1);
               s(i+1,2) = s(i,2)+spacing(2);
           end
        end
    end
end

function ok = compute_ok(s, radius, min_radius)
    % Assuming the first element is correctly positioned, i loop through
    % all the nodes to find its neighbors and the neighbors of the
    % neighbors. At the end, the ok vector will have true if the nodes
    % belong to the spanning tree that has the first node as a root
    n = length(s);
    ok = zeros(n,1);
    check_list = [1]; % FIFO list
    
    too_near = zeros(n,1);
    for i=1:n-1
        for j=i+1:n
            d = norm(s(i,:) - s(j,:), 2);
            if d < min_radius
                too_near(j) = true;
            end
        end
    end         
    
    while length(check_list) >= 1
       active_index = check_list(1); % get the current item
       check_list = check_list(2:end); % pop
       ok(active_index) = true;
       for i=1:n % iterate over the nodes
           d = norm(s(active_index,:) - s(i,:), 2);
           if d < radius && too_near(i) == false && ok(i) == false % to find neighbors of the active
               ok(i) = true; % if i is neighbor of active, i push it into the check_list
               check_list(length(check_list)+1) = i; % push
           end
       end
    end
end