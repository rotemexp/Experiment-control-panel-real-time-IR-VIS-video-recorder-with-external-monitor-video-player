function [tfr, frq, max_pow] = perform_CWT(data, signal, filter_bank, plotMax)

if isfield(data, 'play_list') == 1
    play_list = data.play_list;
    exp_num = size(play_list,1); % find number of videos in recieved data
else
    exp_num = 1;
end

for i=1:exp_num % performs the continues wavelet transform on each channel
    
    if exp_num ~= 1
        start_idx = play_list(i, 5);
        end_idx = play_list(i, 6);
        frame_rate = play_list(i, 7);
    else
        start_idx = 1;
        end_idx = length(signal);
        
        if data.frame_rate ~= 0
            frame_rate = data.frame_rate;
        else
           frame_rate = mean(data.fps(:,1));
        end
    end

    len = double(end_idx - start_idx + 1);
    
    fb = cwtfilterbank('SamplingFrequency',frame_rate,'FrequencyLimits',filter_bank.freq_limit, ...
        'SignalLength',len,'WaveletParameters',[filter_bank.gamma,filter_bank.timeBandwidth],...
        'VoicesPerOctave',filter_bank.VoicesPerOctave); % prepares the CWT filter bank
    
    [tfr(:,:),frq] = cwt(double(signal(start_idx:end_idx)),'FilterBank',fb); % 'morse', 'amor', and 'bump', specify the Morse, Morlet (Gabor), and bump wavelets respectively
    
    
end

if plotMax == 1

    for l=1:len % runs on the data from each frame
        for ch=1:exp_num % runs on each channel
            testedCH = abs(tfr(:,l,ch)); % takes one channel at each itteration
            [~, max_pow(ch,l)] = max(testedCH); % finds max value
        end
    end

else
    
    max_pow = 0;
    
end



%{
play_list = data.play_list;
exp_num = size(play_list,1); % find number of videos in recieved data

for i=1:exp_num
    
    signal = abs(fftshift(fft(signal(play_list(i,5):play_list(i,6))))); % Performing FFT
    
    if mod(length(signal),2) == 0 % checks if number of frames to process is even (0) or odd (1)
        SIG_pos = signal(round(length(signal)/2 + 1) : end,:); % taking only the positive frequancies data;
        SIG_len(i) = numel(SIG_pos);
        SIG_positive(i,1:SIG_len(i)) = SIG_pos;
    else % case odd
        SIG_pos = signal(round(length(signal)/2) : end,:); % taking only the positive frequancies data
        SIG_len(i) = numel(SIG_pos);
        SIG_positive(i,1:SIG_len(i)) = signal(round(length(signal)/2) : end,:); % taking only the positive frequancies data
    end
    
    fvec(i,1:SIG_len(i)) = (0:SIG_len(i)-1)./(SIG_len(i)-1).*(data.play_list(i,7)/2); % constructing the FFT x-axis vector
    
end
%}
end