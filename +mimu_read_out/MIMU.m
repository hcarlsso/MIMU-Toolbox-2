classdef MIMU < handle
    %MIMU Wrapper Class for the MIMU
    %   Detailed explanation goes here
    
    properties
        com;
        command_to_execute;
    end    
    methods
        function obj = MIMU(com)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.com = com;
            obj.command_to_execute = '';
        end        
        function start_stream(obj)
            % start_stream execute command
            assert(~isempty(obj.command_to_execute))            
            obj.open();
            obj.send_command(obj.command_to_execute);
        end
        function open(obj)
            if ~strcmp(obj.com.Status, 'open')
                fopen(obj.com);
            end
        end
        function close(obj)
            % Empty buffer before closing
            obj.flush_with_wait(0.1);
            fclose(obj.com);
        end
        function stop_stream(obj)
            import mimu_read_out.calc_check_sum
            cmd_cksum = [hex2dec('22') calc_check_sum(hex2dec('22'))];
            fwrite(obj.com, cmd_cksum, 'uint8');
        end
        function send_command(obj, cmd)
            import mimu_read_out.calc_check_sum
            cmd_cksum = [cmd calc_check_sum(cmd)];
            
            cmd_hex = cellstr(dec2hex(cmd_cksum, 2));
            cmd_hex = strcat(cmd_hex{:});
            disp(['Sending to ', obj.com.Name, ' hex: ', cmd_hex])
            
            cmd_bin = cellstr(dec2bin(cmd_cksum, 4));
            cmd_bin = strcat(cmd_bin{:});
            disp(cmd_bin);
            fwrite(obj.com, cmd_cksum, 'uint8');
        end
        function test_ping(obj)
            obj.open()
            %test_ping Ping (0x03)
            import mimu_read_out.calc_check_sum
            
            command = [hex2dec('03')];
            obj.send_command(command);
            obj.read_ack(command);
            disp('Pinged successfully')
            
            obj.close()
        end
        function flush(o)
            while o.com.BytesAvailable > 0
                fread(o.com,o.com.BytesAvailable,'uint8');                
            end
        end
        function flush_with_wait(o, wait)
            while o.com.BytesAvailable > 0
                fread(o.com,o.com.BytesAvailable,'uint8');
                pause(wait);
            end
        end
        function read_ack(obj, cmd)
            % read_ack read the first 4 bytes of data package
            import mimu_read_out.calc_check_sum
            resp = fread(obj.com, 4, 'uint8');       
            % Assert ack
            if ~(resp(1) == hex2dec('a0'))
                disp(resp)
                error('Wrong header in ack')
            end
            % Assert header
            assert(resp(2) == cmd)
            
            % Check cksum
            ck_sum_rec = calc_check_sum(resp(1:2))';
            assert( all(ck_sum_rec == resp(3:4)))
            
        end
        function [N, payload] = read_single_payload(obj)
            %read_single_payload Payload size not specified
            import mimu_read_out.calc_check_sum
            import mimu_read_out.calc_package_number
            
            % Read Header 
            header_tot = fread(obj.com, 4,'uint8');            
            assert(header_tot(1) == hex2dec('AA'));                    
            N = calc_package_number(header_tot(2), header_tot(3));
            payload_size = header_tot(4);            
            
            % Read payload and cksum
            payload_and_cksum = fread(obj.com, payload_size + 2,'uint8');            
            payload = payload_and_cksum(1:end-2);
            cksum = payload_and_cksum(end-1:end);
            
            ck_sum_rec = calc_check_sum([header_tot; payload])';
            assert( all(ck_sum_rec == cksum));
            
        end
        function id = get_module_id(obj)
            obj.open()
            obj.flush();
            command = [hex2dec('04')];
            
            obj.send_command(command);
            obj.read_ack(command)

            [~, id] = read_single_payload(obj);
            
            assert(size(dec2hex(id),1) == 15)
            obj.close()
        end
        function cmd = set_stream_use_normal_imu(obj, bias, varargin)
            import mimu_read_out.*
            p = inputParser;
            
            addOptional(p,'bias_estimation', false, @(x) islogical(x));         
            parse(p,bias);
    
            if p.Results.bias_estimation
                obj.command_to_execute = get_command_0x41(varargin{:});
            else
                obj.command_to_execute = get_command_0x40(varargin{:});
            end
            
            cmd = obj.command_to_execute;
        end
        function cmd = set_stream_raw_data(obj, varargin)
            
            import mimu_read_out.*
            obj.command_to_execute = get_command_0x28(varargin{:});
            cmd = obj.command_to_execute;
        end
        function set_callback(obj, obj_container)
            
            % Specify number of bytes that must be available in input 
            % buffer to generate bytes-available event
            obj.com.BytesAvailableFcnCount = 2000; % Should only depend on how fast computer process
            
            % Specify whether bytes-available event is generated after 
            % specified number of bytes are available in input buffer, 
            % or after terminator is read
            obj.com.BytesAvailableFcnMode = 'byte';
            
            % Specify callback function to execute when specified number 
            % of bytes are available in input buffer, or terminator is read
            obj.com.BytesAvailableFcn = @obj_container.callback;
            obj.com.InputBufferSize = 1e6; % 0.5 Megabyte in input buffer size
        end
    end
end

