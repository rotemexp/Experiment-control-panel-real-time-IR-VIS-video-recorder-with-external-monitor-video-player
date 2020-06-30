function roi_comp_bar_plot(sig_avg, sig_max, sig_min, sig_std, channel, dir_file_list, files2process, mode, roi_names)

sub = size(sig_avg, 3);
vids_num = size(sig_avg, 2);
exp_num = size(sig_avg, 1);
batch = 1;
sub_count = 1;
i_counter = 1;

str = ['Video IDX: ', num2str(1), '-', num2str(vids_num),...
    ', Channel: ', channel, ', File: ', num2str(dir_file_list(files2process(1)).name)];

figure('Name', str); % opens a new figure window
sgtitle(str); % plots the idx-title

for i=1:exp_num
    
    for k=1:sub
        
        subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot
        
        errlow = sig_avg(i,:,k) - sig_min(i,:,k);
        errhigh = sig_max(i,:,k) - sig_avg(i,:,k);
        xvec = 1:vids_num;
        
        if strcmp(mode, 'diff')
            bar_data = errhigh - errlow;
        elseif strcmp(mode, 'avg')
            bar_data = sig_avg(i,:,k)';
        elseif strcmp(mode, 'std')
            bar_data = sig_std(i,:,k)';
        end

        if strcmp(channel, 'Red')
            bar(xvec, bar_data, 'BarWidth', 0.6, 'FaceColor', 'r')
        elseif strcmp(channel, 'Green')
            bar(xvec, bar_data, 'BarWidth', 0.6, 'FaceColor', 'g')
        elseif strcmp(channel, 'Blue')
            bar(xvec, bar_data, 'BarWidth', 0.6, 'FaceColor', 'b')
        else
            bar(xvec, bar_data, 'BarWidth', 0.6, 'FaceColor', [150 150 150]/255)
        end

        hold on
        
        if ~strcmp(mode, 'diff')
            er = errorbar(xvec, bar_data, errlow, errhigh);
            er.Color = [0 0 0];
            er.LineStyle = 'none';
        end
        
        %legend(dir_file_list(files2process).name,'Position',[-0.02, 0.8, 0.15, 0.15]);
        %title(['ROI: ', num2str(sub_count)]); % print signal's title
        title(['ROI ', num2str(k), ': ', char(roi_names(k)) , ' - ', upper(mode)]); % print signal's title
        xlabel('Video IDX');
        
        axis on;
        
        if strcmp(channel,'IR') == 1
            ylabel('Temperature [C]');
        else
            ylabel('Gray level');
        end
        
        sub_count = sub_count + 1;
        
        if mod(i_counter, sub) == 0 && i ~= exp_num
            
            %legend(dir_file_list(files2process).name,'Position',[-0.02, 0.8, 0.15, 0.15]);
            batch = batch + 1;
            sub_count = 1;
            str = ['Video IDX: ', num2str(1), '-', num2str(vids_num),...
                ', Channel: ', channel, ', File: ', num2str(dir_file_list(files2process(i+1)).name)];
            figure('Name', str); % opens a new figure window
            sgtitle(str); % plots the idx-title
            
        end
        
        i_counter = i_counter + 1;
        
    end % end rois_num loop
    
end

end

