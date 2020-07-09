function var_names_list = intensity_comparison(channel, folder, files2process,...
    disp_last_frames, mode, comparison, background_subtraction, group_by,...
    filter_type, cutoff_freq)

if folder(end) ~= '\' % case last backslesh is missing
    folder = [folder, '\'];
end

dir_file_list = dir(folder);
dir_file_list = dir_file_list(~ismember({dir_file_list.name},{'.','..'}));
channel = upper(channel);
k_counter = 1;
vids2process = 1:1000;

for k = files2process
    
    exp_num_run = 1;
    i_counter = 1;
    
    for i = vids2process
        
        if exp_num_run == 1
            
            current_file = dir_file_list(k).name;
            dir_file_list(k).name = extractBefore(dir_file_list(k).name, "."); % remove '.mat' from file name
            file2load = fullfile([folder, current_file]);
            
            if strcmp(channel, 'VISIR')
                disp('Cannot display both VIS & IR data.')
                disp('Choose one of the following: VIS / IR / R / G / B');
                return
                %load(file2load, 'vis', 'ir', 'remarks', 'properties');
            elseif strcmp(channel, 'VIS') || strcmp(channel, 'R') ||...
                    strcmp(channel, 'G') || strcmp(channel, 'B')
                load(file2load, 'vis', 'remarks', 'properties');
                eval('data = vis;');
            elseif strcmp(channel, 'IR')
                load(file2load, 'ir', 'remarks', 'properties');
                eval('data = ir;');
            end
            
            if strcmp(group_by, 'Played order') || strcmp(group_by, 'Video index')...
                    || strcmp(group_by, 'Emotions')
                data = flipper(data, group_by); % flip data order and remove empty spaces
            end
            
            last_frames_list{k_counter} = data{i}.last_frame; % get last frame image
            
        end
        
        if i <= length(data) && ~isempty(data{i})
            
            if strcmp(data{i}.type, 'VIS') && strcmp(channel, 'VIS')
                
                var_names_list(k_counter, i_counter) = string(data{i}.var_name);
                eval('sig = data{i}.sig;'); % get the desired signal
                
                if background_subtraction ~= 0
                    temp = sig(:,background_subtraction);
                    sig = sig - sig(:,background_subtraction);
                    sig(:,background_subtraction) = temp;
                end
                
                fps = data{1, 1}.play_list(i,8);
                
                if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                        strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                        strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'
                    sig = filterit(sig, fps, filter_type, cutoff_freq, 1);
                end
                
                sig_avg(k_counter, i_counter, :) = mean(sig);
                sig_max(k_counter, i_counter, :) = max(sig);
                sig_min(k_counter, i_counter, :) = min(sig);
                sig_std(k_counter, i_counter, :) = std(sig);

            elseif strcmp(data{i}.type, 'VIS') && strcmp(channel, 'R')
                
                if k==2
                   disp(' ');
                end
                
                var_names_list(k_counter, i_counter) = string(data{i}.var_name);
                eval('R = data{i}.R;'); % get the desired signal
                
                if background_subtraction ~= 0
                    temp = R(:,background_subtraction);
                    R = R - R(:,background_subtraction);
                    R(:,background_subtraction) = temp;
                end
                
                fps = data{1, 1}.play_list(i,8);
                
                if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                        strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                        strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'
                    R = filterit(R, fps, filter_type, cutoff_freq, 1);
                end
                
                R_avg(k_counter, i_counter, :) = mean(R);
                R_max(k_counter, i_counter, :) = max(R);
                R_min(k_counter, i_counter, :) = min(R);
                R_std(k_counter, i_counter, :) = std(R);
                
            elseif strcmp(data{i}.type, 'VIS') && strcmp(channel, 'G')
                
                var_names_list(k_counter, i_counter) = string(data{i}.var_name);
                eval('G = data{i}.G;'); % get the desired signal
                
                if background_subtraction ~= 0
                    temp = G(:,background_subtraction);
                    G = G - G(:,background_subtraction);
                    G(:,background_subtraction) = temp;
                end
                
                fps = data{1, 1}.play_list(i,8);
                
                if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                        strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                        strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'
                    G = filterit(G, fps, filter_type, cutoff_freq, 1);
                end
                
                G_avg(k_counter, i_counter, :) = mean(G);
                G_max(k_counter, i_counter, :) = max(G);
                G_min(k_counter, i_counter, :) = min(G);
                G_std(k_counter, i_counter, :) = std(G);
                
            elseif strcmp(data{i}.type, 'VIS') && strcmp(channel, 'B')
                
                var_names_list(k_counter, i_counter) = string(data{i}.var_name);
                eval('B = data{i}.B;'); % get the desired signal
                
                if background_subtraction ~= 0
                    temp = B(:,background_subtraction);
                    B = B - B(:,background_subtraction);
                    B(:,background_subtraction) = temp;
                end
                
                fps = data{1, 1}.play_list(i,8);
                
                if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                        strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                        strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'
                    B = filterit(B, fps, filter_type, cutoff_freq, 1);
                end
                
                B_avg(k_counter, i_counter, :) = mean(B);
                B_max(k_counter, i_counter, :) = max(B);
                B_min(k_counter, i_counter, :) = min(B);
                B_std(k_counter, i_counter, :) = std(B);
                
            elseif strcmp(data{i}.type, 'IR')
                
                var_names_list(k_counter, i_counter) = string(data{i}.var_name);
                eval('sig = data{i}.sig;'); % get the desired signal
                
                if background_subtraction ~= 0
                    temp = sig(:,background_subtraction);
                    sig = sig - sig(:,background_subtraction);
                    sig(:,background_subtraction) = temp;
                end
                
                fps = data{1, 1}.play_list(i,8);
                
                if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                        strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                        strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'
                    sig = filterit(sig, fps, filter_type, cutoff_freq, 1);
                end
                
                sig_avg(k_counter, i_counter, :) = mean(sig);
                sig_max(k_counter, i_counter, :) = max(sig);
                sig_min(k_counter, i_counter, :) = min(sig);
                sig_std(k_counter, i_counter, :) = std(sig);
                
            end
            i_counter = i_counter + 1;
        end
        exp_num_run = exp_num_run + 1;
    end
    k_counter = k_counter + 1;
end

%% call bar plot function

roi_labels = data{1, 1}.roi_labels;

if strcmp(channel, 'VIS')
    
    if strcmp(comparison, 'roi')
        bar_plot_roi(sig_avg, sig_max, sig_min, sig_std, 'VIS', dir_file_list, files2process, mode, roi_labels, group_by)
    elseif strcmp(comparison, 'file')
        bar_plot_file(sig_avg, sig_max, sig_min, sig_std, 'VIS', dir_file_list, files2process, mode, roi_labels, group_by)
    end
    
elseif strcmp(channel, 'R')
    
    if strcmp(comparison, 'roi')
        bar_plot_roi(R_avg, R_max, R_min, R_std, 'Red', dir_file_list, files2process, mode, roi_labels, group_by)
    elseif strcmp(comparison, 'file')
        bar_plot_file(R_avg, R_max, R_min, R_std, 'Red', dir_file_list, files2process, mode, roi_labels, group_by)
    end
    
elseif strcmp(channel, 'G')
    
    if strcmp(comparison, 'roi')
        bar_plot_roi(G_avg, G_max, G_min, G_std, 'Green', dir_file_list, files2process, mode, roi_labels, group_by)
    elseif strcmp(comparison, 'file')
        bar_plot_file(G_avg, G_max, G_min, G_std, 'Green', dir_file_list, files2process, mode, roi_labels, group_by)
    end
    
elseif strcmp(channel, 'B')
    
    if strcmp(comparison, 'roi')
        bar_plot_roi(B_avg, B_max, B_min, B_std, 'Blue', dir_file_list, files2process, mode, roi_labels, group_by)
    elseif strcmp(comparison, 'file')
        bar_plot_file(B_avg, B_max, B_min, B_std, 'Blue', dir_file_list, files2process, mode, roi_labels, group_by)
    end
    
elseif strcmp(channel, 'IR')
    
    if strcmp(comparison, 'roi')
        bar_plot_roi(sig_avg, sig_max, sig_min, sig_std, channel, dir_file_list, files2process, mode, roi_labels, group_by)
    elseif strcmp(comparison, 'file')
        bar_plot_file(sig_avg, sig_max, sig_min, sig_std, channel, dir_file_list, files2process, mode, roi_labels, group_by)
    end
    
end

%% Display last frames

if disp_last_frames == 1
    
    for k = 1:size(last_frames_list,2)
        
        f_name = dir_file_list(files2process(k)).name;
        figure('Name', f_name)
        sgtitle(f_name);
        imshow(last_frames_list{k}, [])
        
    end
    
end

end