import mimu_read_out.*
cmd = [hex2dec("20") hex2dec("01") hex2dec("20")];

cmd_cksum = mimu_read_out.calc_check_sum(cmd);

cmd_tot = [cmd cmd_cksum];



fopen(com);

disp("Send")
mimu_read_out.get_hex(cmd_tot)
fwrite(com,cmd_tot,'uint8');
ack = fread(com_bt,4,'uint8'); % Read ack

disp("Ack")
mimu_read_out.get_hex(ack)

% 1 byte header
% 2 byte package counter
% 1 byte size of payload 
% 4 bytes time-stamp
% 2 byte cksum
% 10 bytes in total
time_stamp = fread(com_bt,10,'uint8'); 
disp("Time-stamp")
mimu_read_out.get_hex(time_stamp)
fclose(com_bt);