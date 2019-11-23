function recorder(app, properties)
%% Initializing IR camera
% status(app, status_text, status_color, draw, stop)
clc;
global viewer_is_running; % initialize the main frame grabber loop as global variable
global IRInterface; % initialize the interface as a global variable
err = 0; % declare no errors so far

if properties.IR_camera == 1
    try
        err = status(app, 'Connecting to IR camera...', 'g', 1, 0);
        
        IRInterface = EvoIRMatlabInterface;
        IRViewer = EvoIRViewer; % initialize the viewer
        close(1); % closes the Evocortex special window, so a new "regular" figure window will be opnened.
        viewer_is_running = 1; % ok to run frame grabber loop
        
        if ~IRInterface.connect()
            close all;
            err = status(app, 'Error connecting to IR camera.', 'r', 1, 1);
        end
        
    catch
        err = status(app, 'Error connecting to IR camera.', 'r', 1, 1);
    end
end
%% Initializing VIS camera
if properties.VIS_camera == 1 && err == 0
    try
        err = status(app, 'Connecting to VIS camera...', 'g', 1, 0);
        cam = webcam(properties.camera2connect);
        cam.Resolution = properties.camera_resolution;
        viewer_is_running = 1; % ok to run frame grabber loop
    catch
        err = status(app, 'Error connecting to VIS camera.', 'r', 1, 1);
    end
end

%% Initializing VLC player and playlist files
if properties.playVideofiles == 1 && err == 0
    try
        err = status(app, 'Initializing VLC player and playlist video files...', 'g', 1, 0);
        v = VLC(); % creating VLC object
        v.play('black.png'); % display black screen
    catch
        err = status(app, 'Error connecting to VLC player.', 'r', 1, 1);
    end
    
    try
        
        for i=1:length(properties.playlist_idx) % creating the playlist by the right order (idx)
            playlist(i) = properties.list(properties.playlist_idx(i));
            playlist(i).idx = i;
        end
        
        playlist(1).startTime = 0;
        playlist(1).endTime = 0;
        list_length = length(playlist);
    catch
        err = status(app, 'Error loading video files playlist.', 'r', 1, 1);
    end
end
%% Saving data file
if properties.save_data == 1 && err == 0
    err = status(app, 'Creating data file to save videos to...', 'g', 1, 0);
    
    if properties.timeStamp4savedFile == 0
        filename = ['Recordings\', properties.title, '.mat']; % file name without timestamp
    elseif properties.timeStamp4savedFile == 1
        filename = ['Recordings\', properties.title, '_', num2str(now), '.mat']; % file name with timestamp
    end
    
    try
        save(filename,'-v7.3','properties'); % creates the data file and stores first variable in it
    catch
        err = status(app, 'Error creating and saving data file, program ends.', 'r', 1, 1);
    end
end

%% Setting frame loop parameters
idx = 1;
j = 1;
q = 1;
playFlag = 2;
videosPlayed = 0;
frameCount = 0;
tLast_play = 1;
tLast_display = 1;
t = uint64(zeros(1));
t_seg = zeros(2,1);
tStart = tic;

if properties.crop_cor ~= 0
    crop_cor = str2num(properties.crop_cor); % case should crop VIS image
end

if properties.VIS_camera == 0 && properties.IR_camera == 0
    err = status(app, 'No camera was selected.', 'r', 1, 1);
end

if properties.IR_camera == 1 && err == 0
    IRViewer.trigger_shutter_flag(); % triggers flag (temperature drift reset)
end

if properties.warm_up == 1 && err == 0 % delay recording if needed
    if properties.VIS_camera == 1
        err = warm_up(app, properties, cam);
    else
        err = warm_up(app, properties);
    end
    tStart = tic;
end

if properties.save_data == 1 && err == 0
    err = status(app, 'Recording...', 'g', 1, 0);
elseif properties.save_data == 0 && err == 0
    err = status(app, 'Playing live stream...', 'g', 1, 0);
end

%% Frames loop
while(viewer_is_running) % main loop
    
    if properties.constantFrameRate ~= 0
        while t_seg(2) - t_seg(1) <= (1000/properties.constantFrameRate) % checks if elpased time is larger then 0.125 sec
            t_seg(2) = (round(toc(tStart)*1000)); % saves time delta
        end
        t_seg(1) = t_seg(2); % updates last time stamp
    end
    
    t(idx) = (round(toc(tStart)*1000)); % saves time delta
    
    if properties.VIS_camera == 1
        
        if properties.gray == 1
            frame_VIS = rgb2gray(snapshot(cam)); % get imgage from VIS camera if needed and transform to gray
        else
            frame_VIS = snapshot(cam); % get imgage from VIS camera if needed
        end
        if properties.crop_cor ~= 0
            frame_VIS = imcrop(frame_VIS,crop_cor); % cropping the frame
        end
        
    end
    
    if properties.IR_camera == 1
        if properties.tempORcolor == 1
            THM = single(IRInterface.get_thermal()); % get gray image from IR camera
            frame_IR = ((THM - 10000) ./ 100); % change values to Celsius temperature values
        elseif properties.tempORcolor == 0
            frame_IR = (IRInterface.get_palette()); % get color image from IR camera
        end
    end
    
    if properties.save_data == 1
        try
            if properties.VIS_camera == 1
                if properties.gray == 1
                    buffer_VIS(:,:,idx) = frame_VIS; % storing VIS camera gray image
                else
                    buffer_R(:,:,idx) = frame_VIS(:,:,1); % storing VIS camera RED image
                    buffer_G(:,:,idx) = frame_VIS(:,:,2); % storing VIS camera GREEN image
                    buffer_B(:,:,idx) = frame_VIS(:,:,3); % storing VIS camera BLUE image
                end
            end
            if properties.IR_camera == 1
                if properties.tempORcolor == 1
                    buffer_IR(:,:,idx) = frame_IR; % storing IR camera temperature image
                else
                    buffer_IR(:,:,1,idx) = frame_IR(:,:,1); % storing IR camera color image
                    buffer_IR(:,:,2,idx) = frame_IR(:,:,2);
                    buffer_IR(:,:,3,idx) = frame_IR(:,:,3);
                end
            end
        catch
            status(app, 'Error saving buffer data, program ends.', 'r', 1, 1);
            err = 2;
        end
    end
    
    if properties.live_view == 1
        
        if properties.VIS_camera == 1 && properties.IR_camera == 1
            imagesc(subplot(1,2,1),frame_VIS); % draw VIS image
            imagesc(subplot(1,2,2),frame_IR); colormap(gray);% draw IR image
        elseif properties.VIS_camera == 0 && properties.IR_camera == 1
            imagesc(frame_IR); colormap(gray);% draw IR image
        elseif properties.VIS_camera == 1 && properties.IR_camera == 0
            imagesc(frame_VIS); colormap(gray);% draw VIS image
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %{
    frame_IR_palette = (IRInterface.get_palette()); % get color image from IR camera
    buffer_IR_palette(:,:,1,idx) = frame_IR_palette(:,:,1); % storing IR camera color image
    buffer_IR_palette(:,:,2,idx) = frame_IR_palette(:,:,2);
    buffer_IR_palette(:,:,3,idx) = frame_IR_palette(:,:,3);
    %}
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    drawnow(); % updates image and callbacks
    
    if properties.playVideofiles == 1
        
        if t(idx) - t(1) >= properties.initialBlackScreen*1000 && playFlag == 2 % keeps initial black screen
            playFlag = 0;
        end
        
        if (t(idx) - t(tLast_play) >= properties.pauseTime*1000 && playFlag == 0 &&...
                videosPlayed < list_length) || (playFlag == 0 && videosPlayed == 0) % checks if it's time to play a video
            try
                app.Status1.FontColor = [0.29,0.58,0.07]; % dark green
                app.Status1.Value = sprintf('%s', ['Playing video: ', num2str(j), ' / ', num2str(list_length), '.']);
            catch
            end
            v.play([playlist(j).folder, '\', playlist(j).name]);
            playlist(j).startTime = toc(tStart); % saves time stamp to playlist
            playFlag = 1; % marks next time to do a black screen
            tLast_play = idx; % saves the index of the last time found
            videosPlayed = videosPlayed + 1; % increase number of videos played counter
        end
        
        if t(idx) - t(tLast_play) >= properties.playTime*1000 && playFlag == 1 && properties.playTime ~= 0 % checks if elpased time is larger then X
            err = status(app, 'Displaying black screen.', 'g', 1, 0);
            v.play('black.png'); % display black screen
            playlist(j).endTime = toc(tStart); % saves time stamp to playlist
            % IRViewer.trigger_shutter_flag(); % trigger flag (temperature drift reset)
            j = j + 1; % new line at playlist structure
            playFlag = 0; % marks next time to play a video
            tLast_play = idx; % saves the index of the last time found
            
            % pop-up code goes here:
            %if properties.popup == 1 % if popup is desired - get location and call function
            %glb.pos = properties.pos;
            %hf = popup;
            %jframe = getjframe(hf.PleaseanswerthefollowingUIFigure);
            %end
        end
        
        if t(idx) - t(tLast_play) >= properties.lastBlackScreen*1000 && videosPlayed == list_length
            viewer_is_running = 0; % finish program
        end
        
    end
    
    if t(idx) - t(tLast_display) >= 1000 % checks if elpased time is larger then 1 sec
        FPS(1,q) = frameCount;
        FPS(2,q) = (t(idx) / 1000);
        
        try
            if app.FPSCheckBox == 1
                plot(app.UIAxes_FPS, FPS(1,:), '-r'); % updates FPS graph
            end
            
            
            
            app.Status2.Text = sprintf('%s', num2str(t(idx) / 1000)); % updates elapsed time
        catch
        end
        q = q + 1;
        frameCount = 0; % reset the frames counter
        tLast_display = idx; % saves the index of the last time found
        
        if properties.playVideofiles == 1 && properties.verifyFullscreen == 1
            v.Fullscreen = 'on'; % makes VLC player fullscreen
        end
    end
    
    if properties.force_end == 1

        if properties.force_end_seconds == 1 && t(idx) - t(1) >= properties.force_end_period * 1000 ||...
            properties.force_end_seconds == 0 && idx >= properties.force_end_period
            viewer_is_running = 0; % finish program
        end
    
    end
    
    frameCount = frameCount + 1;
    idx = idx + 1;
end
%% Adds data to the saved file
if properties.save_data == 1 && err ~= 1
    
    err = status(app, 'Saving data file...', 'g', 1, 0);
    
    if properties.playVideofiles == 1
        v.quit(); % close VLC player
    end
    
    try
        frame_rate = properties.constantFrameRate;
        save(filename,'t','FPS','frame_rate','-append'); % adds variables to the saved data file
        
        if properties.playVideofiles == 1
            for i=1:list_length % creates double array for relevant data
                
                play_list(i,1) = double(playlist(i).idx);
                play_list(i,2) = double(playlist(i).duration);
                
                if ~isempty(playlist(i).startTime)
                    play_list(i,3) = double(playlist(i).startTime);
                else
                    play_list(i,3) = 0; % case startTime is empty due to program ends before all videos were played
                end
                if ~isempty(playlist(i).endTime)
                    play_list(i,4) = double(playlist(i).endTime);
                else
                    play_list(i,4) = 0; % case endTime is empty due to program ends before all videos were played
                end
                
            end
            play_list_fields = ["Order", "Duration", "Start time", "End time"];
            
            save(filename,'play_list_fields','play_list','playlist','-append'); % adds variables to the saved data file
        end
        
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
        
        try
            app.Status1.FontColor = [0.29,0.58,0.07]; % dark green
            app.Status1.Value = sprintf('%s', ['File saved at: ',filename, ' successfully!']);
            app.StopButton.ButtonPushedFcn(1,1); % brings UI back to 'run' mode
        catch
        end
        
    catch
        status(app, 'Error saving data file!!!', 'r', 1, 0);
        err = 1;
    end
    
else
    if err == 0
        err = status(app, 'Program finished successfully.', 'g', 1, 0);
    end
end

%% Terminate
try
    if properties.IR_camera == 1
        IRInterface.terminate(); % disconnect from IR camera
    end
    if properties.VIS_camera == 1
        clear('cam'); % disconnect from VIS camera
    end
    if properties.playVideofiles == 1
        v.quit(); % close VLC player
    end
catch
end

close all;

try
    
app.StopButton.ButtonPushedFcn(1,1); % brings UI back to 'run' mode

if err == 0
    disp('Program ended successfully.');
elseif err == 2
    app.Status1.FontColor = [0.78,0.09,0.21]; % dark red
    app.Status1.Value = sprintf('%s', ['program ended prematurely! File saved at: ',filename]);
end

catch
end

end