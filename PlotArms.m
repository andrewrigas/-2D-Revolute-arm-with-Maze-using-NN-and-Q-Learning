 function PlotArms(P1,P2,origin,samples)
        % Filling a collumn with X and Y Start points Origin possition
        Xstart = repmat(origin(1),samples,1);
        Ystart = repmat(origin(2),samples,1);

        %Creating Matrixes for connect lines Between origin - 
        Xcon = [P1(:,1) P2(:,1)];
        Ycon = [P1(:,2) P2(:,2)];
        OXcon = [Xstart P1(:,1)];
        OYcon = [Ystart P1(:,2)];
    
        figure
        hold on
        h = title('ISH: Arm configurations')
        set(h, 'FontSize', 18);
        h = xlabel('x[m]')
        set(h, 'FontSize', 15);
        h = ylabel('y[m]')
        set(h, 'FontSize', 15);
        h = plot(origin(1),origin(2),'k*');
        set(h, 'MarkerSize', 14);
        set(h, 'LineWidth', 2);
        h = plot(P2(:,1),P2(:,2),'ro');
        set(h, 'MarkerSize', 5);
        set(h, 'LineWidth', 3);
        h = plot(P1(:,1),P1(:,2),'go');
        set(h, 'MarkerSize', 5);
        set(h, 'LineWidth', 3);
        h = plot(Xcon',Ycon','b-');
        set(h, 'LineWidth', 2);
        h = plot(OXcon',OYcon','b-');
        set(h, 'LineWidth', 2);
        legend('Origin','End point');
end