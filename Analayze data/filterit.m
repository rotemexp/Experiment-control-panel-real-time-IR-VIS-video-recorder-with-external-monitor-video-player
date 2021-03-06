function filt_sig = filterit(signal, frame_rate, filter_type, cutoff_freq, add_mean)

    if strcmp(filter_type, 'median')
        
        filt_sig = movmedian(signal, frame_rate); % perform median filter over 1 second duration
        
    elseif strcmp(filter_type, 'dc')
        if ndims(signal) < 3
            filt_sig = signal - mean(signal); % removes DC (average) from signal
        else
            disp('Error: cannot filter multi-dimensional matrices.');
            filt_sig = 0; 
        end
        
    else
        [b, a] = butter(2, cutoff_freq ./ (frame_rate/2), filter_type); % create filter parameters
        
        if add_mean == 1
            filt_sig = filtfilt(b, a, double(signal)) + mean(signal); % Perform filter and add back DC
        else
            filt_sig = filtfilt(b, a, double(signal));
        end
        
        %filt_sig = sosfilt(tf2sos(b, a), double(signal)) + mean(signal);
    end

end
