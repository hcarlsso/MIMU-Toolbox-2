function [acc, gyro] = separate_acc_gyro(inertial_data, varargin)

    N_sensors = size(inertial_data, 1);
    
    fprintf("Number of IMUs: %d\n", N_sensors/6)

    inds_acc = sort([1:6:N_sensors, 2:6:N_sensors, 3:6:N_sensors]);
    inds_gyro = sort([4:6:N_sensors, 5:6:N_sensors, 6:6:N_sensors]);
    
    
    acc = inertial_data(inds_acc,:);
    gyro = inertial_data(inds_gyro,:);

end

