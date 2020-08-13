function inertial_data_scaled = scale_measurements(inertial_data, varargin)
%scale_raw_acc Scale raw_acc to m/s^2

    p = inputParser;
    
    addParameter(p, 'scale_acc', 2048*9.80665, @(x) x > 0);
    addParameter(p, 'scale_gyro', 16.4, @(x) x > 0);
    
    parse(p,varargin{:});
    
    N_sensors = size(inertial_data, 1);
    inds_acc = sort([1:6:N_sensors, 2:6:N_sensors, 3:6:N_sensors]);
    inds_gyro = sort([4:6:N_sensors, 5:6:N_sensors, 6:6:N_sensors]);
    
    inertial_data_scaled = zeros(size(inertial_data));
    
    inertial_data_scaled(inds_acc,:) = inertial_data(inds_acc,:)./p.Results.scale_acc;
    inertial_data_scaled(inds_gyro,:) = inertial_data(inds_gyro,:)./p.Results.scale_gyro;

end

