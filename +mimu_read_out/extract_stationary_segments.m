function [calibration_measurements,side_counter]=extract_stationary_segments(inertial_data, varargin)
% Assume that they all are rotated to same frame and scaled
    p = inputParser;
    
    addParameter(p,'half_window_size', 25, @(x) x > 0);
    addParameter(p,'min_period', 50, @(x) x > 0);
    addParameter(p,'max_period', 300, @(x) x > 0);
    addParameter(p,'threshold_factor', 2, @(x) x > 0);
    addParameter(p,'min_diff_of_sets', 500, @(x) x > 0);

    
    parse(p,varargin{:});
    
    half_window_size = p.Results.half_window_size;
    min_period = p.Results.min_period;
    max_period = p.Results.max_period;
    threshold_factor = p.Results.threshold_factor;
    min_diff_of_sets = p.Results.min_diff_of_sets;
    
    fprintf('Half window size: %d\n', half_window_size);
    fprintf('Min period: %d\n', min_period);
    fprintf('Max period: %d\n', max_period);
    fprintf('Threshold factor: %.2f\n', threshold_factor);
    fprintf('Min diff of sets: %d\n', min_diff_of_sets);
    
    nr_imus = size(inertial_data,1)/6;
    nr_data = size(inertial_data,2);
    inertial_data_double=double(inertial_data);
    comb_inert = zeros(6,nr_data);
    for i=0:nr_imus-1
        % Add all measurements in same frame
        comb_inert = comb_inert + inertial_data_double(i*6+(1:6),:);
    end
    
    window_size = 2*half_window_size+1;
    running_mean = zeros(size(comb_inert));
    running_var = zeros(size(comb_inert));
    comb_inert = [zeros(6,half_window_size) comb_inert zeros(6,half_window_size)];
    
    % Calculate running mean
    running_mean(:,1) = sum(comb_inert(:,1:window_size),2);
    for i = 2:nr_data
        running_mean(:,i) = running_mean(:,i-1) + ( comb_inert(:,i-1+window_size) - comb_inert(:,i-1) );
    end
    running_mean = running_mean/window_size;
    
    % Calculate variance
    for i=1:nr_data
        running_var(:,i) = sum((comb_inert(:,i:i+window_size-1)-repmat(running_mean(:,i),1,window_size)).^2,2);
    end
    
    % Select minimi level och combine
    min_var=min(running_var,[],2);    
    stat = (min_var'.^-1)*running_var;
    threshold = threshold_factor*min(stat);
    
    larger = stat>threshold;
    smaller = stat<=threshold;
    stop = find(larger(2:end) & smaller(1:end-1));
    start = find(smaller(2:end) & larger(1:end-1));
    nr_sides = numel(start);
    fprintf("Found %d potential condidates\n", nr_sides);
    
    selected = zeros(nr_sides,1);
    calibration_measurements = cell(nr_sides,1);
    start_and_end_points = zeros(nr_sides,2);
    side_counter=0;
    if stop(1)-start(1)>min_period
        side_counter = side_counter+1;
        selected(1)=1;
        if stop(1)-start(1)<max_period
            calibration_measurements{side_counter}=inertial_data(:,start(1):stop(1));
            start_and_end_points(side_counter,:) = [start(1) stop(1)];
        else
            calibration_measurements{side_counter}=inertial_data(:,start(1):start(1)+max_period);
            start_and_end_points(side_counter,:) = [start(1) start(1)+max_period];
        end
        fprintf("Region %d: 1\n", 1)
    else
        fprintf("Region %d: 0\n", 1)
    end
    for i=2:nr_sides
        if stop(i)-start(i)>min_period
            last_chosen=find(selected,1,'last');
            if ~isempty(last_chosen)
                % check that we don't have two of the same orientation in a row
                difference = sum(abs(running_mean(1:3,stop(last_chosen))-running_mean(1:3,start(i))));
                fprintf("Region %d diff: %.3e\n", i, difference)
                if difference > min_diff_of_sets
                    side_counter = side_counter+1;
                    selected(i)=1;
                else
                    % check which period to chose
                    if stop(i)-start(i)<stop(last_chosen)-start(last_chosen)
                        fprintf("Region %d: 0, too similar to %d (also longer)\n", i, i-1)
                        continue;
                    else
                        fprintf("Region %d: 0, too similar to %d (but is smaller)\n", i, i-1)
                    end
                end
            else
                side_counter = side_counter+1;
                selected(i)=1;
            end
            if stop(i)-start(i)<max_period
                calibration_measurements{side_counter}=inertial_data(:,start(i):stop(i));
                start_and_end_points(side_counter,:) = [start(i) stop(i)];
            else
                calibration_measurements{side_counter}=inertial_data(:,start(i):start(i)+max_period);
                start_and_end_points(side_counter,:) = [start(i) start(i)+max_period];
            end
            fprintf("Region %d: 1\n", i)
        else
            fprintf("Region %d: 0, too short\n", i)
        end        
    end
    fprintf("Number of selected regions: %d\n", side_counter)
    if side_counter~=nr_sides
        calibration_measurements = calibration_measurements(1:side_counter);
        start_and_end_points = start_and_end_points(1:side_counter,:);
    end

    comb_inert = comb_inert(:,half_window_size+1:end-half_window_size);
    
    % Plotting 
    figure(1), clf
    set(gcf,'WindowStyle','docked')
    grid on
    handles = cell(2,1);
    % Acc
    handle=subplot(2,1,1);
    cla(handle), hold on, grid on
    title('Selected periods -- accelerometer readings');
    xlabel('sample number')
    ylabel('a [m/s^2]');
    plot(comb_inert(1:3,:)'/nr_imus);
    plot(running_mean(1:3,:)'/nr_imus,'k');
    ylim=get(gca,'YLim');
    xlim=get(gca,'XLim');
    patch([0 0 start(1) start(1)],[ylim(2) ylim(1) ylim(1) ylim(2)],ones(1,4),'FaceColor','r','facealpha',0.2);
    for i=2:numel(stop)
        patch([stop(i-1) stop(i-1) start(i) start(i)],[ylim(2) ylim(1) ylim(1) ylim(2)],ones(1,4),'FaceColor','r','facealpha',0.2);
    end
    patch([stop(end) stop(end) xlim(2) xlim(2)],[ylim(2) ylim(1) ylim(1) ylim(2)],ones(1,4),'FaceColor','r','facealpha',0.2);
    for i=1:size(start_and_end_points,1)
        patch([start_and_end_points(i,1) start_and_end_points(i,1) start_and_end_points(i,2) start_and_end_points(i,2)],[ylim(2) ylim(1) ylim(1) ylim(2)],ones(1,4),'FaceColor','b','facealpha',0.2);
    end
    handles{1} = handle;
    
    % Gyro
    handle=subplot(2,1,2);
    cla(handle), hold on, grid on
    title('Selected periods -- gyroscope readings');
    xlabel('sample number')
    ylabel('\omega [deg/s]');
    plot(comb_inert(4:6,:)'/nr_imus);
    plot(running_mean(4:6,:)'/nr_imus,'k');    
    ylim=get(gca,'YLim');
    xlim=get(gca,'XLim');
    patch([0 0 start(1) start(1)],[ylim(2) ylim(1) ylim(1) ylim(2)],ones(1,4),'FaceColor','r','facealpha',0.2);
    for i=2:numel(stop)
        patch([stop(i-1) stop(i-1) start(i) start(i)],[ylim(2) ylim(1) ylim(1) ylim(2)],ones(1,4),'FaceColor','r','facealpha',0.2);
    end
    patch([stop(end) stop(end) xlim(2) xlim(2)],[ylim(2) ylim(1) ylim(1) ylim(2)],ones(1,4),'FaceColor','r','facealpha',0.2);
    for i=1:size(start_and_end_points,1)
        patch([start_and_end_points(i,1) start_and_end_points(i,1) start_and_end_points(i,2) start_and_end_points(i,2)],[ylim(2) ylim(1) ylim(1) ylim(2)],ones(1,4),'FaceColor','b','facealpha',0.2);
    end
    
    handles{2} = handle;
    linkaxes([handles{:}],'x');
    
    
    figure(2), clf
    set(gcf,'WindowStyle','docked')
    subplot(2,1,1);
    plot(running_var(1:3,:)');
    grid on
    subplot(2,1,2);
    plot(running_var(4:6,:)');
    grid on
    
    figure(3),clf
    set(gcf,'WindowStyle','docked')
    plot(stat)
    hold on
    
    plot(threshold*ones(size(stat)), 'r')
    grid on
    set(gca, "YScale", "log")

    legend("Runnning variance", "Threshold")
end

