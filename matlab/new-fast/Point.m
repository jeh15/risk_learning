classdef Point < double
    methods
        function obj = Point(data)
            if isrow(data)
                coords = data';
            else
                coords = data;
            end 
            obj = obj@double(coords);
        end
    end
end