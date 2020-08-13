function scaled_acc = scale_raw_acc(raw_acc)
%scale_raw_acc Scale raw_acc to m/s^2
    scale_acc  = 1/2048*9.80665;
    scaled_acc = raw_acc.*scale_acc;
end

