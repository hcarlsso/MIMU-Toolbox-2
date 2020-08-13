function [t_out,a_out,g_out] = get_data_transformed(filename)

    data1 = get_data_binary_file(filename);
    data = parse_0x28(data1, 52);
     
    t = data.time;
    a = data.raw_acc;
    g = data.raw_gyro;
    
    % Do not normalize time
    t_out = t;
    a_out = zeros(size(a));
    g_out = zeros(size(g));
    
    % Different transformations for differnt IMUs indeces
    A_24 = [0 -1 0; 
            1 0 0;
            0 0 1];
    A_13 = [1 0 0;
            0 -1 0;
            0 0 -1];
    
    a_out(:,2,:) = A_24*squeeze(a(:,2,:));
    a_out(:,4,:) = A_24*squeeze(a(:,4,:));
    
    g_out(:,2,:) = A_24*squeeze(g(:,2,:));
    g_out(:,4,:) = A_24*squeeze(g(:,4,:));
    
    a_out(:,1,:) = A_13*squeeze(a(:,1,:));
    a_out(:,3,:) = A_13*squeeze(a(:,3,:));
    
    g_out(:,1,:) = A_13*squeeze(g(:,1,:));
    g_out(:,3,:) = A_13*squeeze(g(:,3,:));
end
    