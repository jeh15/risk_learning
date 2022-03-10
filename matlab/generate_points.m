function points = generate_points(point_generator, num_points)
    point_dim = numel(point_generator());
    points = zeros(point_dim, num_points);
    
    for k = [1:num_points]
        points(:,k) = point_generator();
    end