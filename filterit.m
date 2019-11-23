function data = filterit(data, filter_type, cutoff_freq, median, sig1, sig2, sig3, sig4)

if strcmp(filter_type,'no') == 0 % case filter isn't 'no'
    
        [b, a] = butter(2, cutoff_freq./(data.frame_rate/2),filter_type); % create filter parameters
        
        if exist('sig1','var') == 1
            data.sig1 = filtfilt(b,a,sig1); % Perform filter
        end
        
        if exist('sig2','var') == 1
            data.sig2 = filtfilt(b,a,sig2); % Perform filter
        end
        
        if exist('sig3','var') == 1
            data.sig3 = filtfilt(b,a,sig3); % Perform filter
        end
        
        if exist('sig4','var') == 1
            data.sig4 = filtfilt(b,a,sig4); % Perform filter
        end
        
end
    
    if median == 1 % case need to perform moving median filter as well:
        if strcmp(filter_type,'no') == 0
            
            if exist('sig1','var') == 1
                data.filt_sig1 = movmedian(data.sig1,data.frame_rate); % perform median filter over 1 second duration
            end

            if exist('sig2','var') == 1
                data.filt_sig2 = movmedian(data.sig2,data.frame_rate); % perform median filter over 1 second duration
            end

            if exist('sig2','var') == 1
                data.filt_sig2 = movmedian(data.sig2,data.frame_rate); % perform median filter over 1 second duration
            end

            if exist('sig2','var') == 1
                data.filt_sig2 = movmedian(data.sig2,data.frame_rate); % perform median filter over 1 second duration
            end
            
        else
            
            if exist('sig1','var') == 1
                data.filt_sig1 = movmedian(sig1,data.frame_rate); % perform median filter over 1 second duration
            end

            if exist('sig2','var') == 1
                data.filt_sig2 = movmedian(sig2,data.frame_rate); % perform median filter over 1 second duration
            end

            if exist('sig2','var') == 1
                data.filt_sig2 = movmedian(sig2,data.frame_rate); % perform median filter over 1 second duration
            end

            if exist('sig2','var') == 1
                data.filt_sig2 = movmedian(sig2,data.frame_rate); % perform median filter over 1 second duration
            end
            
        end
        
    end
end
