function [static, dynamic, n_sample] = separate_static_and_dynamic(inertial_data, varargin)
%SEPARATE_STATIC_AND_DYNAMIC Summary of this function goes here
%   Assume dynamic samples are after static.


    p = inputParser;
    addParameter(p,'n_sample', 0);
    addParameter(p,'n_sample_end', 0);
    parse(p,varargin{:});
    

    nr_imus = size(inertial_data,1)/6;
    nr_data = size(inertial_data,2);
    inertial_data_double=double(inertial_data);
    comb_inert = zeros(6,nr_data);
    for i=0:nr_imus-1
        % Add all measurements in same frame
        comb_inert = comb_inert + inertial_data_double(i*6+(1:6),:);
    end

    figure()
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
    handles{1} = handle;
    
    % Gyro
    handle=subplot(2,1,2);
    cla(handle), hold on, grid on
    title('Selected periods -- gyroscope readings');
    xlabel('sample number')
    ylabel('\omega [deg/s]');
    plot(comb_inert(4:6,:)'/nr_imus);
    
    handles{2} = handle;
    linkaxes([handles{:}],'x');
    
    
    if p.Results.n_sample == 0    
        set(gcf,'CurrentCharacter',char(1));
        h=datacursormode;
        set(h,'DisplayStyle','datatip','SnapToData','off');
        disp("Choose point separating static and dynamic measurements, then press spacebar")
        waitfor(gcf,'CurrentCharacter',char(32));
        s = getCursorInfo(h);
        point = s.Position;
        
        n_sample = uint64(point(1));
    else
        n_sample = p.Results.n_sample;
        n_sample_end = p.Results.n_sample_end;
    end
        
    static = inertial_data(:,1:n_sample); 
    dynamic = inertial_data(:,n_sample+1:n_sample_end); 
    
end

