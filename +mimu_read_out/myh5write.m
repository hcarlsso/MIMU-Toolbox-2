function myh5write(filename, path, data)
%MYH5WRITE Wrapper of h5write
    h5create(filename, path, size(data));
    h5write(filename, path, data);
end

