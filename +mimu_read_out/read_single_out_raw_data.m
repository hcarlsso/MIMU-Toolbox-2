function data = read_single_out_raw_data(com)


fopen(com);
%%
% Flush serial ports
while com.BytesAvailable
    fread(com,com.BytesAvailable,'uint8');
end

% 
header_cmd = hex2dec('28');
% Output imus 1-4
outputmode = [...
    '0',... %  Temperature  
    '1',... % Raw inertial 
    '1',... % Single: 1 /even: 0 rate transmission
    '0',... % Lossy/lossless Does not matter USB
    '0000',... % Rate divider, have to be zero for single event
    ]; 
arg = [0 0 0 bin2dec('1111') bin2dec(outputmode)];

command = [header_cmd arg];
cksum = calc_check_sum(command);

final_command = [command cksum];
tic;
fwrite(com,final_command,'uint8');
toc;
ack = fread(com,4,'uint8');
package_header = fread(com,4,'uint8');

check_ack(ack,header_cmd);
[Sz, header, N] = parse_package_header(package_header);

if Sz > 0
    data = fread(com,Sz,'uint8');
    disp('Data');
else
    disp('No Data') ;
    data = zeros(1);
end
ck = fread(com,2,'uint8');
disp('Checksum')
dec2hex(ck)

fclose(com);
%%
ck_sum_rec = calc_check_sum([header; N; Sz; data]);
dec2hex(ck_sum_rec)
end