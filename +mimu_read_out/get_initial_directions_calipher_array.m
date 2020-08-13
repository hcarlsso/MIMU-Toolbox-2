function T = get_initial_directions_calipher_array()
    
    T = cell(8,1);
    
    k = 200;
    T{1} = k*eye(3);
    T{3} = k*eye(3);
    
    T{2} = k*rotation_matrix(-180, 0, -90);
    T{4} = k*rotation_matrix(-180, 0, -90);
    
    T{5} = k*rotation_matrix(0, 0, -90);
    T{7} = k*rotation_matrix(0, 0, -90);
    
    T{6} = k*rotation_matrix(-180, 0, 0);
    T{8} = k*rotation_matrix(-180, 0, 0);
end