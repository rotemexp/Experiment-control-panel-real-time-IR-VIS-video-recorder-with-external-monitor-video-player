function err = save_parameters(properties, filename, t, FPS, playlist)

try
    
    if properties.save_data == 1 && properties.popup == 1 % case there was a questions pop-up
        
        global feedback;
        feel = feedback.feel;
        wake = feedback.wake;
        posneg = feedback.posneg;
        
        save(filename,'feel','wake','posneg','-append');
        
    end
    
    t = t';
    FPS=FPS';
    frame_rate = properties.constantFrameRate;
    
    save(filename,'t','FPS','frame_rate','-append'); % adds variables to the saved data file
    
    if properties.playVideofiles == 1
        
        list_length = length(playlist);
        
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
            
            if ~isempty(playlist(i).startFrame)
                play_list(i,5) = double(playlist(i).startFrame);
            else
                play_list(i,5) = 0; % case endTime is empty due to program ends before all videos were played
            end
            if ~isempty(playlist(i).endFrame)
                play_list(i,6) = double(playlist(i).endFrame);
            else
                play_list(i,6) = 0; % case endTime is empty due to program ends before all videos were played
            end
            
        end
        
        play_list_fields = ["Order", "Duration", "Start time", "End time", "start frame", "end frame"];
        
        save(filename,'play_list_fields','play_list','playlist','-append'); % adds variables to the saved data file
    end
    
catch
    err = 1;
end
err = 0;

end