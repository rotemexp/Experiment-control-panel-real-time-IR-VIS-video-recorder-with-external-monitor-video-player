function signal_plot(data, channel, sub, frame_plot, filter_type, cutoff_freq)

exp_num = numel(data); % find number of videos in recieved data

batch = 1;
sub_count = 1;
str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Batch: ', num2str(batch)];
figure('Name', str); % opens a new figure window
sgtitle(str); % plots the idx-title

for i=1:1:exp_num
    
    video_num = data{i}.vid_num;
    eval(['signal = data{i}.', channel, ';']); % get the desired signal
    frame_rate = data{i}.play_list(video_num,8);
    tvec = linspace(0, length(signal), length(signal)) ./ frame_rate; % create the time axis vector
    tvec = tvec + data{i}.start_time;
    
    if size(signal, 1) ~= 1
        signal = signal';
    end
    
    if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
            strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
            strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no' 
        signal = filterit(signal, frame_rate, filter_type, cutoff_freq);
    end
    
    subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot
    
    plot(tvec, signal); % plot the signal
    title(['Video number: ' num2str(video_num)]); % print signal's title
    xlabel('Time [sec]');
    xlim([0, tvec(end)]); % set x axis limit
    axis on;
    if strcmp(channel,'IR') == 1
        ylabel('Temperature [C]');
    else
        ylabel('Gray level');
    end
    
    sub_count = sub_count + 1;
    if mod(i,sub) == 0 && i ~= exp_num
        batch = batch + 1;
        sub_count = 1;
        str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Batch: ', num2str(batch)];
        figure('Name', str); % opens a new figure window
        sgtitle(str); % plots the idx-title
    end
    
end

if frame_plot == 1

    batch = 1;
    sub_count = 1;
    str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Batch: ', num2str(batch)];
    figure('Name', str); % opens a new figure window
    %sgtitle(str); % plots the idx-title
    
    for i=1:1:exp_num

        subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot

        imshow(data{i}.last_frame,[])
        title(['Video number: ' num2str(data{i}.vid_num)]); % print signal's title

        sub_count = sub_count + 1;
        if mod(i,sub) == 0 && i ~= exp_num
            batch = batch + 1;
            sub_count = 1;
            str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Batch: ', num2str(batch)];
            figure('Name', str); % opens a new figure window
            sgtitle(str); % plots the idx-title
        end
    
    end
    
end

end


