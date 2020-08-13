import mimu_read_out.*
filename = 'temp_normal_imu.bin';

% MIMU_obj = MIMU_usb;
MIMU_obj = MIMU_bt;

obj_write_file = DataDumper(filename);


f = figure(1); clf;
ax = subplot(1,1,1);
h = animatedline(ax, 'DisplayName', 'Array1');
legend();
obj_buff_mon = InputBufferMonitor(h);

% Need to monitor before writing to memory
obj_container = CallbackContainer(obj_buff_mon, obj_write_file);


MIMU_obj.set_callback(obj_container);
MIMU_obj.set_stream_use_normal_imu(true, 'rate_divider', 4);

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


% Parse data and delete logging file
[inertial_data,time_stamps,raw_data] = parsers.parse_imu_data(filename);
%delete(filename);

%% Plot data in SI units
offset_fig = 0;
figure(1+offset_fig),clf, hold on
plot(inertial_data(1:3,:)');
% plot(sqrt(sum(inertial_data(1:3,:).^2)),'c');
legend('x','y','z')
grid on
title('Accelerometer readings');
xlabel('sample number')
ylabel('a [m/s^2]');
figure(2+offset_fig), clf, hold on
plot(inertial_data(4:6,:)'*180/pi);
% plot(sqrt(sum((inertial_data(4:6,:)*180/pi).^2)),'c');
legend('x','y','z')
grid on
title('Gyroscope readings');
xlabel('sample number')
ylabel('\omega [deg/s]');

figure(3+offset_fig),clf, hold on
subplot(3,1,1);
plot(double(time_stamps)'/64e6,'b-');
grid on
title('Time stamps');
xlabel('sample number')
ylabel('[s]');
subplot(3,1,2);
dt = diff(double(time_stamps)');
for i=1:numel(dt)
    if dt(i)<0
        dt(i) = dt(i)+2^32;
    end
end
dt = dt/64e6;
semilogy(dt,'b-');
grid on
title('Time differentials');
xlabel('sample number')
ylabel('[s]');

subplot(3,1,3);
plot(1./dt, 'b-');
grid on
title('Sampling freq');
xlabel('sample number')
ylabel('[1/s]');
