function [] = plot_points(points, color, sz, alpha_val)
    if nargin == 1
        color = 'red';
        sz = 36;
        alpha_val = 1;
    elseif nargin == 2
        sz = 36;
        alpha_val = 1;
    elseif nargin == 3
        alpha_val = 1;
    end
    
    points_dim = size(points, 1);
    if points_dim == 1
        s = scatter(points(1,:), zeros(size(points)), sz, color, 'filled');
        l = yline(0, 'k:');
        l.Color(4) = 0.5;
    elseif points_dim == 2
        s = scatter(points(1, :), points(2, :), sz, color, 'filled');
    elseif points_dim == 3
        s = scatter3(points(1, :), points(2, :), points(3, :), sz, color, 'filled');
    else
        error("Cannot plot " + points_dim + "D points");        
    end
    
    alpha(s, alpha_val);
end