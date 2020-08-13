classdef InputBufferMonitor < handle
    properties
        animated_line;
    end    
    methods
        function obj = InputBufferMonitor(animated_line)
            obj.animated_line = animated_line;
        end
        function obj = callback(obj, com, ~)
            addpoints(obj.animated_line,now,com.BytesAvailable)            
        end
        function close(~)            
            % Do nothing
        end
    end
end