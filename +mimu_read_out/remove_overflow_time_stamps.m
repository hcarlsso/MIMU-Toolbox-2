function T = remove_overflow_time_stamps(time_stamps)

    % Account for overflow in 
    dt = diff(time_stamps);
    for i=1:numel(dt)
        if dt(i)<0
            dt(i) = dt(i)+2^32;
        end
    end
    % Assume sampled in 64MHz 
    % Time starts at zero
    T  = [0; cumsum(dt)];
end

