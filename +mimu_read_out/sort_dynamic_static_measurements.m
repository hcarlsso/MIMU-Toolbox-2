function data_filt = sort_dynamic_static_measurements(data, points)

    assert(mod(length(points),2) == 0)
    
    points = sort(points);
    points_lb = points(1:2:end);
    points_ub = points(2:2:end);
    
    % Statics 

    % Points are from cursor in time [s]
    data_static = cell(length(points)/2,1);
    for i = 1:length(points_ub)
        mask = points_lb(i) < data.time &  data.time < points_ub(i);
        % Iterate IMU
        raw_acc = cell(4,1);
        raw_gyro = cell(4,1);
        for k = 1:4
            raw_acc{k} = data.raw_acc{k}(:, mask);
            raw_gyro{k} = data.raw_gyro{k}(:, mask);            
        end
        data_static{i}.raw_acc = raw_acc;
        data_static{i}.raw_gyro = raw_gyro;
        data_static{i}.array_time = data.time(mask);
    end
    
    % Dynamics 
    mask_dynamic = data.time > max(points);
    raw_acc = cell(4,1);
    raw_gyro = cell(4,1);
    for k = 1:4
        raw_acc{k} = data.raw_acc{k}(:, mask_dynamic);
        raw_gyro{k} = data.raw_gyro{k}(:, mask_dynamic);
    end
    dynamics.array_time = data.time(mask_dynamic);
    dynamics.raw_acc = raw_acc;
    dynamics.raw_gyro = raw_gyro;
    
    data_filt.dynamics = dynamics;
    data_filt.statics = data_static;
end