function FFT_plot(data, channel, freq_limit, pow_limit, sub, filter_type, cutoff_freq)

exp_num = numel(data); % find number of videos in recieved data

batch = 1;
sub_count = 1;
str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Batch: ', num2str(batch)];
figure('Name', str); % opens a new figure window
sgtitle(str); % plots the idx-title

for i=1:1:exp_num
    
    video_num = data{i}.vid_num;
    eval(['signal = data{i}.', channel, ';']); % get the desired signal
    frame_rate = data{1}.play_list(i,8);
    
    if size(signal, 1) ~= 1
        signal = signal';
    end
    
    if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
            strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
            strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'  % 'low' / 'high' / 'bandpass' / 'median' / 'no' 
        signal = filterit(signal, frame_rate, filter_type, cutoff_freq);
    end
    
    SIG_pos = perform_FFT(signal);
    sig_len = length(SIG_pos);
    fvec = (0:sig_len-1) ./ (sig_len-1) .* (frame_rate/2); % constructing the FFT x-axis vector
    
    subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot
    
    plot(fvec, SIG_pos); % plot the signal
    title(['Video number: ' num2str(video_num)]); % print signal's title
    xlabel('Frequency [Hz]');
    ylabel('A.U');
    axis on;
    if length(freq_limit) == 2
        xlim(freq_limit); % set x axis limit
    else
        xlim([0, fvec(end)]); % set x axis limit
    end
    if length(pow_limit) == 2
        ylim(pow_limit); % set x axis limit
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

end

