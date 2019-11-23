function [params] = fixTHM(params)
%% Pre-processing (fixing THM random frame record time issue)

% function need to be fixed - not ready to run
   
if exist('buffer_THM','var') == 0
    error('No data file to process was found') % no data file to process
else
    disp ('[0] Pre-processing THM video file...');
    
    % reseting parameters:
    t = t./1000; % fix time scale
    delta = 0; 
    GT = segment_time;
    seg_A(1) = 1;
    seg_B(1) = 1;
    seg_A(2) = t(1);
    seg_B(2) = t(1);
    counter = 1;
    temp_count = 0;
    temp_THM = zeros(288,382,1);
    fixed_THM = zeros(288,382);

    for i=1:numel(t)
        if t(i) - seg_B(2) + delta > segment_time % case end of segment found
            if seg_A(1) ~= seg_B(1) % case not first run
                fixed_THM(:,:,counter) = temp_THM ./ temp_count; % saving new avergaed frames from the segment
                temp_THM = 0; % reseting parameters
                temp_count = 0;
                counter = counter + 1;
            end

            seg_A = seg_B; % saving last segment location

            seg_B(1) = i - 1; % saving new segment location
            seg_B(2) = t(i - 1);

            delta = seg_B(2) - GT; % calculating the difference between measured time to ground truth
            GT = GT + segment_time; % calculating ground trouth time
        end

        temp_THM = temp_THM + buffer_THM(:,:,i); % adding another segment frame
        temp_count = temp_count + 1;
    end

end

end % end function
