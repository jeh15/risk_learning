function new_clusters = cluster(clusters)
    n = numel(clusters);    
    if n <= 1
        new_clusters = clusters;
    elseif n == 2
        if clusters(1).type == clusters(2).type
            new_clusters = combine(clusters(1), clusters(2));
        else
            new_clusters = clusters;
        end
    elseif n == 3
        if can_cluster(clusters, 1 ,2)
            new_clusters = cluster([combine(clusters(1), clusters(2)), clusters(3)]);
        elseif can_cluster(clusters, 1 ,3)
            new_clusters = cluster([combine(clusters(1), clusters(3)), clusters(2)]);
        elseif can_cluster(clusters, 2 ,3)
            new_clusters = cluster([combine(clusters(2), clusters(3)), clusters(1)]);
        else
            new_clusters = clusters;
        end
    else
        l = floor(n/3);
        m = floor(2*n/3);
        new_clusters = cluster([cluster(clusters(1:l)), ...
                                cluster(clusters(l+1:m)), ...
                                cluster(clusters(m+1:n))]);
    end
    
%     for m = 1:numel(clusters)
%         for n = m+1:numel(clusters)
%             if can_cluster(clusters, m, n)
%                 proposed_clusters = cluster([
%                                         combine(clusters(m), clusters(n)), ...
%                                         clusters(1:m-1), ...
%                                         clusters(m+1:n-1), ...
%                                         clusters(n+1:end) ]);
%                 if numel(proposed_clusters) < numel(clusters)
%                     new_clusters = proposed_clusters;
%                 end
%             else
%                 new_clusters = clusters;
%             end
%         end
%     end