function plot_inertial_data(data, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    N_sensors = size(data, 1);
    N_samples = size(data, 2);
    
    p = inputParser;
    addParameter(p, 'time', 1:N_samples);
    addParameter(p, 'saturation', false);
    
    parse(p,varargin{:});
    
    time = p.Results.time;
    if all(time == 1:N_samples)
        label = 'Sample Number';
    else
        label = 'Time [s]';
    end
    inds_acc = sort([1:6:N_sensors, 2:6:N_sensors, 3:6:N_sensors]);
    inds_gyro = sort([4:6:N_sensors, 5:6:N_sensors, 6:6:N_sensors]);
    
    
    acc = data(inds_acc, :);
    gyro = data(inds_gyro, :);
    % acc
    directions = 'xyz';
    figure(); 
    axes = cell(3,1);
    for i = 1:3
        axes{i} = subplot(3,1,i);
        plot(time, acc(i:3:end,:)')
        if p.Results.saturation
           hold on;
           % Assume AFS_SEL = 3
           g = mimu_read_out.get_gravity_norm();
           sat = 16;
           plot(time,  sat*g*ones(size(time)), '-r');
           plot(time, -sat*g*ones(size(time)), '-r');
        end
        grid on;
        title(['Accelerometer readings ', directions(i)]);
        xlabel(label)
        ylabel('[m/s^2]');

    end
    linkaxes([axes{:}]);
    
    figure(); 
    for i = 1:3
        axes{i} = subplot(3,1,i);
        subplot(3,1,i); hold on;
        plot(time, gyro(i:3:end,:)')
        
        if p.Results.saturation
           hold on;
           % Assume FS_SEL = 3
           sat = 2000.0;
           plot(time,  sat*ones(size(time)), '-r');
           plot(time, -sat*ones(size(time)), '-r');
        end
        
        grid on;
        title(['Gyro ' directions(i)])
        title(['Gyroscope ', directions(i)]);
        xlabel(label)
        ylabel('\omega [deg/s]');
    end
    linkaxes([axes{:}]);

end

