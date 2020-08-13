import mimu_read_out.*
load_constants;
filename = 'temp_raw_data.bin';
% MIMU_obj = MIMU_usb;

MIMU_obj = MIMU_bt;
rate_div = 5; % 62.5 

active_imus = [3,4,5,6, 27,28, 29, 30]; % Corner IMUs
% active_imus = 1:32;


obj_write_file = DataDumper(filename);


f = figure(1); clf;
ax = subplot(1,1,1);
h = animatedline(ax, 'DisplayName', 'Array1');
legend();
obj_buff_mon = InputBufferMonitor(h);

% Need to monitor before writing to memory
obj_container = CallbackContainer(obj_buff_mon, obj_write_file);
MIMU_obj.set_callback(obj_container);
MIMU_obj.set_stream_raw_data(active_imus, 'inertial', true, 'rate_divider', rate_div);

stop_obj = Stop_0x22(MIMU_obj.com);
% Create box 
c = uicontrol(f);
c.String = 'Abort';
c.Callback = @stop_obj.callback;

stream_driver = StreamDriver(stop_obj, MIMU_obj);

% Start the show
stream_driver.stream_blocking();
stream_driver.close_all();
obj_container.close();

%%
nr_imus = length(active_imus);
% Parse data and delete logging file
[inertial_data,time_stamps,raw_data] = parsers.mimu_parse_bin(filename,uint8(nr_imus));
% delete(filename);
inertial_data_double = double(inertial_data);

% Plot data in SI units
inertial_data_double = mimu_read_out.scale_measurements(inertial_data_double);

mimu_read_out.plot_inertial_data(inertial_data_double);
mimu_read_out.plot_time_stamps(time_stamps);


