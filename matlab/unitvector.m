function u = unitvector(p1, p2)
    v = Vector(p2-p1);
    u = v / norm(v);