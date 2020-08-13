import mimu_read_out.*
% Settings 
path = '2020-08-11_17-47-static-icosahedron-dynamic-random/';

suffix = sprintf('_%02i%02i%02i_%02i%02i%02i',fix(clock()));
filename_data = [path 'data.bin'];
% filename_data = 'temp_raw_data.bin';
filename_settings = [path 'settings.m'];
% target_board = 'MIMU4444';      % MIMU22BT, MIMU3333, MIMU4444, MIMU4444BT

run(filename_settings)

%% Parse recorded data
% [inertial_data,time_stamps,raw_data]=mimu_parse_bin(filename,uint8(nr_imus));
[inertial_data,time_stamps,raw_data]=mimu_read_out.parsers.mimu_parse_bin(filename_data,uint8(nr_imus));
inertial_data_double = double(inertial_data);

inertial_data_double = mimu_read_out.scale_measurements(inertial_data_double);
mimu_read_out.plot_inertial_data(inertial_data_double);

%% Fix time 
mimu_read_out.plot_time_stamps(time_stamps);
time_stamp_corr = mimu_read_out.correct_time_stamps(time_stamps);

mimu_read_out.plot_inertial_data(inertial_data_double, 'time', time_stamp_corr);

%% Rotate to same frame
[~, C_nom] = mimu_read_out.board_settings(target_board);
C_nom_selection = C_nom(active_imus,:);
inertial_data_double_rot = mimu_read_out.rotate_measurements(inertial_data_double, C_nom_selection);
mimu_read_out.plot_inertial_data(inertial_data_double_rot);

%%
% n_sample = 0;
%%

if n_sample == 0
    [static, dynamic, n_sample] = mimu_read_out.separate_static_and_dynamic(inertial_data_double_rot);
else
    [static, dynamic, n_sample] = mimu_read_out.separate_static_and_dynamic(inertial_data_double_rot, ...
        'n_sample', n_sample);
end

time_dynamic = time_stamp_corr(n_sample+1:end);

%% Processing  static measurements 
[calibration_measurements, side_counter] = mimu_read_out.extract_stationary_segments(...
    static, 'threshold_factor', threshold_factor, 'min_period', min_period,...
    'min_diff_of_sets', min_diff_of_sets);


%% Show the static measurements
mimu_read_out.plot_static_measurements(calibration_measurements);


%% Show dynamic measurements 
mimu_read_out.plot_inertial_data(dynamic, 'time', time_dynamic);

%% Save the data

if true
    filename_data = 'measurements_static_and_dynamic';
    data_processed_path = strjoin([path filename_data ".hdf"],"");
    for i = 1:length(calibration_measurements)
        myh5write(data_processed_path,...
            sprintf('/static/%02d', i), ...
            calibration_measurements{i});
    end
    myh5write(data_processed_path,'/dynamic/measurements', dynamic);
    myh5write(data_processed_path,'/dynamic/time', time_dynamic);

    h5writeatt(data_processed_path,'/','active_imus',active_imus)
end