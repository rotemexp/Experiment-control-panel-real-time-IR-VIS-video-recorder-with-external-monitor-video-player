function [SIG_positive, fvec] = perform_FFT(data, signal)

if isfield(data, 'play_list') == 1
    play_list = data.play_list;
    exp_num = size(play_list,1); % find number of videos in recieved data
else
    exp_num = 1;
end

for i=1:exp_num
    
    SIG = abs(fftshift(fft(signal(play_list(i,5):play_list(i,6))))); % Performing FFT
    
    if mod(length(SIG),2) == 0 % checks if number of frames to process is even (0) or odd (1)
        SIG_pos = SIG(round(length(SIG)/2 + 1) : end,:); % taking only the positive frequancies data;
        SIG_len(i) = numel(SIG_pos);
        SIG_positive(i,1:SIG_len(i)) = SIG_pos;
    else % case odd
        SIG_pos = SIG(round(length(SIG)/2) : end,:); % taking only the positive frequancies data
        SIG_len(i) = numel(SIG_pos);
        SIG_positive(i,1:SIG_len(i)) = SIG(round(length(SIG)/2) : end,:); % taking only the positive frequancies data
    end
    
    fvec(i,1:SIG_len(i)) = (0:SIG_len(i)-1)./(SIG_len(i)-1).*(data.play_list(i,7)/2); % constructing the FFT x-axis vector
    
end

end