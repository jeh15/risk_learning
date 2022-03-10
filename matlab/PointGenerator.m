function generator = PointGenerator(points_dim, ranges, seed)

    if nargin == 1
        ranges = [zeros(points_dim, 1) ones(points_dim, 1)];
        seed = -1;
    elseif nargin == 2        
        seed = -1;
    end
    
    
    diff = points_dim - size(ranges, 1);
    if diff > 0
        ranges = [ranges; 
                  zeros(diff, 2)];
    elseif diff < 0
        ranges = ranges(1:points_dim, :);
    end
    
    if seed ~= -1
        rng(seed, 'twister');
    else
        rng('shuffle');
    end

    function point = generate_random_point()
        coords = (ranges(:,2)-ranges(:,1)).*rand(points_dim,1) + ranges(:,1);
        point = Point(coords);
    end

    generator = @generate_random_point;

end