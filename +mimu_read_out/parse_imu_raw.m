function [raw_acc, raw_gyro] = parse_imu_raw(data)
% Have to convert 
% x = [255 67];
% y = typecast(uint8(x), 'uint16');
% Sensor is big endian, computer is little endin, thus swap bytes

    assert(mod(length(data),(2*6)) == 0)
    
    % 2 unit8 makes 1 int16
    data_uint8 = uint8([data(1:2:end) data(2:2:end)]);
    
    nof_int16 = length(data)/2;
    data_int16 = zeros(nof_int16,1,'int16');
    
    
    for n = 1:nof_int16
        data_int16(n) = convert_uint8_to_int16(...
            data_uint8(n,:));
    end
    
    raw_acc = [...
        data_int16(1:6:end),...
        data_int16(2:6:end),...
        data_int16(3:6:end)]';
    
    raw_gyro = [...
        data_int16(4:6:end),...
        data_int16(5:6:end),...
        data_int16(6:6:end)]';
    
end

function y = convert_uint8_to_int16(x)
    temp = typecast(uint8(x), 'int16');
    y = swapbytes(temp);
    %y = temp;
end