function r = can_cluster(clusters, m, n)
    if clusters(m).type ~= clusters(n).type
        r = false;
    else
        k = 6 - (m + n);
        d = cluster_distance(clusters(m), clusters(n));
        dm = cluster_distance(clusters(m), clusters(k));
        dn = cluster_distance(clusters(n), clusters(k));
        if d > dm && d > dn
            r = false;
        else
            r=  true;
        end
    end

%     if clusters(m).type ~= clusters(n).type
%         r = false;
%     else        
%         r = true;
%         d = cluster_distance(clusters(m), clusters(n));
%         for k = 1:numel(clusters)
%             if clusters(k).type ~= clusters(m).type
%                 dm = cluster_distance(clusters(k), clusters(m));
%                 dn = cluster_distance(clusters(k), clusters(n));
%                 if d > dm && d > dn
%                     r = false;
%                     break
%                 end
%             end                
%         end
%     end
%         