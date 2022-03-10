function [] = plot_line(p1, p2, color, line_style, line_width, alpha_val)
    if nargin == 2
        color = 'red';
        line_style = '-';
        line_width = 0.5;
        alpha_val = 1;
    elseif nargin == 3
        line_style = '-';
        line_width = 0.5;
        alpha_val = 1;
    elseif nargin == 4
        line_width = 0.5;
        alpha_val = 1;
    elseif nargin == 5
        alpha_val = 1;
    end
    
    points_dim = size(p1, 1);
    if points_dim == 1
        x = [p1(1), p2(1)];
        l = plot(x, [0, 0], 'color', color, 'LineStyle', line_style, ...
                   'LineWidth', line_width);
    elseif points_dim == 2
        x = [p1(1), p2(1)];
        y = [p1(2), p2(2)];
        l = plot(x, y, 'color', color, 'LineStyle', line_style, ...
                   'LineWidth', line_width);
    elseif points_dim == 3
        x = [p1(1), p2(1)];
        y = [p1(2), p2(2)];
        z = [p1(3), p2(3)];
        l = plot3(x, y, z, 'color', color, 'LineStyle', line_style, ...
                    'LineWidth', line_width);
    else
        error("Cannot plot " + points_dim + "D line");      
    end
    l.Color(4) = alpha_val;
end