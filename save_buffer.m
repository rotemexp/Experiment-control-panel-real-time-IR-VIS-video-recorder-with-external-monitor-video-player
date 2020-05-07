function err = save_buffer(app, properties, filename, playlist, buffer_VIS, buffer_IR, vid_num, buff_idx)

if buff_idx == 0
    return;
end

%try

if properties.flag_IR_camera_on_black == 1 && properties.IR_camera == 1
    %err = status(app, 'Saving data to file & performing IR camera flag (Temp. drift reset)...', 'g', 1, 0);
    app.Status1.FontColor = [0.29,0.58,0.07]; % dark green
    app.Status1.Value = sprintf('%s', ['Saving ', num2str(buff_idx), ' frames to file & performing IR camera flag (Temp. drift reset)...']);
else
    %err = status(app, 'Saving data to file...', 'g', 1, 0);
    app.Status1.FontColor = [0.29,0.58,0.07]; % dark green
    app.Status1.Value = sprintf('%s', ['Saving ', num2str(buff_idx), ' frames to file...']);
end

drawnow(); % updates callback functions

if properties.playVideofiles == 1 && properties.saveONblack == 1 && properties.save_vid_by_order == 0

    org_vid_name = extractBefore(playlist(vid_num).name,"."); % get file name
    vid_name = str2num(org_vid_name); % get it to numerical value

    if isempty(vid_name) == 1 % case there was an error changing the name to numerical
        vid_name = matlab.lang.makeValidName(org_vid_name); % change the name to something similar and legal
        vid_name = strcat(vid_name,['_', num2str(vid_num)]);
    end
    
elseif properties.playVideofiles == 1 && properties.saveONblack == 0
    vid_name = 0;
else
    vid_name = vid_num; % case there only one data file
end

if properties.VIS_camera == 1
    
    if ndims(buffer_VIS) == 3
        buffer_VIS = buffer_VIS(:,:,1:buff_idx);
    elseif ndims(buffer_VIS) == 4
        buffer_VIS = buffer_VIS(:,:,:,1:buff_idx);
    end
    
    eval(['VIS_', num2str(vid_name), ' = buffer_VIS;']); % get the desired signal
    save(filename,['VIS_', num2str(vid_name)],'-append'); % adds variables to the saved data file
    
end

if properties.IR_camera == 1
    
    if ndims(buffer_IR) == 3
        buffer_IR = buffer_IR(:,:,1:buff_idx);
    elseif ndims(buffer_IR) == 4
        buffer_IR = buffer_IR(:,:,:,1:buff_idx);
    end
    
    eval(['IR_', num2str(vid_name), ' = buffer_IR;']); % get the desired signal
    save(filename,['IR_', num2str(vid_name)],'-append'); % adds variables to the saved data file
    
end

err = status(app, 'Done Saving data to file!', 'g', 1, 0);

%catch
    %err = status(app, 'Error Saving buffer data to file!', 'r', 1, 1);
%end

end

