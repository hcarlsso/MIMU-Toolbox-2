function time_stamps_corr = correct_time_stamps(time_stamps)
    % Returns time in seconds, limitation to 4e9 values, then have to 
    % convert to double before cumsum
    
    assert(isa(time_stamps,'uint32'))
    
    % unit32 cannot hold large enough values
    time_stamps_64 = uint64(time_stamps);
    time_stamps_64_corr = zeros(size(time_stamps_64),'uint64');
    time_stamps_64_corr(1) = time_stamps_64(1);
    % account for overflow
    % dt = diff(time_stamps_64);
    k = 0; % counter for number of overflows
    M32 = 2^32 - 1;
    for i=2:length(time_stamps_64)
        if time_stamps_64(i) < time_stamps_64(i-1)
            k = k + 1;
            time_stamps_64_corr(i) = k*M32 + time_stamps_64(i);
        elseif time_stamps_64(i) > time_stamps_64(i-1)
            time_stamps_64_corr(i) = k*M32 + time_stamps_64(i);
        else
            error("Time-stamps are equal")
        end
    end
    
    assert(all(diff(time_stamps_64_corr) > 0))
    % Convert to seconds
    % Clock frequency of IMU, 64 MHz
    time_stamps_corr = double(time_stamps_64_corr)/64e6;
    

end