function X = cartesian_product(v)
    x = num2cell(v, 2);    
    [X{1:numel(x)}] = ndgrid(x{:});