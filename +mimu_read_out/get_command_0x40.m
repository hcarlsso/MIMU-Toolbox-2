function final_command = get_command_0x40(varargin)
%get_command_0x40 Use as normal IMU
%   This command will confgure the module to work as a normal IMU. The
%   readings from the different IMUs will be combined and foating point readings
%   (0x13) will be output according to the output mode byte.
%   For more information about the output mode byte, see command 0x20.
    import mimu_read_out.*
    header_cmd = hex2dec('40');

    final_command = [header_cmd get_outputmode(varargin{:})];
   
end