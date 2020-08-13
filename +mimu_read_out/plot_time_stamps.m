function plot_time_stamps(time_stamps)

CLOCK_FREQ = 64e6;


figure();
subplot(3,1,1);
plot(double(time_stamps)'/CLOCK_FREQ,'b-');
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
dt = dt/CLOCK_FREQ;
plot(dt,'b-');
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


end