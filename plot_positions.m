import mimu_read_out.*

pos = mimu_read_out.get_initial_positions();

%%
figure('Renderer', 'painters', 'Position', [10 10 900 600])

clf;
subplot(1,2,1)
fill([-0.0132,-0.0132,0.0133,0.0133],[-0.0133,0.0362,0.0362,-0.0133],'g');
hold on
ind=(pos(3,:)>0);
for i=1:numel(pos(1,:))
    if ind(i)
        h=fill(pos(1,i)+[-0.002,-0.002,0.002,0.002],pos(2,i)+[-0.002,0.002,0.002,-0.002],'k');
        set(h,'facealpha',.3)
        
        text(pos(1,i) + 0.0005,pos(2,i) +0.0015, num2str(i), 'FontSize', 8); 
    end
end
h(1)=plot(pos(1,ind),pos(2,ind),'k+');
h(2)=plot(pos(1,ind) - 1.5e-3,pos(2,ind) + 1.5e-3,'k.');
legend(h,'nom. top', "direction marker")
grid on, box on
axis equal
axis([-0.015 0.015 -0.015 0.038])
title("Topside (topview)")
xlabel('x-axis [m] ')
ylabel('y-axis [m]')

%%
subplot(1,2,2)
fill([-0.0132,-0.0132,0.0133,0.0133],[-0.0133,0.0362,0.0362,-0.0133],'g');
hold on
ind=(pos(3,:)<0);
for i=1:numel(pos(1,:))
    if ind(i)
        h=fill(pos(1,i)+[-0.002,-0.002,0.002,0.002],pos(2,i)+[-0.002,0.002,0.002,-0.002],'k');
        set(h,'facealpha',.3)
        
        text(pos(1,i) + 0.0005,pos(2,i) +0.0015, num2str(i), 'FontSize', 8); 
    end
end
h(1)=plot(pos(1,~ind),pos(2,~ind),'k+');
h(2)=plot(pos(1,ind) - 1.5e-3,pos(2,ind) + 1.5e-3,'k.');
legend(h,'nom. bottom', "Direction marker")
grid on, box on
axis equal
axis([-0.015 0.015 -0.015 0.038])
title("Topside (topview)")
xlabel('x-axis [m]')
ylabel('y-axis [m]')
title("Bottomside (topview)")