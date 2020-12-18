import mimu_read_out.*
% temparure of imu 1
cmd = [hex2dec("20") hex2dec("60") hex2dec("20")];

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
% 2 bytes temperature
% 2 byte cksum
% 8 bytes in total
data = fread(com_bt,8,'uint8'); 
fclose(com_bt);

resp = mimu_read_out.get_hex(time_stamp);
disp("header")
resp{1} 
disp("Counter")
resp{2:3} 
disp("Payload size")
resp{4} 
disp("Temperature:")
resp{5:6} 
disp("CK sum:")
resp{7:8} 