function data = VIS_analysis(data, file2load, N, start_time, end_time, improve_img, crop_cor1, ROIcomparison, newFrameRate)
%% Load data
tic
disp ('[0] Loading VIS camera data...');

try
    load(file2load);
catch
    error('Could not load data file') % no data file to process
    return
end

if  exist('buffer_R','var') == 0 && exist('buffer_G','var') == 0 ...
        && exist('buffer_B','var') == 0 && exist('buffer_VIS','var') == 0
    error('o video file to process was found inside the selected data file') % no data file to process
    return
end
%% Prepare variables

if exist('buffer_VIS','var') == 0
    RGB = 1;
    len = length(buffer_R);
else
    RGB = 0;
    len = length(buffer_VIS);
end

if newFrameRate == 0 % case no need to change frame rate
    if frame_rate == 0
        frame_rate = mean(FPS(:,1));
    else
        newFrameRate = frame_rate;
    end
    skipper = 1;
else
    skipper = newFrameRate / frame_rate; % calculates the skipper value
    skipper = round(1/skipper); % inverts and rounds the skipper value to the nearest decent value that can divide the original frmae rate
    newFrameRate = frame_rate / skipper; % updates the new frame rate value
    frame_rate = newFrameRate; % assignts it to a local variable so function could work after vidObj was closed
end

if start_time == 0 % setting parameters to the desired begining
    frameStart = 1;
else
    frameStart = round(start_time*frame_rate);
end

if end_time == 0 % setting the end time in range
    end_time = (single(t(end,1)) / 1000);
end

frameStop = round(end_time*frame_rate); % defining the frame number to stop the calculation at

if frameStop > len % for cases frameStop is larger then max frames
    frameStop = len;
end

k_skipper = frameStart;
% duration = params.endTime-params.startTime;
numOfFrames = single(frameStop - frameStart);
k = double(1);

%% loop over the frames

while (k <= (frameStop - frameStart + 1))% running on each frame of the video file
    clc
    disp ('[1] Extracting signal from face regions...'); % displays precentage of progress
    disp ([num2str(round((k /(numOfFrames))*100)), ' [%]']);
    
    if RGB == 1
        img(:,:,1) = buffer_R(:,:,k);
        img(:,:,2) = buffer_G(:,:,k);
        img(:,:,3) = buffer_B(:,:,k);
        
    else
        img = buffer_VIS(:,:,k);
    end
    
    frame = im2double(img); % reads current frame from video
    
    if improve_img == 1
        frame = improve_img(frame); % calls image enhancement function
    end
    
    if mod(k,skipper) == 0 % checks if this frame needs to be calculated according to the new frame rate
        
        if k == 1 % case first loop run
            
            if crop_cor1 == 0 || crop_cor1 == 1
                crop_cor1 = ROIcrop(2, frame); % calls ROI crop function
            end
            
            if numel(ROIcomparison) == 4
                crop_cor2 = ROIcomparison;
            else
                if ROIcomparison == 1 % case the user need to provide 2nd ROI coordinates
                    crop_cor2 = ROIcrop(2, frame); % calls ROI crop function again
                end
            end
            
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
clc
disp ('Calculating chrominance data'); % displays progress

if RGB == 1
    
    V = 1.5.*data.R(frameStart:k_skipper - 1, :) + 2.*data.G(frameStart:k_skipper - 1, :)...
        - 1.5.*data.B(frameStart:k_skipper - 1, :);
    U = 3.*data.R(frameStart:k_skipper - 1, :) - 2.*data.G(frameStart:k_skipper - 1, :);

    lambda = std(U) ./ std(V);
    data.VIS = U - lambda.*V; % final data matrix: equation 3 in the paper
    
    if ROIcomparison(1) == 1 || numel(ROIcomparison) == 4 % case 2nd ROI exists
        V = 1.5.*data.R2(frameStart:k_skipper - 1, :) + 2.*data.G2(frameStart:k_skipper - 1, :)...
            - 1.5.*data.B2(frameStart:k_skipper - 1, :);
        U = 3.*data.R2(frameStart:k_skipper - 1, :) - 2.*data.G2(frameStart:k_skipper - 1, :);

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

tvec = single((frameStart + 1 : len + frameStart) ./ frame_rate);
data.tvec = tvec';

if exist('play_list', 'var') == 1
    data.eventsTiming = play_list(:,3:4); % takes the start and end time of videos playback
end

data.VIS_exist = 1;
data.VIS_crop_cor1 = crop_cor1; % save cropping coordinates
data.frame_rate = frame_rate;
data.FPS = single(FPS);
data.t = t;
data.N = N;
data.start_time = start_time;
data.end_time = end_time;

%% plot

file_name = retrieve_name(file2load); % get file name from full file path

figure('Name','VIS camera: ROI selected');
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

clc
disp ('Done.');
toc
end % end of function