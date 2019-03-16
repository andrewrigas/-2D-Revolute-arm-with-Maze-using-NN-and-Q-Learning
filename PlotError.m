function PlotError(error,bins)

    figure
    hold on
    h = histogram(error,bins);
    h = title('ISH: Error processing Histogram')
    set(h, 'FontSize', 18);
    h = xlabel('Data point Value')
    set(h, 'FontSize', 15);
    h = ylabel('Data point occurrences')
    set(h, 'FontSize', 15);
    
end