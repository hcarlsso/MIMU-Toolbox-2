
% Open serial port
% com_usb = serial('COM6', 'BaudRate', 460800);
% com_bt = serial('COM3', 'BaudRate', 460800, 'InputBufferSize', 1e6);
% com_bt = serial('COM4')

% MIMU_usb = mimu_read_out.MIMU(com_usb); 
% MIMU_usb.test_ping;


com_bt = serial('COM4', 'BaudRate', 460800, 'InputBufferSize', 1e6); 
MIMU_bt = mimu_read_out.MIMU(com_bt);
MIMU_bt.test_ping

% com_usb = serial('COM6', 'BaudRate', 460800, 'InputBufferSize', 1e6); 
% MIMU_usb = mimu_read_out.MIMU(com_usb);
% MIMU_usb.test_ping