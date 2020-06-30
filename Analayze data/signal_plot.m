function signal_plot(data, channel, sub, frame_plot, filter_type, cutoff_freq)

exp_num = numel(data); % find number of videos in recieved data
batch = 1;
sub_count = 1;
counter = 1;

if length(cutoff_freq) == 1
    lambda = [num2str(cutoff_freq), ' Hz'];
else
    lambda = [num2str(cutoff_freq(1)), '-', num2str(cutoff_freq(end)), ' Hz'];
end

if strcmp(filter_type, 'dc')
    str = ['File: ', data{1}.file_name, ', Channel: ', data{1, 1}.type ,', Filter: ', num2str(filter_type),...
        ', Batch: ', num2str(batch)];
else
    str = ['File: ', data{1}.file_name, ', Channel: ', data{1, 1}.type ,', Filter: ', num2str(filter_type),...
        ', \lambda: ', lambda, ', Batch: ', num2str(batch)];
end

for k=1:size(data{1, 1}.sig, 2)
    leg_list(k).value = ['ROI ', num2str(k)];
end

figure('Name', str); % opens a new figure window
sgtitle(str); % plots the idx-title

for i=1:exp_num
    
    if ~isempty(data{i})
        
        var_name = [extractBefore(data{i}.var_name, '_'), '\_', extractAfter(data{i}.var_name, '_')];
        eval(['signal = data{i}.', channel, ';']); % get the desired signal
        frame_rate = data{i}.play_list(data{i}.play_order, 8);
        tvec = linspace(0, length(signal), length(signal)) ./ frame_rate; % create the time axis vector
        tvec = tvec + data{i}.start_time;
        
        if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'
            signal = filterit(signal, frame_rate, filter_type, cutoff_freq, 1);
        end
        
        subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot
        
        plot(tvec, signal); % plot the signal

        if i == 1 || i == counter % second term not relevant
            legend(leg_list.value,'Position',[-0.02, 0.8, 0.15, 0.15]);
        end
        
        title(['Video file: ', var_name]); % print signal's title
        xlabel('Time [sec]');
        xlim([0, tvec(end)]); % set x axis limit
        axis on;
        
        if strcmp(channel,'IR') == 1
            ylabel('Temperature [C]');
        else
            ylabel('Gray level');
        end
        
        sub_count = sub_count + 1;
        if mod(counter,sub) == 0 && counter ~= exp_num % second term might not be relevant
            
            legend(leg_list.value,'Position',[-0.02, 0.8, 0.15, 0.15]);
            batch = batch + 1;
            sub_count = 1;
            if strcmp(filter_type, 'dc')
                str = ['File: ', data{1}.file_name, ', Channel: ', data{1, 1}.type ,', Filter: ', num2str(filter_type),...
                    ', Batch: ', num2str(batch)];
            else
                str = ['File: ', data{1}.file_name, ', Channel: ', data{1, 1}.type ,', Filter: ', num2str(filter_type),...
                    ', \lambda: ', lambda, ', Batch: ', num2str(batch)];
            end
            figure('Name', str); % opens a new figure window
            sgtitle(str); % plots the idx-title
            
        end
        counter = counter + 1;
    end
    
end

if frame_plot == 1
    
    batch = 1;
    sub_count = 1;
    counter = 1;
    if strcmp(filter_type, 'dc')
        str = ['File: ', data{1}.file_name, ', Channel: ', data{1, 1}.type ,', Filter: ', num2str(filter_type),...
            ', Batch: ', num2str(batch)];
    else
        str = ['File: ', data{1}.file_name, ', Channel: ', data{1, 1}.type ,', Filter: ', num2str(filter_type),...
            ', \lambda: ', lambda, ', Batch: ', num2str(batch)];
    end
    figure('Name', str); % opens a new figure window
    %sgtitle(str); % plots the idx-title
    
    for i=1:1:exp_num
        
        if ~isempty(data{i})
            
            var_name = [extractBefore(data{i}.var_name, '_'), '\_', extractAfter(data{i}.var_name, '_')];
            
            subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot
            
            imshow(data{i}.last_frame,[])
            title(['Video file: ', var_name]); % print signal's title
            
            sub_count = sub_count + 1;
            if mod(counter,sub) == 0 && counter ~= exp_num
                batch = batch + 1;
                sub_count = 1;
                if strcmp(filter_type, 'dc')
                    str = ['File: ', data{1}.file_name, ', Channel: ', data{1, 1}.type ,', Filter: ', num2str(filter_type),...
                        ', Batch: ', num2str(batch)];
                else
                    str = ['File: ', data{1}.file_name, ', Channel: ', data{1, 1}.type ,', Filter: ', num2str(filter_type),...
                        ', \lambda: ', lambda, ', Batch: ', num2str(batch)];
                end
                figure('Name', str); % opens a new figure window
                sgtitle(str); % plots the idx-title
            end
            
            counter = counter + 1;
            
        end
        
    end
    
end

end


