function stop_output_0x22(com)

% Prepare command 
header_cmd = hex2dec('22');
cksum = calc_check_sum(header_cmd);
final_command = [header_cmd cksum];
disp('Send stop')

% Do the communication
fwrite(com,final_command,'uint8');
ack = fread(com,4,'uint8');

% Check that it was correct
check_ack(ack,header_cmd);


end