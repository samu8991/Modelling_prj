function s = deploy(n, l, raggio, deployment_type)
    s = zeros(n,2);
    if deployment_type == 1
        %% Deployment di tipo a
        cont = true;
        s = rand(n,2)*(l-1)+ 1; % First generation
        ok = zeros(n);
        ok(1) = true;
        for i=2:n
            
        end
        while cont  
            var = ~overlapped_sensors(s,raggio); % declared at the end of this file
            if var
                cont = false;
            end
        end
    elseif deployment_type == 2
        %% Deployment di tipo b
%         verified = false;
%         vertice_griglia_5_by_5 = zeros(1,2);
%         while ~verified
%             vertice_griglia_5_by_5 = randi([1,10],[1,2]);
%             if vertice_griglia_5_by_5(1) + 5 <= 10 && vertice_griglia_5_by_5(2) + 5 <= 10
%                 verified = true;
%             end
%         end
        vertice_griglia_5_by_5 = [3,4];
        s = zeros(n,2);
        
        s(1,2) = vertice_griglia_5_by_5(2);
        s(1,1) = vertice_griglia_5_by_5(1);
        for i = 1:n-1
           if(mod(i,5) == 0)
               s(i+1,1) = s(i,1)+1;
               s(i+1,2) = vertice_griglia_5_by_5(2);
           else 
               s(i+1,1) = s(i,1);
               s(i+1,2) = s(i,2)+1;
           end
        
        end
    end
end

function ok = calculate_ok(s, radius)
    n = length(s);
    for i=1:n
        d = norm(s(i,:) - s(j
    end

end

function ret = overlapped_sensors(s,raggio)
    ret = 0;    
    for i = 1:length(s)-1
        for j = i+1 : length(s)
            if(norm(s(i,:)-s(j,:)) < raggio)
                ret = 1;
                return;
            end
        end
    end    
end
