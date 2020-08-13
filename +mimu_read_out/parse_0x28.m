function data_parsed = parse_0x28(raw_data, Psize)

    import mimu_read_out.*
    
    if all(raw_data(1:2)== [hex2dec('A0'); hex2dec('28')]) && ...
            all(raw_data(3:4)' ==  calc_check_sum(raw_data(1:2)))
        ack_start = raw_data(1:4);
        raw_data_wo_start_ack = raw_data(5:end);
    else
        raw_data_wo_start_ack = raw_data;
        disp('No start header')
    end
    
    
    if all(raw_data_wo_start_ack(end-3:end-2)== [hex2dec('A0'); hex2dec('22')]) && ...
            all(raw_data_wo_start_ack(end-1:end)' ==  calc_check_sum(raw_data_wo_start_ack(end-3:end-2)))
        ack_end = raw_data_wo_start_ack(end-3:end);
        raw_data_wo_ack = raw_data_wo_start_ack(1:end-4);
    else
        raw_data_wo_ack = raw_data_wo_start_ack;
        disp('No end header')
    end
    
    % 8 for start ack and end ack 
    N_package = floor((length(raw_data_wo_ack))/(6 + Psize));

    time = zeros(N_package,1);
    header = zeros(N_package,1);
    pack_id = zeros(N_package,1);
    
    % Parse the firs to get N-imus
    % header 4, p header 4, time 4 bytes,
    p_indeces = 1:(6+Psize);
    offset = 0;
    [header(1), pack_id(1), time(1),raw_acc, raw_gyro] = ...
        parse_package(raw_data_wo_ack(p_indeces + offset),Psize);
    
    data_acc = zeros([size(raw_acc) N_package]);
    data_gyro = zeros([size(raw_acc) N_package]);
    
    data_acc(:,:,1) = raw_acc;
    data_gyro(:,:,1) = raw_gyro;
    
    offset = offset + 6+Psize;
    for n = 2:N_package
        while ~all(raw_data_wo_ack((1:2)+offset+Psize+4)' ==  calc_check_sum(raw_data_wo_ack((1:(Psize+4))+offset)))
            offset = offset +1;
            disp('Skip byte')
        end

        [header(n), pack_id(n), time(n),data_acc(:,:,n), data_gyro(:,:,n)] = ...
            parse_package(raw_data_wo_ack(p_indeces + offset), Psize);
        
        offset = offset + 6+Psize;
    end
    % Restructure the measurements 
    data_acc_struct = cell(4,1);
    data_gyro_struct = cell(4,1);
    
    for i = 1:4
        data_acc_struct{i} = squeeze(data_acc(:,i,:));
        data_gyro_struct{i} = squeeze(data_gyro(:,i,:));
    end
    
    % put in structure
    data_parsed.time_stamps = time;
    data_parsed.raw_acc = data_acc_struct;
    data_parsed.raw_gyro = data_gyro_struct;
    data_parsed.header = header;
    data_parsed.pack_id = pack_id;
end

function [h, N, t,a, g] = parse_package(data, Psize)
    import mimu_read_out.*
    h = data(1);
    N = calc_package_number(data(2), data(3));
    Psize_data = data(4);
    
    % early assertion
    if ~(Psize == Psize_data)
        warning("Payload size in msg %d != %d (defined payload size)", Psize_data, Psize)
    end
        
    t = convert_uint8_to_uint32(data(5:8));
    [a, g] = parse_imu_raw(data(9:end-2));

    ck_sum_rec = calc_check_sum(data(1:end-2));
    

    assert(all(ck_sum_rec' == data(end-1:end)))
    
end
    
function y = convert_uint8_to_uint32(x)
    temp = typecast(uint8(x), 'uint32');
    y = swapbytes(temp); % Account for little and big endian
end
