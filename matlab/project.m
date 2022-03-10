function projected_points = project(points, u)
    projected_points = vecdot(points, u) .* u;