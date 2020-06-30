function var_names_list = intensity_comparison(channel, folder, files2process, vids2process,...
    disp_last_frames, mode, comparison, roi_names)

if folder(end) ~= '\' % case last backslesh is missing
    folder = [folder, '\'];
end

dir_file_list = dir(folder);
dir_file_list = dir_file_list(~ismember({dir_file_list.name},{'.','..'}));

k_counter = 1;

for k = files2process
    
    exp_num_run = 1;
    i_counter = 1;
    
    for i = vids2process
        
        if exp_num_run == 1
            
            current_file = dir_file_list(k).name;
            dir_file_list(k).name = extractBefore(dir_file_list(k).name, "."); % remove '.mat' from file name
            file2load = fullfile([folder, current_file]);
            
            if strcmp(channel, 'VISIR')
                load(file2load, 'vis', 'ir', 'remarks', 'properties');
            elseif strcmp(channel, 'IR')
                load(file2load, 'ir', 'remarks', 'properties');
            elseif strcmp(channel, 'VIS')
                load(file2load, 'vis', 'remarks', 'properties');
            end
            
            if exist('vis', 'var') & exist('ir', 'var')
                disp('Cannot display both VIS & IR data')
                return
            elseif exist('ir', 'var')
                eval('data = ir;');
            elseif exist('vis', 'var')
                eval('data = vis;');
            end
            
            last_frames_list{k_counter} = data{i}.last_frame; % get last frame image
            
        end
        
        if i <= length(data) && ~isempty(data{i})
            
            if strcmp(data{i}.type, 'VIS')
                
                eval('R = data{i}.R;'); % get the desired signal
                eval('G = data{i}.G;'); % get the desired signal
                eval('B = data{i}.B;'); % get the desired signal
                
                var_names_list(k_counter, i_counter) = string(data{i}.var_name);
                
                R_avg(k_counter, i_counter, :) = mean(R);
                R_max(k_counter, i_counter, :) = max(R);
                R_min(k_counter, i_counter, :) = min(R);
                R_std(k_counter, i_counter, :) = std(R);
                
                G_avg(k_counter, i_counter, :) = mean(G);
                G_max(k_counter, i_counter, :) = max(G);
                G_min(k_counter, i_counter, :) = min(G);
                G_std(k_counter, i_counter, :) = std(G);
                
                B_avg(k_counter, i_counter, :) = mean(B);
                B_max(k_counter, i_counter, :) = max(B);
                B_min(k_counter, i_counter, :) = min(B);
                B_std(k_counter, i_counter, :) = std(B);
                
            else
                
                eval('sig = data{i}.sig;'); % get the desired signal

                var_names_list(k_counter, i_counter) = string(data{i}.var_name);
                
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

if strcmp(channel, 'IR')
    
    if strcmp(comparison, 'roi')
        bar_plot(sig_avg, sig_max, sig_min, sig_std, channel, dir_file_list, files2process, mode, roi_names)
    elseif strcmp(comparison, 'file')
        file_comp_bar_plot(sig_avg, sig_max, sig_min, sig_std, channel, dir_file_list, files2process, mode, roi_names)
    end
    
else
    
    if strcmp(comparison, 'roi')
        bar_plot(R_avg, R_max, R_min, R_std, 'Red', dir_file_list, files2process, mode, roi_names)
        bar_plot(G_avg, G_max, G_min, G_std, 'Green', dir_file_list, files2process, mode, roi_names)
        bar_plot(B_avg, B_max, B_min, B_std, 'Blue', dir_file_list, files2process, mode, roi_names)
    elseif strcmp(comparison, 'file')
        file_comp_bar_plot(R_avg, R_max, R_min, R_std, 'Red', dir_file_list, files2process, mode, roi_names)
        file_comp_bar_plot(G_avg, G_max, G_min, G_std, 'Green', dir_file_list, files2process, mode, roi_names)
        file_comp_bar_plot(B_avg, B_max, B_min, B_std, 'Blue', dir_file_list, files2process, mode, roi_names)
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