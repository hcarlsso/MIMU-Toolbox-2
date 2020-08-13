function read_multiple_states(com)


obj_write_file = ReadPackages(12,'temp.bin');


f = figure(1);
ax = subplot(1,1,1);
h = animatedline(ax, 'DisplayName', 'Array1');
legend();
obj_buff_mon = InputBufferMonitor(h);


% Need to monitor before writing to memory
obj_container = CallbackContainer(obj_buff_mon, obj_write_file);

com.BytesAvailableFcnCount = 3000; % Should only depend on how fast computer process
com.BytesAvailableFcnMode = 'byte';
com.BytesAvailableFcn = @obj_container.callback;
com.InputBufferSize = 5e5; % 0.5 Megabyte in input buffer size


stop_obj = Stop_0x22(com);

header_cmd = hex2dec('21');

outputmode = [...
    '0',... %  Temperature, not used here
    '0',... % Raw inertial, not used here
    '0',... % Single: 1 /even: 0 rate transmission
    '0',... % Lossy/lossless Does not matter USB
    ]; 
rate_divider = '0001'; % Rate divider
states = [...
    hex2dec('01'),... % time-stamp, 4 bytes, uint32
    hex2dec('40'),... % IMU1, 12 bytes, int16
    hex2dec('41'),... % IMU2, 12 bytes, int16
    hex2dec('42'),... % IMU2, 12 bytes, int16
    0,0,0,0]; % Fill up the remaining bytes with zeros
arg = [states bin2dec([outputmode rate_divider])];
command = [header_cmd arg];
cksum = calc_check_sum(command);
final_command = [command cksum];

% Create box 

c = uicontrol(f);
c.String = 'Abort';
c.Callback = @stop_obj.callback;


% Start the show
fopen(com);
fwrite(com,final_command,'uint8');
waitfor(stop_obj,'stop',true);
obj_write_file.empty_output_buffer(com);

% Clean up
fclose(com);
obj_write_file.final();
disp(obj_write_file.nof_bytes)
clf(f);

end