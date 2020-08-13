function read_raw_measurements_until_button_multiple_coms(com0, com1)
% Read from two devices Raw IMU data (0x28)
header_cmd = hex2dec('28');
% Output imus 1-4

outputmode = [...
    '0',... %  Temperature  
    '1',... % Raw inertial 
    '0',... % Single: 1 /even: 0 rate transmission
    '0',... % Lossy/lossless Does not matter USB
    ]; 
set_imu_active = bin2dec('1111');

rate_div1 = '0001'; % Rate divider, new device
rate_div2 = '0010'; % Rate divider, old device 

arg1 = [0 0 0 set_imu_active bin2dec([outputmode rate_div1])];
command1 = [header_cmd arg1];
cksum1 = calc_check_sum(command1);
final_command1 = [command1 cksum1];

arg2 = [0 0 0 set_imu_active bin2dec([outputmode rate_div2])];
command2 = [header_cmd arg2];
cksum2 = calc_check_sum(command2);
final_command2 = [command2 cksum2];


% bytes
payload_size = 4 + 4*6 + 2; %header, payload, cksum

obj_write_file1 = ReadPackages(payload_size,'temp_1.bin');
obj_write_file2 = ReadPackages(payload_size,'temp_2.bin');


f = figure(1);
ax = subplot(1,1,1);
h1 = animatedline(ax, 'DisplayName', 'Array1','Color', 'blue');
h2 = animatedline(ax, 'DisplayName', 'Array2','Color', 'red');
legend();
obj_buff_mon1 = InputBufferMonitor(h1);
obj_buff_mon2 = InputBufferMonitor(h2);

% Need to monitor before writing to memory
obj_container1 = CallbackContainer(obj_buff_mon1, obj_write_file1);
obj_container2 = CallbackContainer(obj_buff_mon2, obj_write_file2);


com0 = set_settings_serial(com0);
com1 = set_settings_serial(com1);

com0.BytesAvailableFcn = @obj_container1.callback;
com1.BytesAvailableFcn = @obj_container2.callback;

stop_obj = Stop_0x22(com0,com1);


% Create box 

c = uicontrol(f);
c.String = 'Abort';
c.Callback = @stop_obj.callback;


% Start the show
fopen(com0);
fopen(com1);
fwrite(com0,final_command1,'uint8');
fwrite(com1,final_command2,'uint8');
waitfor(stop_obj,'stop',true);
obj_write_file1.empty_output_buffer(com0);
obj_write_file2.empty_output_buffer(com1);

% Clean up
fclose(com0);
fclose(com1);

obj_write_file1.final();
obj_write_file2.final();
disp('Com0')
disp(obj_write_file1.nof_bytes)
disp('Com1')
disp(obj_write_file2.nof_bytes)
clf(f);

end

function com = set_settings_serial(com)
    com.BytesAvailableFcnCount = 1e4; % Should only depend on how fast computer process
    com.BytesAvailableFcnMode = 'byte';
    com.InputBufferSize = 5e5; % 0.5 Megabyte in input buffer size
end
