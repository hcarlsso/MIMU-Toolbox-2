classdef Stop_0x22 < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stop;
        coms;
    end  
    methods
        function obj = Stop_0x22(varargin)
            obj.stop = false;
            obj.coms = varargin;
        end
        function add_com(obj, com)
            obj.coms{end+1} = com;
        end
        function obj = callback(obj,~,~)
            import mimu_read_out.calc_check_sum
            header_cmd = hex2dec('22');
            cksum = calc_check_sum(header_cmd);
            final_command = [header_cmd cksum];
            
            % Do the communication
            for n = 1:length(obj.coms)
                disp(['Send stop to ', obj.coms{n}.Name])
                fwrite(obj.coms{n}, final_command,'uint8');
            end
            
            % Function listens to this variable
            obj.stop = true;
        end
    end
end