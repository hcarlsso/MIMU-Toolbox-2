function read_N_raw_measurements(com,N)

obj = ReadNPackages(N, 10);

com.BytesAvailableFcnCount = 40;
com.BytesAvailableFcnMode = 'byte';
com.BytesAvailableFcn = @obj.callback;

header_cmd = hex2dec('28');
% Output imus 1-4

outputmode = [...
    '0',... %  Temperature  
    '1',... % Raw inertial 
    '0',... % Single: 1 /even: 0 rate transmission
    '0',... % Lossy/lossless Does not matter USB
    '0111',... % Rate divider
    ]; 
set_imu_active = bin2dec('0001');
arg = [0 0 0 set_imu_active bin2dec(outputmode)];
command = [header_cmd arg];
cksum = calc_check_sum(command);
final_command = [command cksum];
% Create box 

% Start the show
fopen(com);
fwrite(com,final_command,'uint8');
waitfor(obj,'stop',true)
fclose(com);
end