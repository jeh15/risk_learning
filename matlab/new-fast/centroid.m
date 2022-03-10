function c = centroid(points)
    centroid_coords = mean(points, 2);
    c = Point(centroid_coords);