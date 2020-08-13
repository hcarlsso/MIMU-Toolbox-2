classdef CallbackContainer < handle
    properties
        children;
    end    
    methods
        function obj = CallbackContainer(varargin)
            obj.children = varargin;
        end
        function obj = callback(obj, com, event)
            for n = 1:length(obj.children)
                obj.children{n}.callback(com,event);
            end
        end
        function close(obj)
            for n = 1:length(obj.children)
                obj.children{n}.close();
            end
        end
    end
end
