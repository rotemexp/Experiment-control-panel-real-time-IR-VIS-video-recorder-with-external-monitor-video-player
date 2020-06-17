function data = VIS_analysis(vis, properties, file_name, vid_num, N, start_time, end_time,...
    enhance_image, crop_cor1, ROIcomparison, newFrameRate, final_img_disp)
%% Prepare variables

if ndims(vis) == 3
    RGB = 0;
    len = size(vis,3); % get number of recorded frames
elseif ndims(vis) == 4
    RGB = 1;
    len = size(vis,4); % get number of recorded frames
else
    error('No video file to process was found inside the selected data file') % no data file to process
    return
end

if isfield(properties, 'play_list') == 1
    
    NaNidx = find(isnan(properties.play_list(:,8)),1); % check if there's NaN in the properties.timing data vector
    
    if isempty(NaNidx) == 1
        frameRate = mean(properties.play_list(:,8)); % calculate average frame rate of all indices
    else
        frameRate = mean(properties.play_list(1:NaNidx-1,8)); % calculate average frame rate until the NANs
    end
    
    if newFrameRate == 0 % case no need to change frame rate
        if properties.frame_rate == 0
            properties.frame_rate = mean(properties.timing(:,1));
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
    frameRate = mean(properties.raw_timing(:, 2));
end

if start_time == 0 % setting parameters to the desired begining
    frameStart = 1;
else
    frameStart = round(start_time*properties.frame_rate);
end

if end_time == 0 % setting the end time
    
    if isfield(properties, 'play_list') == 1
        end_time = sum(properties.play_list(:,2));
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

k_skipper = frameStart;
% duration = params.endTime-params.startTime;
numOfFrames = single(frameStop - frameStart + 1);
k = double(1);


if RGB == 1
    data.R = zeros(numOfFrames, N^2, 'single');
    data.G = zeros(numOfFrames, N^2, 'single');
    data.B = zeros(numOfFrames, N^2, 'single');
else
    data.VIS = zeros(numOfFrames, N^2, 'single');
end

%% loop over the frames

while k <= numOfFrames % running on each frame of the video file
    
    %clc
    %disp ('[1] Extracting signal from face regions...'); % displays precentage of progress
    %disp ([num2str(round((k /(numOfFrames))*100)), ' [%]']);
    
    if RGB == 1
        img = vis(:,:,:,k + frameStart - 1); % color
    else
        img = vis(:,:,k + frameStart - 1); % gray
    end
    
    frame = im2double(img); % reads current frame from video
    
    if enhance_image == 1
        frame = img_enhancement(frame); % calls image enhancement function
    end
    
    if mod(k,skipper) == 0 % checks if this frame needs to be calculated according to the new frame rate
        
        if k == 1 % case first loop run
            
            if length(crop_cor1) ~= 4
                crop_cor1 = ROIcrop(2, frame); % calls ROI crop function
            end
            
            if numel(ROIcomparison) == 4
                crop_cor2 = ROIcomparison;
            else
                if ROIcomparison == 1 % case the user need to provide 2nd ROI coordinates
                    crop_cor2 = ROIcrop(2, frame); % calls ROI crop function again
                end
            end
            
            %tic
            
        end
        
        cropped_frame = imcrop(frame,crop_cor1); % cropping the frame
        
        if RGB == 1
            data.R(k,:) = intensity_calc(N, cropped_frame(:,:,1), 0); % calculate averaged R channel intensity at ROI's
            data.G(k,:) = intensity_calc(N, cropped_frame(:,:,2), 0); % calculate averaged G channel at ROI's
            data.B(k,:) = intensity_calc(N, cropped_frame(:,:,3), 0); % calculate averaged B channel at ROI's
        else
            data.VIS(k,:) = intensity_calc(N, cropped_frame, 0); % calculate averaged intensity at ROI's
        end
        
        if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4 % case 2nd ROI needs to be calculated
            
            cropped_frame2 = imcrop(frame,crop_cor2); % cropping the 2nd frame
            
            if RGB == 1
                data.R2(k,:) = intensity_calc(N, cropped_frame2(:,:,1), 0); % calculate averaged R channel intensity at ROI's
                data.G2(k,:) = intensity_calc(N, cropped_frame2(:,:,2), 0); % calculate averaged G channel at ROI's
                data.B2(k,:) = intensity_calc(N, cropped_frame2(:,:,3), 0); % calculate averaged B channel at ROI's
            else
                data.VIS2(k,:) = intensity_calc(N, cropped_frame2, 0); % calculate averaged intensity at ROI's
            end
            
        end
        
        if k == 1 % case first loop run
            cor = intensity_calc(N, cropped_frame, crop_cor1); % get all small ROI's cropped coordinates
            
            if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4
                cor2 = intensity_calc(N, cropped_frame2, crop_cor2); % get all small ROI's cropped coordinates
            end
        end
        
        k_skipper = k_skipper + 1; % increasing the skipping index
        
    end % end if frame needs to be calculated
    
    k = k + 1; % increasing the loop index for the next frame extraction itteration
    
end % end while

%% Some more calculations

if RGB == 1
    
    V = 1.5.*data.R + 2.*data.G - 1.5.*data.B;
    U = 3.*data.R - 2.*data.G;
    
    lambda = std(U) ./ std(V);
    data.VIS = U - lambda.*V; % final data matrix: equation 3 in the paper
    
    if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4 % case 2nd ROI exists
        V = 1.5.*data.R2 + 2.*data.G2 - 1.5.*data.B2;
        U = 3.*data.R2 - 2.*data.G2;
        
        lambda = std(U) ./ std(V);
        data.VIS2 = U - lambda.*V; % final data matrix: equation 3 in the paper
        
        data.VIS_diff = abs(data.VIS - data.VIS2); % calculates the difference between the 2 ROI's
        data.VIS_crop_cor2 = crop_cor2; % save 2nd cropping coordinates
    end
    
else
    
    if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4 % case 2nd ROI exists
        data.VIS_diff = abs(data.VIS - data.VIS2); % calculates the difference between the 2 ROI's
        data.VIS_crop_cor2 = crop_cor2; % save 2nd cropping coordinates
    end
    
end

data.vid_num = vid_num;
data.file_name = file_name;
data.VIS_crop_cor1 = uint16(crop_cor1); % save cropping coordinates
data.frame_rate = properties.frame_rate;
data.t = properties.t;
data.N = N;
data.start_time = start_time;
data.end_time = end_time;
data.raw_timing = properties.raw_timing;

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
    
    data.feel = properties.feel;
    data.posneg = properties.posneg;
    data.wake = properties.wake;
    
end

%% plot
if final_img_disp == 1
    
    figure('Name','VIS camera: ROI selected');
    imshow(frame,[]); axis on; % plotting image and channels locations
    title(['Video file name: ', file_name], 'Interpreter', 'none');
    
    for i=1:N^2 % 1st ROI
        rectangle('Position',cor(i,:),'LineWidth',1,'EdgeColor','k'); % prints channels (1st ROI) rectangular
        text(double(cor(i,1) + round(cor(i,3)/15)), double(cor(i,2) +...
            round(cor(i,4)/15)), num2str(i)); % prints channels numbers
    end
    
    if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4 % 2nd ROI
        for i=1:N^2
            rectangle('Position',cor2(i,:),'LineWidth',1,'EdgeColor','b'); % prints channels (2nd ROI) rectangular
            text(double(cor2(i,1) + round(cor2(i,3)/15)), double(cor2(i,2) +...
                round(cor2(i,4)/15)), num2str(i)); % prints channels numbers
        end
    end
    
else
    
    figure('Name','IR camera: ROI selected', 'visible', 'off');
    imshow(frame,[]);
    hold on;
    axis on; % plotting image and channels locations
    title(['Video file name: ', file_name], 'Interpreter', 'none');
    
    for i=1:N^2 % 1st ROI
        rectangle('Position',cor(i,:),'LineWidth',1,'EdgeColor','k'); % prints channels (1st ROI) rectangular
        text(double(cor(i,1) + round(cor(i,3)/15)), double(cor(i,2) +...
            round(cor(i,4)/15)), num2str(i)); % prints channels numbers
    end
    
    if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4 % 2nd ROI
        for i=1:N^2
            rectangle('Position',cor2(i,:),'LineWidth',1,'EdgeColor','b'); % prints channels (2nd ROI) rectangular
            text(double(cor2(i,1) + round(cor2(i,3)/15)), double(cor2(i,2) +...
                round(cor2(i,4)/15)), num2str(i)); % prints channels numbers
        end
    end
    
    F = getframe;
    data.last_frame = F.cdata;
    close(figure)
    
end

%clc
%disp ('Done.');
%toc
end % end of function