function FFT_plot(data, channel, freq_limit, pow_limit, sub)

eval(['signal = data.', channel, ';']); % get the desired signal

if isfield(data, 'play_list') == 1
       
    play_list = data.play_list;
    exp_num = size(play_list,1); % find number of videos in recieved data
    
    if sub ~= 0 % case need to subplot
        
        [SIG_positive, fvec] = perform_FFT(data, signal);
        
        iter_num = ceil(exp_num / sub); % calculates number of batches
        
        for i=1:1:iter_num
            
            FFT_plotit(data, sub, fvec, SIG_positive, i, channel, freq_limit, pow_limit); % plot it
            
        end
        
    else % case single plots
        
        [SIG_positive, fvec] = perform_FFT(data, signal);
        
        for i=1:1:exp_num
            
            FFT_plotit(data, i, fvec(i,:), SIG_positive(i,:), sub, channel, freq_limit, pow_limit); % plot it
            
        end
        
    end
    
else % case there's only one signal
    
    [SIG_positive, fvec] = perform_FFT(data, signal);

    FFT_plotit(data, 1, fvec, SIG_positive, 0, channel, freq_limit, pow_limit); % plot it
    
end

end