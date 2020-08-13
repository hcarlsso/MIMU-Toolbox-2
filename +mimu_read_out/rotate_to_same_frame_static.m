function meas_same_frame = rotate_to_same_frame_static(meas, C_nom, scale_acc, scale_gyro)  
    import mimu_read_out.rotate_to_same_frame
    L = length(meas);
    meas_same_frame = cell(L,1);
    
    for l=1:L
        meas_same_frame{l} = rotate_to_same_frame(meas{l}, C_nom, scale_acc, scale_gyro);
    end
        
end