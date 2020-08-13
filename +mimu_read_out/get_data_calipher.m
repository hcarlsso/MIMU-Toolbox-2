function [a1_inter, a2] = get_data_calipher()

    % Transform to same frame
    % Interpolate to same time
    % Calculate gyro derivative 

    % new
    a1 = get_data_transformed_normalize('temp_1.bin');

    % old
    a2 = get_data_transformed_normalize('temp_2.bin');

    % rotate new IMU to frame of old IMU
%     R = rotation_matrix(0,0, -90);
%     for i = 1:4
%         a1.raw_acc(:,i,:) = R*squeeze(a1.raw_acc(:,i,:));
%         a1.raw_gyro(:,i,:) = R*squeeze(a1.raw_gyro(:,i,:));
%     end
    
    % Interpolate time of new one to old one 
    % Linear interpolation
    
    % Should not exceed max time of a1
    mask = a2.time < max(a1.time);
    ref_time = a2.time(mask);
    
    a1_inter.time = ref_time;
    a1_inter.raw_acc = zeros(3, 4, length(ref_time));
    a1_inter.raw_gyro = zeros(3, 4, length(ref_time));
    
    % IMU
    for i = 1:4
        % Direction
        for m = 1:3
            % Interpolate to same time
            x1 = a1.time;
            y1 = squeeze(a1.raw_acc(m,i,:));
            a1_inter.raw_acc(m,i,:) = interp1(x1, y1, ref_time, 'linear');
            
            y2 = squeeze(a1.raw_gyro(m,i,:));
            a1_inter.raw_gyro(m,i,:) = interp1(x1, y2, ref_time, 'linear');
           
        end
    end
    
    a2.raw_acc = a2.raw_acc(:,:,mask);
    a2.raw_gyro = a2.raw_gyro(:,:,mask);
    a2.time = ref_time;
    
    % Gyro derivative, endpoints are not calculated
    raw_gyrod1 = zeros(size(a1_inter.raw_gyro));
    raw_gyrod2 = zeros(size(a2.raw_gyro)); % Should be same size
    
    % IMU
    for i = 1:4
        for t = 2:length(ref_time) - 1
            dt = ref_time(t+1)-ref_time(t-1);
            raw_gyrod1(:,i,t) = ...
                (a1_inter.raw_gyro(:,i,t+1) - a1_inter.raw_gyro(:,i,t-1))/dt;
            
            raw_gyrod2(:,i,t) = ...
                (a2.raw_gyro(:,i,t+1) - a2.raw_gyro(:,i,t-1))/dt;
        end
    end
    
    a1_inter.raw_gyrod = raw_gyrod1;
    a2.raw_gyrod = raw_gyrod2;
end
