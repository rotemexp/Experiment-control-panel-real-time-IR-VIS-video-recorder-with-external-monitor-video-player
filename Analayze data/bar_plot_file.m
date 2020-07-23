function bar_plot_file(sig_avg, sig_max, sig_min, sig_std, channel, dir_file_list,...
    files2process, mode, roi_labels, group_by)

sub = size(sig_avg, 3);
vids_num = size(sig_avg, 2);
vids2process = 1:vids_num;
  
if strcmp(mode, 'diff')
    errlow = sig_avg - sig_min;
    errhigh = sig_max - sig_avg;
    bar_data = errhigh - errlow;
elseif strcmp(mode, 'avg')
    bar_data = sig_avg;
elseif strcmp(mode, 'std')
    bar_data = sig_std;
end

bar_data(bar_data == 0) = nan;
nan_loc = isnan(bar_data);

k = 1;
for i = files2process
    xvec(k) = categorical({append('(', num2str(k) ,') ' , dir_file_list(i).name)});
    first_nan = find(nan_loc(k,:)==1);
    if isempty(first_nan)
        legend_std(k) = std(bar_data(k,:));
    else
        legend_std(k) = std(bar_data(k,1:first_nan(1,1)-1));
    end
    legend_range(k) = max(bar_data(k,:)) - min(bar_data(k,:));
    std_txt(k) = 'STD ' + string(k) + ': ' + string(round(legend_std(k), 3));
    range_txt(k) = 'Range ' + string(k) + ': ' + string(round(legend_range(k), 3));
    k = k + 1;
end

for k=1:sub
    
    str = ['Video IDX: ', num2str(1), '-', num2str(vids_num), ', Channel: ', channel,...
       ', ROI: ', num2str(k), ', Videos order by: ', group_by];
    figure('Name', str); % opens a new figure window
    
    if strcmp(channel, 'Red')
        b = bar(xvec, bar_data(:,:,k), 'BarWidth', 0.6, 'FaceColor', 'r');
    elseif strcmp(channel, 'Green')
        b = bar(xvec, bar_data(:,:,k), 'BarWidth', 0.6, 'FaceColor', 'g');
    elseif strcmp(channel, 'Blue')
        b = bar(xvec, bar_data(:,:,k), 'BarWidth', 0.6, 'FaceColor', 'b');
    else
        b = bar(xvec, bar_data(:,:,k), 'BarWidth', 0.6, 'FaceColor', [50 50 50]/255);
    end
    
    hold on
    
    adder = vids2process(1) - 1;
    for i=0:5:vids_num
        if i == 0
            xtips1 = double(b(1).XEndPoints);
            ytips1 = double(b(1).YEndPoints);
            labels1 = string(1 + adder);
            text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
                'VerticalAlignment','bottom') 
        else
            xtips1 = double(b(i).XEndPoints);
            ytips1 = double(b(i).YEndPoints);
            labels1 = string(i + adder);
            text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
                'VerticalAlignment','bottom')
        end
    end

    if k == 1
        y_loc = max(max(max(bar_data)));
        text(0.2, double(y_loc), std_txt)
        text(0.2, double(y_loc*0.8), range_txt)
    end
    
    title(['ROI ', num2str(k), ': ', char(roi_labels(k)) , ' - ', upper(mode), ' Channel: ', channel,...
        ', Videos order by: ', group_by]); % print signal's title
    xlabel('File name');
    grid on;
    axis on;
    
    if strcmp(channel,'IR') == 1
        ylabel('Temperature [C]');
    else
        ylabel('Gray level');
    end
    
end


end

