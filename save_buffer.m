function err = save_buffer(app, properties, filename, buffer_VIS, buffer_IR, saveObject, idx)

if properties.playVideofiles == 0 || (properties.playVideofiles == 1 && ...
        properties.saveONblack == 0) % case final save
    
    err = status(app, 'Saving data to file...', 'g', 1, 0);
    
    if properties.VIS_camera == 1 && properties.gray == 1
        buffer_VIS = buffer_VIS(:,:,1:idx); % take only the part with the data
    elseif properties.VIS_camera == 1 && properties.gray == 0
        buffer_VIS = buffer_VIS(:,:,:,1:idx); % take only the part with the data
    end
    
    if properties.IR_camera == 1 && properties.tempORcolor == 1
        buffer_IR = buffer_IR(:,:,1:idx); % take only the part with the data
    elseif properties.IR_camera == 1 && properties.tempORcolor == 0
        buffer_IR = buffer_IR(:,:,1:idx); % take only the part with the data
    end
    
    
    if properties.VIS_camera == 1
        save(filename,'buffer_VIS','-append'); % adds variables to the saved data file
    end
    
    if properties.IR_camera == 1
        save(filename,'buffer_IR','-append'); % adds variables to the saved data file
    end
    
elseif properties.saveONblack == 1 && idx == 1 % case initial save
    
    
    err = status(app, 'Saving data to file...', 'g', 1, 0);
    
    if properties.VIS_camera == 1
        
        if ndims(buffer_VIS) == 3
            buffer_VIS = buffer_VIS(:,:,1:2);
        elseif ndims(buffer_VIS) == 4
            buffer_VIS = buffer_VIS(:,:,:,1:2);
        end
        save(filename,'buffer_VIS','-append'); % adds variables to the saved data file
        
    end
    
    if properties.IR_camera == 1
        
        if ndims(buffer_IR) == 3
            buffer_IR = buffer_IR(:,:,1:2);
        elseif ndims(buffer_IR) == 4
            buffer_IR = buffer_IR(:,:,:,1:2);
        end
        save(filename,'buffer_IR','-append'); % adds variables to the saved data file
        
    end
    
    
elseif idx ~= 0  % case needs to update saved file
    
    listOfVariables = who('-file', filename); % get a list of the saved variables inside the mat file
    
    if ismember('buffer_VIS', listOfVariables) % case buffer_VIS exists inside mat file
        if ndims(buffer_VIS) == 3
            last_raw(1) = size(saveObject.buffer_VIS, 3);
        elseif ndims(buffer_VIS) == 4
            last_raw(1) = size(saveObject.buffer_VIS, 4);
        end
    end
    
    if ismember('buffer_IR', listOfVariables) % case buffer_IR exists inside mat file
        if ndims(buffer_IR) == 3
            last_raw(2) = size(saveObject.buffer_IR, 3);
        elseif ndims(buffer_VIS) == 4
            last_raw(2) = size(saveObject.buffer_IR, 4);
        end
    end
    
    last = max(last_raw); % take the maximum value as the last saved index
    
    if last == 2
        last= 0;
    end
    
    err = status(app, ['Saving data to file: indexes ', num2str(last + 1), ' to ', num2str(last + idx)], 'g', 1, 0);
    
    drawnow(); % updates image and callbacks
    
    if properties.VIS_camera == 1 && properties.gray == 1
        saveObject.buffer_VIS(:, :, last + 1: last + idx) = buffer_VIS(:,:,1:idx); % update data file
    elseif properties.VIS_camera == 1 && properties.gray == 0
        saveObject.buffer_VIS(:, :, :, last + 1: last + idx) = buffer_VIS(:,:,:,1:idx); % update data file
    end
    
    if properties.IR_camera == 1 && properties.tempORcolor == 1
        saveObject.buffer_IR(:, :, last + 1 : last + idx) = buffer_IR(:,:,1:idx); % update data file
    elseif properties.IR_camera == 1 && properties.tempORcolor == 0
        saveObject.buffer_IR(:, :, :, last + 1 : last + idx) = buffer_IR(:,:,:,1:idx); % update data file
    end
    
end

err = status(app, 'Done Saving data to file!', 'g', 1, 0);

end

