function data = IR_analysis(data, file2load, N, start_time, end_time, enhance_image, crop_cor1, ROIcomparison, average2zero)
%% Load data
tic
disp ('[0] Loading IR video data...');

try
    load(file2load, '-regexp', '^(?!buffer_VIS)\w'); % loads all variables except buffer_VIS
catch
    error('Could not load data file') % no data file to process
    return
end

if exist('buffer_IR','var') == 0
    error('No video file to process was found inside the selected data file') % no data file to process
    return
end

%% Prepare variables
k = 1;

if ndims(buffer_IR) == 3
    IRpalette = 0;
elseif ndims(buffer_IR) == 4
    IRpalette = 1;
else
    error('No video file to process was found inside the selected data file') % no data file to process
    return
end


len = length(buffer_IR); % number of recorded frames

NaNidx = find(isnan(play_list(:,7)),1); % check if there's NaN in the FPS data vector

if isempty(NaNidx) == 1
    frameRate = mean(play_list(:,7)); % calculate average frame rate of all indices
else
    frameRate = mean(play_list(1:NaNidx-1,7)); % calculate average frame rate until the NANs
end

if start_time == 0 % setting parameters to the desired begining
    frameStart = 1;
else
    frameStart = round(start_time*frameRate);
end

if end_time == 0 % setting the end time
    
    if exist('play_list','var') == 1
        end_time = sum(play_list(:,2));
    else
        end_time = (single(t(end,1)) / 1000);
    end
    
    frameStop = len;
    
else
    
    frameStop = round(end_time*frameRate); % defining the frame number to stop the calculation at

end

if frameStop > len % for cases frameStop is larger then max frames
    frameStop = len;
end

duration = end_time-start_time;
numOfFrames = single(frameStop - frameStart);

data.IR = single(zeros(floor(frameRate*(duration).*0.9), N^2));

if numel(ROIcomparison) == 4 | ROIcomparison == 1   
    data.IR2 = single(zeros(floor(frameRate*(duration).*0.9), N^2));
end

cor = zeros(N^2,4);

%% loop over the frames
while (k <= (frameStop - frameStart + 1))% running on each frame of the video file
    
    clc
    disp ('[1] Extracting signal from face regions...'); % displays precentage of progress
    disp ([num2str(round((k /(numOfFrames))*100)), ' [%]']);
    
    if IRpalette == 0
        
        frame = buffer_IR(:,:,k + frameStart - 1); % reads current frame from gray IR video
        
    elseif IRpalette == 1
        
        frame = buffer_IR(:,:,:,k + frameStart - 1); % reads current frame from color IR video
        
    end
    
    if enhance_image == 1 && IRpalette == 1
        
        frame = img_enhancement(frame); % calls image enhancement function
        
    end
    
    if k == 1 % case first loop run
        
        if crop_cor1 == 0
            
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

data.IR_crop_cor1 = uint16(crop_cor1); % save cropping coordinates
data.frame_rate = frameRate;
data.fps = single(fps);
data.t = t;
data.N = N;
data.start_time = start_time;
data.end_time = end_time;

data.ROI1_size = uint16(size(cropped_frame));
data.ROI1_max_temp = max(data.IR);
data.ROI1_min_temp = min(data.IR);
data.ROI1_max_temp_diff = data.ROI1_max_temp - data.ROI1_min_temp;

if properties.playVideofiles == 1
    
    data.play_list_fields = play_list_fields;
    
    if isempty(NaNidx) == 1
    
        data.playlist = playlist;
        data.play_list = play_list;
        
    else % case need to slice the NAN's
        
        data.playlist = playlist;
        data.play_list = play_list(1:NaNidx-1,:);
        
    end
    
end

if properties.popup == 1
    
    data.feel = uint8(feel);
    data.posneg = uint8(posneg);
    data.wake = uint8(wake);
    
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

file_name = retrieve_name(file2load); % get file name from full file path

figure('Name','IR camera: ROI selected');
imshow(frame,[]); axis on; % plotting image and channels locations
title(['Video file name: ', file_name], 'Interpreter', 'none');

for i=1:N^2 % 1st ROI
    rectangle('Position',cor(i,:),'LineWidth',1,'EdgeColor','k'); % prints channels (1st ROI) rectangular
    text(cor(i,1) + round(cor(i,3)/15), cor(i,2) +...
        round(cor(i,4)/15), num2str(i)); % prints channels numbers
end

if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4 % 2nd ROI
    for i=1:N^2
        rectangle('Position',cor2(i,:),'LineWidth',1,'EdgeColor','b'); % prints channels (2nd ROI) rectangular
        text(cor2(i,1) + round(cor2(i,3)/15), cor2(i,2) +...
            round(cor2(i,4)/15), num2str(i)); % prints channels numbers
    end
end

%% Finish
clc
disp ('Done.');
toc
end % end of function