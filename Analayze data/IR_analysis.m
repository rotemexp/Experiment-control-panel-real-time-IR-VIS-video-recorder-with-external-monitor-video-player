function data = IR_analysis(ir, properties, file_name, vid_num, N, start_time, end_time,...
    enhance_image, crop_cor1, ROIcomparison, average2zero, final_img_disp)
%% Prepare variables
k = 1;

if ndims(ir) == 3
    IRpalette = 0;
    len = size(ir,3); % get number of recorded frames
elseif ndims(ir) == 4
    IRpalette = 1;
    len = size(ir,4); % get number of recorded frames
else
    error('No video file to process was found') % no data file to process
    return
end

if isfield(properties, 'play_list') == 1

    NaNidx = find(isnan(properties.play_list(:,8)),1); % check if there's NaN in the properties.timing data vector

    if isempty(NaNidx) == 1
        frameRate = mean(properties.play_list(:,8)); % calculate average frame rate of all indices
    else
        frameRate = mean(properties.play_list(1:NaNidx-1,8)); % calculate average frame rate until the NANs
    end

else
    frameRate = mean(properties.raw_timing(:, 2));
end

if start_time == 0 % setting parameters to the desired begining
    frameStart = 1;
else
    frameStart = round(start_time*frameRate);
end

if end_time == 0 % setting the end time

    if isfield(properties, 'play_list') == 1
        end_time = sum(properties.play_list(:,2));
    else
        end_time = (single(properties.t(end,1)) / 1000);
    end
    
    frameStop = len;
    
else
    
    frameStop = round(end_time*frameRate); % defining the frame number to stop the calculation at

end

if frameStop > len % for cases frameStop is larger then max frames
    frameStop = len;
end

%duration = end_time-start_time;
numOfFrames = single(frameStop - frameStart + 1);

data.IR = zeros(numOfFrames, N^2, 'single');

if numel(ROIcomparison) == 4 | ROIcomparison == 1   
    data.IR2 = zeros(numOfFrames, N^2, 'single');
end

cor = zeros(N^2,4);

%% loop over the frames
while k <= numOfFrames% running on each frame of the video file
    
    %clc
    %disp ('[1] Extracting signal from face regions...'); % displays precentage of progress
    %disp ([num2str(round((k /(numOfFrames))*100)), ' [%]']);
    
    if IRpalette == 0
        frame = ir(:,:,k + frameStart - 1); % reads current frame from gray IR video
    elseif IRpalette == 1
        frame = ir(:,:,:,k + frameStart - 1); % reads current frame from color IR video
    end
    
    if enhance_image == 1 && IRpalette == 1
        frame = img_enhancement(frame); % calls image enhancement function
    end
    
    if k == 1 % case first loop run
        
        if length(crop_cor1) ~= 4
            
            % change values from temperature (C) to uint8
            im = frame - min(min(frame));
            im = im ./ max(max(im));
            im = im2uint8(im);
            
            crop_cor1 = ROIcrop(2, im); % calls ROI crop function
            
        end
        
        if numel(ROIcomparison) == 4
            
            crop_cor2 = ROIcomparison;
            
        else
            
            if ROIcomparison == 1 % case the user need to provide 2nd ROI coordinates
                
                % change values from temperature (C) to uint8
                im = frame - min(min(frame));
                im = im ./ max(max(im));
                im = im2uint8(im);
                
                crop_cor2 = ROIcrop(2, im); % calls ROI crop function again
                
            end
        end
        
        %tic
        
    end
    
    cropped_frame = imcrop(frame,crop_cor1); % cropping the frame
    
    %if normalize == 1
    %    cropped_frame = cropped_frame ./ max(max(cropped_frame)); % normalize data to 0-1
    %end
    
    data.IR(k,:) = intensity_calc(N, cropped_frame, 0); % calculate averaged intensity at ROI's
    
    if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4 % case 2nd ROI needs to be calculated
        
        cropped_frame2 = cropped_frame2 ./ max(max(cropped_frame2)); % normalize data to 0-1
        
        %if normalize == 1
        %    cropped_frame2 = im2double(cropped_frame2); % normalize data to 0-1
        %end
        
        data.IR2(k,:) = intensity_calc(N, cropped_frame2, 0); % calculate averaged intensity at 2nd ROI
        
    end
    
    if k == 1 % case first loop run
        cor = intensity_calc(N, cropped_frame, crop_cor1); % get all small ROI's cropped coordinates
        
        if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4
            cor2 = intensity_calc(N, cropped_frame2, crop_cor2); % get all small ROI's cropped coordinates
        end
    end
    
    k = k + 1; % increasing the loop index for the next frame extraction itteration
end % end hasframe while loop

%% Some more calculations

data.vid_num = vid_num;
data.file_name = file_name;
data.IR_crop_cor1 = uint16(crop_cor1); % save cropping coordinates
data.frame_rate = frameRate;
data.t = properties.t;
data.N = N;
data.start_time = start_time;
data.end_time = end_time;
data.raw_timing = properties.raw_timing;

data.ROI1_size = uint16(size(cropped_frame));
data.ROI1_max_temp = max(data.IR);
data.ROI1_min_temp = min(data.IR);
data.ROI1_max_temp_diff = data.ROI1_max_temp - data.ROI1_min_temp;

if properties.playVideofiles == 1
    
    data.timing = properties.timing;
    data.play_list_fields = properties.play_list_fields;
    
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

if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4
    data.IR_diff = abs(data.IR - data.IR2); % calculates the difference between the 2 ROI's
    data.IR_crop_cor2 = crop_cor2; % save 2nd cropping coordinates
    
    if average2zero == 1
        data.IR2 = data.IR2 - mean(data.IR2);
    end
end

if average2zero == 1
    data.IR = data.IR - mean(data.IR);
end

%% plot frame
if final_img_disp == 1
    
    figure('Name','IR camera: ROI selected');
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

%% Finish
%clc
%disp ('Done.');
%toc
end % end of function