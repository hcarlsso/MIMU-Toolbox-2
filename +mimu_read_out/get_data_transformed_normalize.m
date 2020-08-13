function data = get_data_transformed_normalize(filename)
    import mimu_read_out.*
    data1 = get_data_binary_file(filename);
    data = parse_0x28(data1, 52);
     
    data.time_stamps_corr = correct_time_stamps(data.time_stamps);
    
    % Offset time
    data.time_stamps_offset = data.time_stamps_corr - data.time_stamps_corr(1);

    % Calculate time in seconds 
    % Clock frequency of IMU, 64 MHz
    data.time = double(data.time_stamps_offset)/64e6;
    

    % Rotate array
    % data = rotate_array(data);
end