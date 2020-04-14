function sig_plotit(data, sub, tvec, signal, idx, channel)

if isfield(data, 'play_list') == 1
    play_list = data.play_list; % many signals to plot
else
    play_list = 0; % only one signal to plot
end

if idx == 0 | play_list == 0 % case a new window is desired for each signal
    
    figure('Name', ['File: ', data.fileName, ', Channel: ', channel , ', sub: ', num2str(sub)]); % opens a new figure window
    
    plot(tvec, signal); %, 'Color', [0.68,0.83,0.07]);
    title(['Video number: ' num2str(sub)]);
    xlabel('Time [sec]'); 
    xlim([0, tvec(end)]);
    axis on;
    if strcmp(channel,'IR') == 1
        ylabel('Temperature [C]');
    else
        ylabel('Gray level');
    end
        
elseif play_list ~= 0 % case need to perform subplots
    
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

        plot(tvec(current_vid,1:first_zero), signal(play_list(current_vid,5):play_list(current_vid,6))); % plot the signal
        title(['Video number: ' num2str(current_vid)]); % print signal's title
        xlabel('Time [sec]');
        xlim([0, tvec(current_vid,first_zero)]); % set x axis limit
        axis on;
        if strcmp(channel,'IR') == 1
            ylabel('Temperature [C]');
        else
            ylabel('Gray level');
        end
               
    end 
    
end

end