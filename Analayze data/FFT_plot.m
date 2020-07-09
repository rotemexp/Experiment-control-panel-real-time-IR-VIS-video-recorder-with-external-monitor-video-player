function FFT_plot(data, channel, freq_limit, pow_limit, sub, filter_type, cutoff_freq, roi_idx, group_by)

try
    load('videos_idx_emotions', 'videos_idx_emotions');
catch
    disp('Error loading videos indexes - emotions correlation data from file')
end

if strcmp(group_by, 'Played order') || strcmp(group_by, 'Video index')...
        || strcmp(group_by, 'Emotions')
    data = flipper(data, group_by); % flip data order and remove empty spaces
end

exp_num = numel(data); % find number of videos in recieved data
batch = 1;
sub_count = 1;
counter = 1;

if length(cutoff_freq) == 1
    lambda = [num2str(cutoff_freq), ' Hz'];
else
    lambda = [num2str(cutoff_freq(1)), '-', num2str(cutoff_freq(end)), ' Hz'];
end

for i=1:1:exp_num
    
    if ~isempty(data{i})
        
        var_name = [extractBefore(data{i}.var_name, '_'), '\_', extractAfter(data{i}.var_name, '_')];
        eval(['signal = data{i}.', channel, ';']); % get the desired signal
        fps = data{1}.play_list(data{i}.play_order, 8);
        
        if size(signal, 1) ~= 1
            signal = signal';
        end
        
        if size(signal, 1) ~= 1
           signal = signal(roi_idx, :);
        end
        
        if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'  % 'low' / 'high' / 'bandpass' / 'median' / 'no'
            signal = filterit(signal, fps, filter_type, cutoff_freq, 1);
        end
        
        SIG_pos = perform_FFT(signal);
        sig_len = length(SIG_pos);
        fvec = (0:sig_len-1) ./ (sig_len-1) .* (fps/2); % constructing the FFT x-axis vector
        
        if i == 1
            if strcmp(filter_type, 'dc')
                str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Filter: ', num2str(filter_type),...
                    ', ROI idx: ', num2str(roi_idx), ', Batch: ', num2str(batch)];
            else
                str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Filter: ', num2str(filter_type),...
                ', \lambda: ', lambda, ', ROI idx: ', num2str(roi_idx), ', Batch: ', num2str(batch)];
            end
            figure('Name', str); % opens a new figure window
            sgtitle(str); % plots the idx-title
        end
        
        subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot
        
        plot(fvec, SIG_pos); % plot the signal
        
        vid_idx = str2double(extractAfter(var_name, '_'));
        
        if exist('videos_idx_emotions', 'var')
            if vid_idx <= length(videos_idx_emotions)
                title(['Video file: ', var_name, ', (', char(videos_idx_emotions(vid_idx, 2)) ,')']); % print signal's title
            else
                title(['Video file: ', var_name]); % print signal's title
            end
        else
            title(['Video file: ', var_name]); % print signal's title
        end
        
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
        if mod(counter,sub) == 0 && counter ~= exp_num
            batch = batch + 1;
            sub_count = 1;
            if strcmp(filter_type, 'dc')
                str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Filter: ', num2str(filter_type),...
                    ', ROI idx: ', num2str(roi_idx), ', Batch: ', num2str(batch)];
            else
                str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Filter: ', num2str(filter_type),...
                ', \lambda: ', lambda, ', ROI idx: ', num2str(roi_idx), ', Batch: ', num2str(batch)];
            end
            figure('Name', str); % opens a new figure window
            sgtitle(str); % plots the idx-title
        end
        counter = counter + 1;
    end
    
end

end

