function plot_static_data(ds)

    % acc
    figure(5);
    clf;
    direction = 'xyz';
    for j = 1:3
        subplot(410 + j)
        hold on;
        for i = 1:length(ds)
            plot(ds{i}.time, ds{i}.raw_acc(j:3:end,:))
           
        end
        title(direction(j))
        

    end
    
    % Plot norm gyro
    subplot(414)
    hold on;
    for i = 1:length(ds)
        plot(ds{i}.time, sqrt(sum(ds{i}.raw_acc.^2, 1)))
        
    end
    title('Norm gyro')
end
