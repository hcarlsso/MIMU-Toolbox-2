function data = get_data_binary_file(filename)

    file = fopen(filename,'r');
    data = fread(file);
    fclose(file);
end