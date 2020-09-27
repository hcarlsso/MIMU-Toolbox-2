classdef DataDumper < handle
    %DataDumper Dump incoming data to file
    %   Detailed explanation goes here
    
    properties
        file;
        nof_bytes;
        filename;
    end    
    methods
        function obj = DataDumper(filename)
            % Open binary file for saving inertial data
            fprintf('Open %s\n', filename)
            obj.file = fopen(filename, 'w');
            obj.filename = filename;
            obj.nof_bytes = 0;
        end        
        function obj = callback(obj, com, ~)
            % Determine the time of the error event.

            obj.read_data(com); 
        end
        function obj = read_data(obj, com)
            if com.BytesAvailable > 0
                data = fread(com, com.BytesAvailable, 'uint8');
                n_bytes = fwrite(obj.file, data, 'uint8');
                obj.nof_bytes = obj.nof_bytes + n_bytes;
                fprintf('%s: %d bytes\n', datestr(now,'HH:MM:SS.FFF'), n_bytes)
            end            
        end
        function obj = close(obj)
            fclose(obj.file);
            fprintf('Wrote %d bytes to %s\n', obj.nof_bytes, obj.filename)
        end
    end
end
