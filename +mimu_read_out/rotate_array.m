function data = rotate_array(data)

    % Rotate the IMUs to the same frame approximatly.

    % Different transformations for differnt IMUs indeces
    
    % Rotate 90 deg around z axis
    A_24 = [0 -1 0; 
            1 0 0;
            0 0 1];
    
    % Rotate 180 around x axis
    A_13 = [1 0 0;
            0 -1 0;
            0 0 -1];
    
    data.raw_acc(:,2,:) = A_24*squeeze(data.raw_acc(:,2,:));
    data.raw_acc(:,4,:) = A_24*squeeze(data.raw_acc(:,4,:));
    
    data.raw_gyro(:,2,:) = A_24*squeeze(data.raw_gyro(:,2,:));
    data.raw_gyro(:,4,:) = A_24*squeeze(data.raw_gyro(:,4,:));
    
    data.raw_acc(:,1,:) = A_13*squeeze(data.raw_acc(:,1,:));
    data.raw_acc(:,3,:) = A_13*squeeze(data.raw_acc(:,3,:));
    
    data.raw_gyro(:,1,:) = A_13*squeeze(data.raw_gyro(:,1,:));
    data.raw_gyro(:,3,:) = A_13*squeeze(data.raw_gyro(:,3,:));
    
end