function plotEndPoints(origin,P2)
    figure
    hold on
    h = title('ISH: Trained Neural Network Endpoint locations')
    set(h, 'FontSize', 18);
    h = xlabel('x[m]')
    set(h, 'FontSize', 15);
    h = ylabel('y[m]')
    set(h, 'FontSize', 15);
    h = plot(origin(1),origin(2),'k*');
    set(h, 'MarkerSize', 12);
    set(h, 'LineWidth', 2);
    h = plot(P2(:,1),P2(:,2),'r*');
    set(h, 'LineWidth', 2);
    set(h, 'MarkerSize',2);
    legend('Origin','End point');
    
end