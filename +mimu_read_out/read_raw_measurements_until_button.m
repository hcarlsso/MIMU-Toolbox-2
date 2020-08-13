function read_raw_measurements_until_button(com)


obj_write_file = DataDumper('temp.bin');


f = figure(1);
ax = subplot(1,1,1);
h = animatedline(ax, 'DisplayName', 'Array1');
legend();
obj_buff_mon = InputBufferMonitor(h);
obj_buff_rate = FigureUpdateControl(1);

% Need to monitor before writing to memory
obj_container = CallbackContainer(obj_buff_mon, obj_write_file);

com.BytesAvailableFcnCount = 2000; % Should only depend on how fast computer process
com.BytesAvailableFcnMode = 'byte';
com.BytesAvailableFcn = @obj_container.callback;
com.InputBufferSize = 5e5; % 0.5 Megabyte in input buffer size


stop_obj = Stop_0x22(com);

header_cmd = hex2dec('28');
% Output imus 1-4

outputmode = [...
    '0',... %  Temperature  
    '1',... % Raw inertial 
    '0',... % Single: 1 /even: 0 rate transmission
    '0',... % Lossy/lossless Does not matter USB
    '0010',... % Rate divider
    ]; 
set_imu_active = bin2dec('1111');
arg = [0 0 0 set_imu_active bin2dec(outputmode)];
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