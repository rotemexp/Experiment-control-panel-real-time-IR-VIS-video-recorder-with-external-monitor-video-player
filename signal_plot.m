function signal_plot(data, channel, sub)

eval(['signal = data.', channel, ';']); % get the desired signal

if isfield(data, 'play_list') == 1
       
    play_list = data.play_list;
    exp_num = size(play_list,1); % find number of videos in recieved data
    
    if sub ~= 0 % case need to subplot
        
        iter_num = ceil(exp_num / sub); % calculates number of batches
        
        for i=1:exp_num
            
            num_frames = play_list(i,6) - play_list(i,5) + 1; % get number of frames in this specific video
            tvec(i,1:num_frames) = linspace(0, num_frames, num_frames) ./ play_list(i,7); % create the time axis vector
            
        end
        
        for i=1:1:iter_num
            
            sig_plotit(data, sub, tvec, signal, i, channel); % plot it
            
        end
        
    else % case single plots
        
        for i=1:1:exp_num
            
            num_frames = play_list(i,6) - play_list(i,5) + 1; % get number of frames in this specific video
            tvec = linspace(0, num_frames, num_frames) ./ play_list(i,7); % create the time axis vector
            sig_plotit(data, i, tvec, signal(play_list(i,5):play_list(i,6),1), sub, channel); % plot it
            
        end
        
    end
    
else % case there's only one signal
    
    num_frames = length(signal);
    tvec = linspace(1, num_frames, num_frames) ./ mean(data.fps(:,1)); % create the time axis vector
    sig_plotit(data, 1, tvec, signal, 0, channel); % plot it
    
end

end