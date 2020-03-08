function STFTplot(data, plotMax, FrequencyLimits, ns, ov, sig)
% performing STFT calculations (spectrogram - built in MATLAB function)

disp ([datestr(now), ' - Calculating STFT']); % displays progress

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
