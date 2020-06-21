function signals_comparison(channel, sub, filter_type, cutoff_freq, folder, files2process, vids2process)

if folder(end) ~= '\' % case last backslesh is missing
    folder = [folder, '\'];
end

dir_file_list = dir(folder);
exp_num = numel(vids2process);
exp_num_run = 1;
files2process_run = 1;

for k = files2process
    
    exp_num_run = 1;
    
    for i = vids2process
        
        if exp_num_run ==1
            
            current_file = dir_file_list(k).name;
            dir_file_list(k).name = extractBefore(dir_file_list(k).name, ".");
            file2load = fullfile([folder, current_file]);
            
            if strcmp(channel, 'VISIR')
                load(file2load, 'vis', 'ir', 'remarks', 'properties');
            elseif strcmp(channel, 'IR')
                load(file2load, 'ir', 'remarks', 'properties');
            elseif strcmp(channel, 'VIS')
                load(file2load, 'vis', 'remarks', 'properties');
            end
            
            if exist('vis', 'var') & exist('ir', 'var')
                %eval('data = vis;');
            elseif exist('ir', 'var')
                eval('data = ir;');
            elseif exist('vis', 'var')
                eval('data = vis;');
            end
            
            % pre-allocation:
            %max_sig_len = max(properties.play_list(:,7));
            %signals(max_sig_len+1, exp_num, length(files2process)) = 0;
            
        end
        
        if i <= length(data)
            
            eval(['sig = data{i}.', channel, ';']); % get the desired sig
            signals(1:length(sig),i, files2process_run) = sig;

            %{
            max_vids_in_file = size(properties.play_list, 1);

            if max_vids_in_file <= vids2process(end)
                until_vid = max_vids_in_file;
            else
                until_vid = vids2process(end);
            end
            %}
            
            fps = properties.play_list(i, 8);
            tvec(1:length(signals),i, files2process_run) = linspace(0, length(signals), length(signals)) ./ fps; % create the time axis vector
        
        end
        
        exp_num_run = exp_num_run + 1;
        
    end
    
    files2process_run = files2process_run + 1;
    
end

exp_num = size(signals, 2);
batch = 1;
sub_count = 1;
str = ['Files: ', num2str(files2process), ' Videos: ', num2str(vids2process),...
    ', Channel: ', channel ,', Batch: ', num2str(batch)];
figure('Name', str); % opens a new figure window
sgtitle(str); % plots the idx-title

for i=1:exp_num
    
    video_num = data{i}.vid_num;
    eval(['sig = data{i}.', channel, ';']); % get the desired sig
    frame_rate = data{i}.play_list(video_num, 8);
    subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot
    
    for k=1:size(signals, 3)
        
        current_sig = signals(:,i,k);
        current_sig = current_sig(current_sig ~=0);
        
        if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'
            current_sig = filterit(current_sig, frame_rate, filter_type, cutoff_freq);
        end
        
        current_tvec = tvec(1:length(current_sig),i, k);
        current_tvec = current_tvec(current_tvec ~=0);
        current_tvec = [0; current_tvec];
        
        plot(current_tvec, current_sig); % plot the sig
        hold on;
    end
    
    if i == 1
        legend(dir_file_list(files2process).name,'Position',[-0.02, 0.8, 0.15, 0.15]);
    end
    
    title(['Video number: ' num2str(video_num)]); % print sig's title
    xlabel('Time [sec]');
    xlim([0, current_tvec(end)]); % set x axis limit
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
        str = ['Files: ', num2str(files2process), ' Videos: ', num2str(vids2process),...
            ', Channel: ', channel ,', Batch: ', num2str(batch)];
        figure('Name', str); % opens a new figure window
        sgtitle(str); % plots the idx-title
    end
    
end

end

