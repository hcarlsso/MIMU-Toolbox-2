function R = rotation_matrix(theta_x, theta_y, theta_z)

Rx = [  
    1               0               0
    0               cosd(theta_x)   -sind(theta_x)
    0               sind(theta_x)   cosd(theta_x)
    ];
    
Ry = [
    cosd(theta_y)   0               sind(theta_y)
    0               1               0
    -sind(theta_y)  0               cosd(theta_y)
    ];

Rz = [
    cosd(theta_z)   -sind(theta_z)  0
    sind(theta_z)   cosd(theta_z)   0
    0               0               1   
    ];
    
  
R = Rz*Ry*Rx;

end