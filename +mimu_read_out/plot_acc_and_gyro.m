function plot_acc_and_gyro(a1,a2)


figure(2);
clf;

plot_data(a2.time, a1.raw_acc, a2.raw_acc)
sgtitle('Acc Raw') 

figure(3);
clf;

plot_data(a2.time, a1.raw_gyro, a2.raw_gyro)
sgtitle('Gyro Raw') 

figure(4);
clf;
plot_data(a2.time, a1.raw_gyrod, a2.raw_gyrod)
sgtitle('Gyro derivative Raw ') 

end

function plot_data(time, a1_data, a2_data)
direction = 'xyz';
axes = cell(3,1);
for m = 1:3
    axes{m} = subplot(3,1,m);
    hold on;
    % IMUs
    for i = 1:4
        % Array 1
        y1=squeeze(a1_data(m,i,:));
        plot(time, y1, '--',...
            'MarkerIndices',i:8:length(y1), ...
            'DisplayName',['Array 1, Imu ' num2str(i)],...
            'MarkerSize',10)
    end
    
    % Array 2
    % IMUs
    for i = 1:4
        y2 = squeeze(a2_data(m,i,:));
        plot(time, y2,'-',...
            'MarkerIndices',(i+4):8:length(y2),...
            'DisplayName',['Array 2, Imu ' num2str(i)],...
            'MarkerSize',10)
    end
    title(['Direction ' direction(m)])
    legend();
end
xlabel('[s]')
linkaxes([axes{:}])
end