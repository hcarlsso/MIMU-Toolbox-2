function final_command = get_command_0x41(varargin)
%get_command_0x41 Use as normal IMU with online bias estimation
%   This command will configure the module to work as a normal IMU with
%   online gyro bias estimation and compensation. Gyro biases are estimated
%   based on time instants where the inertial readings in a time window shows
%   a noise floor characteristics. The bias estimates will be subtracted from the
%   combined inertial readings. Since the biases are estimated online there is a
%   127 sample delay (approximately 0.127s) in the received readings.
%   For more information about the output mode byte, see command 0x20.
    import mimu_read_out.*
    header_cmd = hex2dec('41');

    final_command = [header_cmd get_outputmode(varargin{:})];
    
end