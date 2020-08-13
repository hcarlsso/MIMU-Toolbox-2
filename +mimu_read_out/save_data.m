function save_data(dd, ds)


    filename = 'data.hdf';
    
    write_data(filename, '/dynamic/raw_acc', dd.raw_acc)
    write_data(filename, '/dynamic/raw_gyro', dd.raw_gyro)
    write_data(filename, '/dynamic/raw_gyrod', dd.raw_gyrod)
    
    for i = 1:length(ds)
        write_data(filename, ['/static/raw_acc/' num2str(i)] , ds{i}.raw_acc)
        write_data(filename, ['/static/raw_gyro/' num2str(i)], ds{i}.raw_gyro)
    end
end

function write_data(filename, path, data)

    h5create(filename, path, size(data));
    h5write(filename, path , data);
    
end