function [inertial_data_re] = reorder_measurements(inertial_data, active_imus)
%For 32 IMU measurements
% The pairs (1,2) and (31,32) are switched
P = zeros(32);

P(3:30,3:30) = eye(28);
P(1,2) = 1;
P(2,1) = 1;
P(31,32) = 1;
P(32,31) = 1;

P_use = P(active_imus, active_imus);

% Acc triad and gyro triad: 6 measurements.
P_tot = kron(P_use, eye(6));

inertial_data_re = P_tot*inertial_data;
end

