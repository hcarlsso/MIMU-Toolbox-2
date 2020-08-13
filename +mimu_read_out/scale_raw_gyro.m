function scaled_gyro = scale_raw_gyro(raw_gyro)
%scale_raw_acc Scale raw_acc to deg/s
    scale_gyro = 1/16.4; 
    scaled_gyro = raw_gyro.*scale_gyro;
        
end
