function FFT_plotit(data, sub, tvec, signal, idx, channel, freq_limit, pow_limit)

if idx == 0 % case a new window is desired for each signal
    
    first_zero = find(tvec(1,2:end)==0,1); % find the coordinate of the end of the time vector
    
    if isempty(first_zero) == 1
        first_zero = length(tvec); % special case in which this is the longest time vector
    end
    
    figure('Name', ['File: ', data.fileName, ', Channel: ', channel , ', sub: ', num2str(sub)]); % opens a new figure window
    
    plot(tvec(1:first_zero), signal(1:first_zero)); %, 'Color', [0.68,0.83,0.07]);
    title(['Video number: ' num2str(sub)]);
    xlabel('Frequency [Hz]'); ylabel('Power [R.U]');
    hold on;
    axis on;
    
    if numel(freq_limit) == 2
        xlim(freq_limit);
    else
        xlim([tvec(1), tvec(first_zero)]);
    end
    
    if numel(pow_limit) == 2
        ylim(pow_limit);
    end
    
else % case need to perform subplots
    
    str = ['File: ', data.fileName, ', Channel: ', channel ,', Batch: ', num2str(idx)];
    figure('Name', str); % opens a new figure window
    sgtitle(str); % plots the idx-title
    
    first = idx*sub - sub + 1;
    
    for j=1:sub
        
        current_vid = first + j - 1; % current video being ploted
        
        if current_vid > size(tvec,1)
            break; % stop loop in case there's no more videos to plot
        end
        
        first_zero = find(tvec(current_vid,2:end)==0,1); % find the coordinate of the end of the time vector
        
        if isempty(first_zero) == 1
            first_zero = length(tvec); % special case in which this is the longest time vector
        end
        
        subplot(ceil(sqrt(sub)),round(sqrt(sub)),j); % create subplot
        
        plot(tvec(current_vid,1:first_zero), signal(current_vid,1:first_zero)); % plot the signal
        title(['Video number: ' num2str(current_vid)]); % print signal's title
        xlabel('Frequency [Hz]'); ylabel('Power [R.U]');
        hold on;
        axis on;
        
        if numel(freq_limit) == 2 % set x axis limits
            xlim(freq_limit);
        else
            xlim([tvec(1), tvec(first_zero)]);
        end
        
        if numel(pow_limit) == 2 % set y axis limits
            ylim(pow_limit);
        end
        
    end
    
end

end