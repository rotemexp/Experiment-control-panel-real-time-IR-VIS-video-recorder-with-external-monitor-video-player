function err = save_buffer(app, properties, filename, buffer_VIS, buffer_R, buffer_G,...
    buffer_B, buffer_IR, saveObject, idx)

if properties.saveONblack == 0 % case initial / final save
    
    err = status(app, 'Saving data to file...', 'g', 1, 0);
    
    if properties.VIS_camera == 1
        if properties.gray == 1
            save(filename,'buffer_VIS','-append'); % adds variables to the saved data file
        elseif properties.gray == 0
            save(filename,'buffer_R','buffer_G','buffer_B','-append'); % adds variables to the saved data file
        end
    end
    
    if properties.IR_camera == 1
        save(filename,'buffer_IR','-append'); % adds variables to the saved data file
    end
    
else % case needs to update saved file
    
    listOfVariables = who('-file', filename); % get a list of the saved variables inside the mat file
    
    if ismember('buffer_VIS', listOfVariables) % case buffer_VIS exists inside mat file
        [~, ~, last_raw(1)] = size(saveObject.buffer_VIS);
        if last_raw(1) == 2
            last_raw(1) = 0; % case first run
        end
    end
    
    if ismember('buffer_R', listOfVariables) % case buffer_R exists inside mat file
        [~, ~, last_raw(2)] = size(saveObject.buffer_R);
        if last_raw(2) == 2
            last_raw(2) = 0; % case first run
        end
    end
    
    if ismember('buffer_IR', listOfVariables) % case buffer_IR exists inside mat file
        [~, ~, last_raw(3)] = size(saveObject.buffer_IR);
        if last_raw(3) == 2
            last_raw(3) = 0; % case first run
        end
    end
    
    last = max(last_raw); % take the maximum value as the last saved index
        
    err = status(app, ['Saving data to file: indexes ', num2str(last + 1), ' to ', num2str(last + idx)], 'g', 1, 0);
    
    if properties.VIS_camera == 1
        if properties.gray == 1
                        
            saveObject.buffer_VIS(:, :, last + 1: last + idx) = buffer_VIS; % update data file
            
        elseif properties.gray == 0
            
            saveObject.buffer_R(:, :, last + 1 : last + idx) = buffer_R; % update data file
            saveObject.buffer_G(:, :, last + 1 : last + idx) = buffer_G; % update data file
            saveObject.buffer_B(:, :, last + 1 : last + idx) = buffer_B; % update data file
            
        end
    end
    
    if properties.IR_camera == 1
        saveObject.buffer_IR(:, :, last + 1 : last + idx) = buffer_IR; % update data file
    end
    
end

err = status(app, 'Done Saving data to file!', 'g', 1, 0);

end