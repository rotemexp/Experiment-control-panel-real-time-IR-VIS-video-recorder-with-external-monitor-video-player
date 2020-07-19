function err = warm_up(app, properties, cam, vlc)

global viewer_is_running; % initialize the main frame grabber loop as global variable
global IRInterface; % initialize the interface as a global variable

err = status(app, 'Warming up...', 'g', 1, 0);

t = uint64(zeros(1));
tLast_display = 1;
t_seg = zeros(2,1);
tStart = tic;
idx = 1;
run = 1;
    
    while run == 1 && viewer_is_running == 1
        
        if properties.warm_up_seconds == 1 % case seconds
            if t_seg(2) - t_seg(1) >= (1000*properties.warm_up_period) % checks if elpased time is larger
                run = 0;
            end
        else % case frames
            if idx >= properties.warm_up_period % checks if index is larger
                run = 0;
            end
        end
        t_seg(2) = (round(toc(tStart)*1000)); % saves time delta
        
        t(idx) = (round(toc(tStart)*1000)); % saves time delta
        if t(idx) - t(tLast_display) >= 1000 % checks if elpased time is larger then 1 sec
            app.Status2.Text = sprintf('%s', num2str(t(idx) / 1000)); % updates elapsed time
            app.Status1.FontColor = [0.29,0.58,0.07]; % dark green
            app.Status1.Value = sprintf('%s', ['Warming up... frame number: ', num2str(idx)]);
            drawnow(); % updates callback functions
            tLast_display = idx; % saves the index of the last time found
            
            if properties.playVideofiles == 1 && properties.verifyFullscreen == 1
                vlc.Fullscreen = 'on'; % makes sure VLC player is at fullscreen mode (every second)
            end
            
        end
        
        if properties.IR_camera == 1
            if properties.tempORcolor == 1
                frame_IR = (single(IRInterface.get_thermal() - 10000) ./ 100); % get gray image from IR camera
            else
                frame_IR = (IRInterface.get_palette()); % get color image from IR camera
            end
        end
        
        if properties.RGB_camera == 1
            frame_VIS = snapshot(cam); % get imgage from VIS camera
        end
        
        idx = idx + 1; % increas index
    end

    app.Status1.FontColor = [0.29,0.58,0.07]; % dark green
    if viewer_is_running == 0
        app.Status1.Value = sprintf('%s', 'program stoped.');
        err = 1;
    else
        app.Status1.Value = sprintf('%s', 'Warm up finished.');
        err = 0;
    end
    
    drawnow(); % updates callback functions

end
