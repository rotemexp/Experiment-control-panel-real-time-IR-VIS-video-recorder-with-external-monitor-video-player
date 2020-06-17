function filt_sig = filterit(signal, frame_rate, filter_type, cutoff_freq)

    if strcmp(filter_type, 'median')
        
        filt_sig = movmedian(signal, frame_rate); % perform median filter over 1 second duration
        
    elseif strcmp(filter_type, 'dc')
        
        filt_sig = signal - mean(signal); % removes DC (average) from signal
        
    else
        [b, a] = butter(2, cutoff_freq ./ (frame_rate/2), filter_type); % create filter parameters
        filt_sig = filtfilt(b, a, double(signal)) + mean(signal); % Perform filter and add back DC
    end

end
