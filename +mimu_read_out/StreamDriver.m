classdef StreamDriver < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stop;
        streams;
    end
    methods
        function obj = StreamDriver(stop, varargin)
            obj.stop = stop;
            obj.streams = varargin;
        end
        
        function stream_blocking(obj)
            for n = 1:length(obj.streams)
                obj.streams{n}.start_stream()
            end
            % Wait for measurements here
            waitfor(obj.stop,'stop',true);
            pause(1);
        end
        function close_all(obj)
            for n = 1:length(obj.streams)
                obj.streams{n}.close()
            end
        end
    end
end

