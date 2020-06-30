function file_comp_bar_plot(sig_avg, sig_max, sig_min, sig_std, channel, dir_file_list,...
    files2process, mode, roi_names)

sub = size(sig_avg, 3);
vids_num = size(sig_avg, 2);
exp_num = size(sig_avg, 1);


for i=1:exp_num
    for k=1:sub
        
        errlow(i,:,k) = sig_avg(i,:,k) - sig_min(i,:,k);
        errhigh(i,:,k) = sig_max(i,:,k) - sig_avg(i,:,k);
        
        if strcmp(mode, 'diff')
            bar_data(i,:,k) = errhigh(i,:,k) - errlow(i,:,k);
        elseif strcmp(mode, 'avg')
            bar_data(i,:,k) = sig_avg(i,:,k);
        elseif strcmp(mode, 'std')
            bar_data(i,:,k) = sig_std(i,:,k);
        end

    end
    
end

k = 1;
for i = files2process
    xvec(k) = categorical({dir_file_list(i).name});
    k = k + 1;
end

for k=1:sub
    
    str = ['Video IDX: ', num2str(1), '-', num2str(vids_num),...
       ', ROI: ', num2str(k)];
    figure('Name', str); % opens a new figure window
    
    if strcmp(channel, 'Red')
        b = bar(xvec, bar_data(:,:,k), 'BarWidth', 0.6, 'FaceColor', 'r');
    elseif strcmp(channel, 'Green')
        b = bar(xvec, bar_data(:,:,k), 'BarWidth', 0.6, 'FaceColor', 'g');
    elseif strcmp(channel, 'Blue')
        b = bar(xvec, bar_data(:,:,k), 'BarWidth', 0.6, 'FaceColor', 'b');
    else
        b = bar(xvec, bar_data(:,:,k), 'BarWidth', 0.6, 'FaceColor', [150 150 150]/255);
    end
    
    hold on
    
    for i=0:5:vids_num
        
        if i == 0
            xtips1 = double(b(1).XEndPoints);
            ytips1 = double(b(1).YEndPoints);
            labels1 = string(1);
            text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
                'VerticalAlignment','bottom')
        else
            xtips1 = double(b(i).XEndPoints);
            ytips1 = double(b(i).YEndPoints);
            labels1 = string(i);
            text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
                'VerticalAlignment','bottom')
        end

    end
    %{
    if ~strcmp(mode, 'diff')
        err_xvec(1,:) = 1:vids_num;
        err_xvec(2,:) = 1:vids_num;
        err_xvec(3,:) = 1:vids_num;
        err_xvec(4,:) = 1:vids_num;
        err_bar_data = bar_data(:,:,k);
        errl = errlow(:,:,k);
        errh = errhigh(:,:,k);
        er = errorbar(err_xvec, err_bar_data, errl, errh);
        er.Color = [0 0 0];
        er.LineStyle = 'none';
    end
    %}
    
    %legend(dir_file_list(files2process).name,'Position',[-0.02, 0.8, 0.15, 0.15]);
    title(['ROI ', num2str(k), ': ', char(roi_names(k)) , ' - ', upper(mode)]); % print signal's title
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

