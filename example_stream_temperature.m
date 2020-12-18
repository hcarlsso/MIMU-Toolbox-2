import mimu_read_out.*
% temparure of imu 1
cmd = [hex2dec("20") hex2dec("60") hex2dec("07")];
cmd_cksum = mimu_read_out.calc_check_sum(cmd);
cmd_tot = [cmd cmd_cksum];
disp("Cmd to send")
mimu_read_out.get_hex(cmd_tot)

% Figure for plotting
figure(1)
clf
hold on
grid on
h = animatedline;
title('Temperature ');
ylabel('[C]');
% Add pushbutton such that logging can be aborted
abort_flag = 0;
uicontrol('style','push','string','Stop','callback','abort_flag=1;');
drawnow


com = serial('COM4', 'BaudRate', 460800, 'InputBufferSize', 1e6); 
fopen(com);
pause(1);
com
while com.BytesAvailable > 0
    fread(com, com.BytesAvailable, 'uint8')
end
com
% flush(com);

counter = 0;
N = 100;
temp = zeros(N,1,'uint16');
fwrite(com,cmd_tot,'uint8');
ack = fread(com,4,'uint8'); % Read ack
disp("Ack")
mimu_read_out.get_hex(ack)

while abort_flag == 0 && counter <= N
    if(com.BytesAvailable>=8)
        counter = counter + 1;
        % 2 byte cksum
        % 8 bytes in total
        % Read Header, 1 byte
        header = fread(com, 1, 'uint8');
        dec2hex(header,2);
        % assert('AA' == dec2hex(header,2)); 
        % 2 byte package counter
        p_counter = fread(com, 1, 'uint16');
        
        % 1 byte size of payload
        p_size = fread(com, 1, 'uint8');
        
        % 2 bytes temperature
        temp(counter) = fread(com, 1, 'uint16');
        
        % 2 bytes cksum
        cksum = fread(com, 1, 'uint16');
        
        addpoints(h, counter, double(temp(counter)-521)/340);
        drawnow
    end
end
%% 
fwrite(com,[hex2dec("22") 0 hex2dec("22")],'uint8');
fclose(com);

