function inertial_data_rot = rotate_measurements(inertial_data, C_nom) 

    nr_imus = size(C_nom, 1);
    
    assert(nr_imus == size(inertial_data,1)/6)
 
    % Convert to double precision    
    inertial_data_rot = zeros(size(inertial_data));
    for i=0:nr_imus-1
        % First block is Acc and second block is gyroscopes
        R = [reshape(C_nom(i+1,1:9),3,3) zeros(3); zeros(3) reshape(C_nom(i+1,10:18),3,3)];
        
        % Add all measurements in same frame
        inertial_data_rot(i*6+(1:6),:) = R*inertial_data(i*6+(1:6),:);
    end
 end