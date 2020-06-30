function STFTplot(data, channel, freq_limit, sub, plotMax, ns, ov, filter_type, cutoff_freq)
% performing STFT calculations (spectrogram - built in MATLAB function)

exp_num = numel(data); % find number of videos in recieved data

batch = 1;
sub_count = 1;
counter = 1;
if length(cutoff_freq) == 1
    lambda = [num2str(cutoff_freq), ' Hz'];
else
    lambda = [num2str(cutoff_freq(1)), '-', num2str(cutoff_freq(end)), ' Hz'];
end
str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Filter: ', num2str(filter_type),...
    ', \lambda: ', lambda, ', Batch: ', num2str(batch)];
figure('Name', str); % opens a new figure window
sgtitle(str); % plots the idx-title

for i=1:1:exp_num
    
    if ~isempty(data{i})
        
        var_name = [extractBefore(data{i}.var_name, '_'), '\_', extractAfter(data{i}.var_name, '_')];
        
        eval(['signal = data{i}.', channel, ';']); % get the desired signal
        frame_rate = data{1}.play_list(data{i}.play_order, 8);
        
        if size(signal, 1) ~= 1
            signal = signal';
        end
        
        if strcmp(filter_type, 'low') || strcmp(filter_type, 'high') ||...
                strcmp(filter_type, 'bandpass') || strcmp(filter_type, 'median') ||...
                strcmp(filter_type, 'dc') % 'low' / 'high' / 'bandpass' / 'median' / 'no'  % 'low' / 'high' / 'bandpass' / 'median' / 'no'
            signal = filterit(signal, frame_rate, filter_type, cutoff_freq, 1);
        end
        
        len = length(signal);
        nsc = floor(len/ns); % divide the signal into sections of length nsc
        nff = max(256,2^nextpow2(nsc)); % number of DFT points
        lsc = floor(len/(ns-(ns-1)*ov)); % windows size
        
        [WTk_spect, frq_spect, tvec_spect] = spectrogram(signal, lsc,...
            floor(ov*lsc), nff, frame_rate, 'yaxis');
        
        tvec_spect = tvec_spect + data{i}.start_time; % fixing time vector in case video analysis havn't started from time 0.
        
        subplot(ceil(sqrt(sub)),round(sqrt(sub)),sub_count); % create subplot
        
        surf(tvec_spect, frq_spect, abs(WTk_spect)) % plot the signal
        shading interp;
        axis tight;
        view(0, 90); % remove for 3D view
        colorbar;
        
        title(['Video file: ', var_name]); % print signal's title
        xlabel('Time [Sec]');
        ylabel('Frequency [Hz]');
        axis on;
        
        if length(freq_limit) == 2
            ylim(freq_limit); % set x axis limit
        else
            ylim([0, frq_spect(end)]); % set x axis limit
        end
        
        sub_count = sub_count + 1;
        if mod(counter,sub) == 0 && counter ~= exp_num
            batch = batch + 1;
            sub_count = 1;
            str = ['File: ', data{1}.file_name, ', Channel: ', channel ,', Filter: ', num2str(filter_type),...
                ', \lambda: ', lambda, ', Batch: ', num2str(batch)];
            figure('Name', str); % opens a new figure window
            sgtitle(str); % plots the idx-title
        end
        counter = counter + 1;
    end
end



%{
len = length(sig);
nsc = floor(len/ns); % divide the signal into sections of length nsc
nff = max(256,2^nextpow2(nsc)); % number of DFT points
lsc = floor(len/(ns-(ns-1)*ov)); % windows size

for i=1:data.N^2 % performs the STFT transform on each channel %
    [WTk_spect(:,:,i),frq_spect,tvec_spect] = spectrogram(sig(:,i),lsc,...
        floor(ov*lsc),nff,data.frame_rate,'yaxis');
end

tvec_spect = tvec_spect + data.start_time; % fixing time vector in case video analysis havn't started from time 0.

[~, STFT_segments] = size(WTk_spect(1,:,1));
for l=1:STFT_segments % runs on the data from each frame
    for ch=1:data.N^2 % runs on each channel
        [Ak_spect(ch,l), Aidx_spect(ch,l)] = max(WTk_spect(:,l,ch)); % finds max value
    end
end

figure('Name', 'STFT'); % plots the STFT spectrograms
for i=1:data.N^2
    subplot(data.N,data.N,i);
    surf(tvec_spect, frq_spect, abs(WTk_spect(:,:,i)))
    shading interp;
    axis tight;
    view(0, 90); % remove for 3D view
    xlabel('Time, [sec]');
    ylabel('Frequency [Hz]');
    title(['STFT of channel ' num2str(i)]);
    colorbar;
    if length(FrequencyLimits) == 2
        ylim(FrequencyLimits);
    end
end

if plotMax == 1
    
    STFTspect_results = frq_spect(Aidx_spect); % finds the frequency values of the results
    mostFrequent_STFTspect = mode(STFTspect_results'); % finds the most common frequency value for each channel
    
    if data.N == 1
        STFTspect_results = STFTspect_results';
    end % for special case N = 1
    
    figure('Name', 'Max STFT values'); % plots the STFT spectrograms highest values only
    for i=1:data.N^2
        subplot(data.N,data.N,i);
        title(['Max STFT values of channel ' num2str(i) '. Peak at: '...
            num2str(round(mostFrequent_STFTspect(1,i),2)) ' Hz. (' num2str(round(mostFrequent_STFTspect(1,i)*60,2)) ' BPM)']);
        xlabel('Time [sec]'); ylabel('Frequency [Hz]');
        xlim([tvec_spect(1,1), tvec_spect(1,end)]);
        %ylim(axisRange(data));
        hold on
        scatter(tvec_spect, STFTspect_results(i,:),20,'filled')
    end
    
end

end % end of function
%}