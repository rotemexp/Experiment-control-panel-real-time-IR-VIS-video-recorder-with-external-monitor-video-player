function [ir,vis] = get_data(file_name,crop_cors, save_it, remarks)
tic

max_loop_run = 1000; % 1000: scan all
final_img_disp = 0; % display last frame of each video: 0 = no, 1 = yes.
start_time = 0; % time to start the calculations. 0: runs from the begining of the video file
end_time = 0; % time to finish the calculations. 0: runs until the end of the video file
N = 1; % Divides the large ROI to NxN squares
newFrameRate = 0; % changes VID video frame rate
enhance_image = 0; % enhancment of the image before processing: 0 = no, 1 = yes.
%normalize = 1; % normalize graylevel. 0 = no, 1 = yes.

% video file name to open:
subFolder = 'Recordings\';
file2load = fullfile(subFolder,file_name);
file_details = whos('-file', file2load);
max_data_vars = round((numel(file_details)-1)/2);
calc_count = 1;
k = 1;

for idx=1:max_loop_run

    [raw_vis, raw_ir, var_name, properties] = get_raw_vid(file2load, idx, 'VISIR', 2); % get video from data file
    
    if isa(properties, 'struct')
       last_properties = properties;
    end

    if ndims(raw_ir) > 2
        if exist('ir','var')
            crop_cors = ir{1, 1}.crop_cors;
        end
        ir{k} = roi_intensity(raw_ir, properties, file_name, var_name, idx, N, start_time,...
            end_time, enhance_image, crop_cors, newFrameRate, final_img_disp);
    else
        ir{k} = [];
    end
    
    if ndims(raw_vis) > 2
        if exist('vis','var')
            crop_cors = vis{1, 1}.crop_cors;
        end
        vis{k} = roi_intensity(raw_vis, properties, file_name, var_name, idx, N, start_time,...
            end_time, enhance_image, crop_cors, newFrameRate, final_img_disp);
    else
        vis{k} = [];
    end
    
    if ndims(raw_vis) > 2 || ndims(raw_ir) > 2
        disp(['Calculating... ', num2str(calc_count), '/', num2str(max_data_vars), ' (',...
            num2str(round(((calc_count/max_data_vars)*100),2)), ' %)'])
        
        calc_count = calc_count + 1;
    end
    
    k=k+1;
end
properties = last_properties;
disp ('Done.');


%% Save data to file:

if save_it == 1

    [~, dir_feedback, ~] = mkdir ('Analayzed data'); % creates dir if it doesn't exist yet
    filename = avoidOverwrite([file_name,'.mat'], [pwd, '\Analayzed data\'], 3);
    filename = erase(filename, '.mat');
    Analayzed_file_location =(['Analayzed data\', filename]);

    if exist('vis','var') && exist('ir','var')
        save(Analayzed_file_location, 'vis', 'ir', 'properties', 'remarks');
    else

        if exist('ir','var')
            save(Analayzed_file_location, 'ir', 'properties', 'remarks');
        end

        if exist('vis','var')
            save(Analayzed_file_location, 'vis', 'properties', 'remarks');
        end

    end

    disp(['Data file saved sucsusfully (', Analayzed_file_location, '.mat)'])

end
toc
end

