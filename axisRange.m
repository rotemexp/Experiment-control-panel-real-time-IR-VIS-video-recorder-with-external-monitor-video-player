function limit = axisRange(params)

if isfield(params,'filter') == 1

if length(params.filter) ~= 2 % case its not 'no'
    
    switch params.filter
        
        case 'low'
            limit = [0, params.cutoff_freq];
        case 'high'
            limit = [params.cutoff_freq, params.frameRate/2];
        case 'bandpass'
            limit = params.cutoff_freq;
    end
    
end

else 
    limit = 0; % case no filter has been done
end