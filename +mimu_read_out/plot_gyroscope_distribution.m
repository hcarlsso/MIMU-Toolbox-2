function plot_gyroscope_distribution(data, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    N_sensors = size(data, 1);
    N_samples = size(data, 2);
    
    p = inputParser;
    addParameter(p, 'saturation', 2000);    
    parse(p,varargin{:});
    
    inds_gyro = sort([4:6:N_sensors, 5:6:N_sensors, 6:6:N_sensors]);
    
    data_gyro = data(inds_gyro, :);
    
    figure(); 
    set(gcf,'WindowStyle','docked')
    histogram(data_gyro(:))
    
    hold on ;
    lim = ylim;
    plot(p.Results.saturation*ones(2,1), lim, "-r")
    plot(-p.Results.saturation*ones(2,1), lim, "-r")
    
    N_array_sat = sum(any(abs(data_gyro) > p.Results.saturation, 1));
    title(strcat('# Samples ', num2str(N_samples),...
        ' # Sat', num2str(N_array_sat),...
        ' #Useful', num2str(N_samples-N_array_sat)));
end