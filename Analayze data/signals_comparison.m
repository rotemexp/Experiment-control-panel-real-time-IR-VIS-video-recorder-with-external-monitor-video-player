function signals_comparison(channel, sub, filter_type, cutoff_freq, folder, files2process, roi_idx, group_by)

try
    load('videos_idx_emotions', 'videos_idx_emotions');
catch
    disp('Error loading videos indexes - emotions correlation data from file')
end

if folder(end) ~= '\' % case last backslesh is missing
    folder = [folder, '\'];
end

channel = upper(channel);
dir_file_list = dir(folder);
dir_file_list = dir_file_list(~ismember({dir_file_list.name},{'.','..'}));
files2process_run = 1;
vids2process = 1:1000;

for k = files2process
    
    exp_num_run = 1;
    
    for i = vids2process
        
        if exp_num_run == 1
            
            current_file = dir_file_list(k).name;
            dir_file_list(k).name = extractBefore(dir_file_list(k).name, "."); % remove '.mat' from file name
            file2load = fullfile([folder, current_file]);
            
            if strcmp(channel, 'VISIR')
                % need to write a proper way to deal with this situation
                %load(file2load, 'vis', 'ir', 'remarks', 'properties');
                disp('Cannot display both VIS & IR data')
                return
            elseif strcmp(channel, 'IR')
                load(file2load, 'ir', 'remarks', 'properties');
                eval('data = ir;');
            elseif strcmp(channel, 'VIS')
                load(file2load, 'vis', 'remarks', 'properties');
                eval('data = vis;');
            end
            
            if strcmp(group_by, 'Played order') || strcmp(group_by, 'Video index')...
                    || strcmp(group_by, 'Emotions')
                data = flipper(data, group_by); % flip data order and remove empty spaces
            end
            
        end
        
        if i <= length(data) && ~isempty(data{i})

            eval('sig = data{i}.sig;'); % get the desired sig
            signals(1:length(sig),i, files2process_run) = sig(:, roi_idx);
            fps = properties.play_list(data{i}.play_order, 8);
            tvec(1:length(signals),i, files2process_run) = linspace(0, length(signals), length(signals)) ./ fps; % create the time axis vector
            
        end
        
        exp_num_run = exp_num_run + 1;
        
    end
    
    files2process_run = files2process_run + 1;
    
end

exp_num = size(signals, 2);
vids2process = 1:exp_num;
batch = 1;
sub_count = 1;
counter = 1;

if length(cutoff_freq) == 1
    lambda = [num2str(cutoff_freq), ' Hz'];
else
    lambda = [num2str(cutoff_freq(1)), '-', num2str(cutoff_freq(end)), ' Hz'];
end

if strcmp(filter_type, 'dc')
    str = ['Files IDX: ', num2str(files2process(1)), '-', num2str(files2process(end)),...
        ', Videos: ', num2str(vids2process(1)), '-', num2str(vids2process(end)),...
        ', Channel: ', channel ,', Filter: ', num2str(filter_type), ', Batch: ', num2str(batch)];
else
    str = ['Files IDX: ', num2str(files2process(1)), '-', num2str(files2process(end)),...
        ', Videos: ', num2str(vids2process(1)), '-', num2str(vids2process(end)),...
        ', Channel: ', channel ,', Filter: ', num2str(filter_type),...
        ', \lambda: ', lambda,  ', Batch: ', num2str(batch)];
end

figure('Name', str); % opens a new figure window
sgtitle(str); % plots the idx-title

for i=1:exp_num
    
    if ~isempty(data{i})
        
        var_name = [extractBefore(data{i}.var_name, '_'), '\_', extractAfter(data{i}.var_name, '_')];
        eval('sig = data{i}.sig;'); % get the desired sig
        frame_rate = data{i}.play_list(data{i}.play_order, 8);
        subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot
        
        for k=1:size(signals, 3)
            
            current_sig = signals(:,i,k);
            current_sig = current_sig(current_sig ~=0);
            
            if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                    strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                    strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'
                current_sig = filterit(current_sig, frame_rate, filter_type, cutoff_freq, 0);
            end
            
            current_tvec = tvec(1:length(current_sig),i, k);
            current_tvec = current_tvec(current_tvec ~=0);
            current_tvec = [0; current_tvec];
            
            if ~isempty(current_sig)
                plot(current_tvec, current_sig); % plot the sig
            end
            
            hold on;
        end
        
        if i == 1 || i == exp_num
            legend(dir_file_list(files2process).name,'Position',[-0.02, 0.8, 0.15, 0.15]);
        end
        
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
        
        xlabel('Time [sec]');
        xlim([0, current_tvec(end)]); % set x axis limit
        axis on;
        
        if strcmp(channel,'IR') == 1
            ylabel('Temperature [C]');
        else
            ylabel('Gray level');
        end
        
        sub_count = sub_count + 1;
        
        if mod(counter,sub) == 0 && i ~= exp_num
            
            legend(dir_file_list(files2process).name,'Position',[-0.02, 0.8, 0.15, 0.15]);
            batch = batch + 1;
            sub_count = 1;
            if strcmp(filter_type, 'dc')
                str = ['Files IDX: ', num2str(files2process(1)), '-', num2str(files2process(end)),...
                    ', Videos: ', num2str(vids2process(1)), '-', num2str(vids2process(end)),...
                    ', Channel: ', channel ,', Filter: ', num2str(filter_type), ', Batch: ', num2str(batch)];
            else
                str = ['Files IDX: ', num2str(files2process(1)), '-', num2str(files2process(end)),...
                    ', Videos: ', num2str(vids2process(1)), '-', num2str(vids2process(end)),...
                    ', Channel: ', channel ,', Filter: ', num2str(filter_type),...
                    ', \lambda: ', lambda,  ', Batch: ', num2str(batch)];
            end
            figure('Name', str); % opens a new figure window
            sgtitle(str); % plots the idx-title
            
        end
        counter = counter + 1;
    end
end

end

