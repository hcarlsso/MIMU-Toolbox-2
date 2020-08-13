classdef ReadNPackages < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        N;
        ack;
        Psize; % Payload size
        safety_counter;
        queue;
        stop;
    end    
    methods
        function obj = ReadNPackages(N, Psize)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.N = N;
            obj.Psize = Psize;
            obj.queue = zeros(Psize,1,'uint8');
            obj.ack = false;
            obj.safety_counter = 0;
            obj.stop = false;
        end        
        function obj = callback(obj, com, event)
            % Determine the time of the error event.
            EventData = event.Data;
            EventDataTime = EventData.AbsTime;

            if com.BytesAvailable
                data = fread(com,com.BytesAvailable, 'uint8');
            end
            
            if obj.safety_counter > 2
                stop_output_0x22(com);
                obj.stop = true;
            else
                obj.safety_counter = obj.safety_counter + 1;
            end
        end
    end
end

