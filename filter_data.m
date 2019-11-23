function data = filter_data(data, filter_type, cutoff_freq, median)

if strcmp(filter_type,'no') == 0 % case filter isn't 'no'
    
    if isfield(data, 'VIS') == 1 % case VIS data exists
    %{
            [b, a] = butter(2, params.cutoff_freq./(params.frameRate/2),params.filter);
            Vf = filtfilt(b,a,data.V); % Band pass filtering the U & V vectors
            Uf = filtfilt(b,a,data.U);
            
            lambda = std(Uf) / std(Vf);
            filtered_data = Uf - lambda*Vf; % final data_VIS matrix: equation 3 in the paper
            
            [b, a] = butter(2, params.cutoff_freq./(params.frameRate/2),params.filter);
            filtered_data = filtfilt(b,a,filtered_data); % Band pass filtering the U & V vectors
    %}
    end
    
    if isfield(data, 'IR') == 1 % case IR data exists
        
        [b, a] = butter(2, cutoff_freq./(data.frame_rate/2),filter_type); % create filter parameters
        
        if isfield(data, 'IR_intens') == 1
            data.IR_filt_intens = filtfilt(b,a,double(data.IR_intens)) + mean(data.IR_intens); % Perform filter
        end
        
        if isfield(data, 'IR_intens2') == 1
            data.IR_filt_intens2 = filtfilt(b,a,double(data.IR_intens2)) + mean(data.IR_intens2); % Perform filter
        end
        
        if isfield(data, 'IR_diff') == 1
            data.IR_filt_diff = filtfilt(b,a,double(data.IR_diff)) + mean(data.IR_diff); % Perform filter
        end
        
    end
        
    elseif median == 1 % case need to perform median filter later, change names to fit functions
        
        data.IR_filt_intens = data.IR_intens;
        if isfield(data, 'IR_intens2') == 1
            data.IR_filt_intens2 = data.IR_intens2;
            data.IR_filt_diff = data.IR_diff;
        end
        
    end
    
    if median == 1 % case need to perform moving median filter as well:
        
        if isfield(data, 'IR_filt_intens') == 1
            data.IR_filt_intens = movmedian(data.IR_filt_intens,data.frame_rate); % perform median filter over 1 second duration
        end
        
        if isfield(data, 'IR_filt_intens2') == 1
            data.IR_filt_intens2 = movmedian(data.IR_filt_intens2,data.frame_rate); % perform median filter over 1 second duration
        end
        
        if isfield(data, 'IR_filt_diff') == 1
            data.IR_filt_diff = movmedian(data.IR_filt_diff,data.frame_rate); % perform median filter over 1 second duration
        end
        
    end
end
