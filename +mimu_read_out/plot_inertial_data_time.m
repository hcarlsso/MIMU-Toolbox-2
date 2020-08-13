function plot_inertial_data_time(data, time)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    N_sensors = size(data, 1);
    inds_acc = sort([1:6:N_sensors, 2:6:N_sensors, 3:6:N_sensors]);
    inds_gyro = sort([4:6:N_sensors, 5:6:N_sensors, 6:6:N_sensors]);
    
    acc = data(inds_acc, :);
    gyro = data(inds_gyro, :);
    % acc
    directions = 'xyz';
    figure(6);
    axes = cell(3,1);
    for i = 1:3
        axes{i} = subplot(3,1,i);
        plot(time, acc(i:3:end,:)')
        grid on;
        title(['Acc ' directions(i)])
        xlabel('Time [s]')
    end
    linkaxes([axes{:}]);
    
    figure(7);
    for i = 1:3
        axes{i} = subplot(3,1,i);
        subplot(3,1,i); hold on;
        plot(time, gyro(i:3:end,:)')
        grid on;
        title(['Gyro ' directions(i)])
        xlabel('Time [s]')
    end
    linkaxes([axes{:}]);
        
end

