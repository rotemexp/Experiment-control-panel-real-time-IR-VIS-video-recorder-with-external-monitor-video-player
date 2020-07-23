function data = Hemoglobin_mapper(vid, properties, file_name, var_name, vid_num, N, start_time,...
    end_time, enhance_image, crop_cors, newFrameRate, final_img_disp, roi_labels, videos_idx_emotions)
%% Pre-flight check

if ndims(vid) == 3
    dim4 = 0;
    len = size(vid,3); % get number of recorded frames
elseif ndims(vid) == 4
    dim4 = 1;
    len = size(vid,4); % get number of recorded frames
else
    disp('No video file to process was found inside the selected data file') % no data file to process
    return
end

if isa(vid, 'uint8')
    type = 'VIS';
elseif isa(vid, 'single')
    type = 'IR';
else
    disp('Video file could not decide whether it is VIS or IR') % no data file to process
    return
end

%% Prepare variables

vid_play_order = str2double(extractBefore(var_name, '_'));

if isfield(properties, 'play_list') == 1
    
    NaNidx = find(isnan(properties.play_list(:,8)),1); % check if there's NaN in the properties.timing data vector
    
%     if isempty(NaNidx) == 1
%         frameRate = mean(properties.play_list(:,8)); % calculate average frame rate of all indices
%     else
%         frameRate = mean(properties.play_list(1:NaNidx-1,8)); % calculate average frame rate until the NANs
%     end
    
    if newFrameRate == 0 % case no need to change frame rate
        if properties.frame_rate == 0
            properties.frame_rate = properties.play_list(vid_play_order,8);
        else
            newFrameRate = properties.frame_rate;
        end
        skipper = 1;
    else
        skipper = newFrameRate / properties.frame_rate; % calculates the skipper value
        skipper = round(1/skipper); % inverts and rounds the skipper value to the nearest decent value that can divide the original frmae rate
        newFrameRate = properties.frame_rate / skipper; % updates the new frame rate value
        properties.frame_rate = newFrameRate; % assignts it to a local variable so function could work after vidObj was closed
    end
    
else
    skipper = 1;
    %frameRate = mean(properties.raw_timing(:, 2));
end

if start_time == 0 % setting parameters to the desired begining
    frameStart = 1;
else
    frameStart = round(start_time*properties.frame_rate);
end

if end_time == 0 % setting the end time
    
    if isfield(properties, 'play_list') == 1
        end_time = properties.play_list(vid_play_order,2);
    else
        end_time = (single(properties.t(end,1)) / 1000);
    end
    
    frameStop = len;
    
else
    frameStop = round(end_time*properties.frame_rate); % defining the frame number to stop the calculation at
end

if frameStop > len % for cases frameStop is larger then max frames
    frameStop = len;
end

if size(crop_cors, 2) == 4
    ROIs_num = size(crop_cors, 1);
else
    ROIs_num = crop_cors;
    
    if dim4 == 1
        frame = vid(:,:,:,frameStart); % color
    else
        frame = vid(:,:,frameStart); % gray
    end
    
    if strcmp(type, 'VIS')
        frame = im2double(frame); % reads current frame from video
    elseif strcmp(type, 'IR')
        % change values from temperature (C) to uint8
        im = frame - min(min(frame));
        im = im ./ max(max(im));
        frame = im2uint8(im);
    end
    
    crop_cors = zeros(ROIs_num, 4);
    
    for i=1:ROIs_num
        crop_cors(i, :) = ROIcrop(2, frame); % calls ROI crop function
    end
end

numOfFrames = single(frameStop - frameStart + 1);
k = 1;

if dim4 == 1
    data.R = zeros(numOfFrames, ROIs_num, 'single');
    data.G = zeros(numOfFrames, ROIs_num, 'single');
    data.B = zeros(numOfFrames, ROIs_num, 'single');
end

data.sig = zeros(numOfFrames, ROIs_num, 'single');

%% loop over the frames

while k <= numOfFrames % running on each frame of the video file
    
    if dim4 == 1
        frame = vid(:,:,:,k + frameStart - 1); % color
    else
        frame = vid(:,:,k + frameStart - 1); % gray
    end

    if enhance_image == 1
        frame = img_enhancement(frame); % calls image enhancement function
    end
    
    for i=1:ROIs_num
        
        cropped_frame{i} = imcrop(frame, crop_cors(i,:)); % cropping the frame

        if dim4 == 1
            
            
            for n=1:3
                maxi = max(max(cropped_frame{i}(:,:,n)));
                mini = min(min(cropped_frame{i}(:,:,n)));
                for m=mini:maxi
                    tmp_frame = cropped_frame{i}(:,:,n);
                    [r, c] = find(tmp_frame == m);
                end
            end
            

        end

    end
    k = k + 1;
end % end while


%% Parameters transfer

data.process_time = datetime;
data.process_time_unix = posixtime(datetime);
data.roi_labels = roi_labels;
data.type = type;
data.crop_cors = crop_cors;
data.play_order = uint8(str2double(extractBefore(var_name, '_')));
data.var_name = var_name;
data.vid_num = vid_num;
data.file_name = file_name;
data.VIS_crop_cor1 = uint16(crop_cors); % save cropping coordinates
data.frame_rate = properties.frame_rate;
data.t = properties.t;
data.N = N;
data.start_time = start_time;
data.end_time = end_time;
data.raw_timing = properties.raw_timing;

if vid_num <= length(videos_idx_emotions)
    data.expected_emotion = videos_idx_emotions(vid_num, 2);
else
    data.expected_emotion = 'nan';
end

if properties.playVideofiles == 1
    
    data.timing = properties.timing;
    data.timing_fields = properties.timing_fields;
    
    if isempty(NaNidx) == 1
        
        data.playlist = properties.playlist;
        data.play_list = properties.play_list;
        
    else % case need to slice the NAN's
        
        data.playlist = properties.playlist;
        data.play_list = properties.play_list(1:NaNidx-1,:);
        
    end
    
end

if properties.popup == 1
    try
        data.feel = properties.feel;
        data.posneg = properties.posneg;
        data.wake = properties.wake;
        data.age = properties.age;
        data.sex = properties.sex;
        data.orientation = properties.orientation;
    catch
    end
end

%% Show / Save last frame

if final_img_disp == 1
    
    figure('Name','vid camera: ROI selected');
    imshow(frame,[]); axis on; % plotting image and channels locations
    title(['Video file name: ', file_name], 'Interpreter', 'none');
    
    for i=1:ROIs_num % 1st ROI
        rectangle('Position', crop_cors(i,:),'LineWidth',1,'EdgeColor','k'); % prints channels (1st ROI) rectangular
        text(double(crop_cors(i,1) + round(crop_cors(i,3)/15)), double(crop_cors(i,2) +...
            round(crop_cors(i,4)/15)), num2str(i)); % prints channels numbers
    end
    
end
    
figure('Name','IR camera: ROI selected', 'visible', 'off');
imshow(frame,[]);
hold on;
axis on; % plotting image and channels locations
title(['Video file name: ', file_name], 'Interpreter', 'none');

for i=1:ROIs_num % 1st ROI
    rectangle('Position', crop_cors(i,:),'LineWidth',1,'EdgeColor','k'); % prints channels (1st ROI) rectangular
    text(double(crop_cors(i,1) + round(crop_cors(i,3)/15)), double(crop_cors(i,2) +...
        round(crop_cors(i,4)/15)), num2str(i)); % prints channels numbers
end

F = getframe;
data.last_frame = F.cdata; % save last frame into data
close(figure)

end % end of function