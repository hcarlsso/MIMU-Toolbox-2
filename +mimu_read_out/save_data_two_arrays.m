function save_data_two_arrays(data, filename)


    delete(filename)
    
    for j = 1:2
        data_array = data{j};
        path_array = ['/array_' num2str(j)];
        
        % dynamics 
        path_dynamics = [path_array '/dynamics'];
        data_dynamics = data_array.dynamics;
        for k = 1:4
            raw_acc_k = data_dynamics.raw_acc{k};
            raw_gyro_k = data_dynamics.raw_gyro{k};
            
            path_acc_k = [path_dynamics '/raw_acc/imu_' num2str(k)];
            path_gyro_k = [path_dynamics '/raw_gyro/imu_' num2str(k)];
            
            write_data(filename, path_acc_k, raw_acc_k);
            write_data(filename, path_gyro_k, raw_gyro_k);
        end
        write_data(filename, [path_dynamics '/array_time'], data_dynamics.array_time)
        
        % statics
        statics = data_array.statics;
        path_statics = [path_array '/statics'];
        for i = 1:length(statics)
            data_statics = statics{i};
            path_statics_i = [path_statics sprintf('/direction_%02d',i)];
            % acc
            path_acc = [path_statics_i '/raw_acc'];
            for k = 1:4
                write_data(filename, [path_acc '/imu_' num2str(k)], data_statics.raw_acc{k})
            end
            % gyro
            path_gyro = [path_statics_i '/raw_gyro'];
            for k = 1:4
                write_data(filename, [path_gyro '/imu_' num2str(k)] , data_statics.raw_gyro{k})
            end
            write_data(filename, [path_statics_i '/array_time' ] , data_statics.array_time)
        end
    end    
end

function write_data(filename, path, data)

    if size(data,1) == 1
        h5create(filename, path, size(data,2));
        h5write(filename, path , data);
    else
        h5create(filename, path, size(data));
        h5write(filename, path , data);
    end
    
end
