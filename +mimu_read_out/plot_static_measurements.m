function plot_static_measurements(calibration_measurements)
%PLOT_STATIC_MEASUREMENTS Summary of this function goes here
%   Detailed explanation goes here
    all_measurements = cat(2, calibration_measurements{:});
    mimu_read_out.plot_inertial_data(all_measurements)

end

