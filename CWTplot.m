function CWTplot(data, plotMax, FrequencyLimits, gamma, timeBandwidth, VoicesPerOctave, sig)
% performing CWT calculations
disp ([datestr(now), ' - Calculating CWT']); % displays progress

len = length(sig);

fb = cwtfilterbank('SamplingFrequency',data.frame_rate,'FrequencyLimits',FrequencyLimits, ...
    'SignalLength',len,'WaveletParameters',[gamma,timeBandwidth],...
    'VoicesPerOctave',VoicesPerOctave); % prepares the CWT filter bank

for i=1:data.N^2 % performs the continues wavelet transform on each channel
    [WTk(:,:,i),frq] = cwt(double(sig(:,i)),'FilterBank',fb); % 'morse', 'amor', and 'bump', specify the Morse, Morlet (Gabor), and bump wavelets respectively
end

for l=1:len % runs on the data from each frame
    for ch=1:data.N^2 % runs on each channel
        testedCH = abs(WTk(:,l,ch)); % takes one channel at each itteration
        [~, Aidx(ch,l)] = max(testedCH); % finds max value
    end
end

figure('Name', 'CWT'); % plots the CWT spectrograms
for i=1:data.N^2
    subplot(data.N,data.N,i);
    title(['CWT of channel ' num2str(i)]);
    xlabel('Time [sec]'); ylabel('Frequency [Hz]');
    xlim([data.start_time, data.end_time]);
    if length(FrequencyLimits) > 1
        ylim(FrequencyLimits);
    end
    surface(data.tvec,frq,abs(WTk(:,:,i)))
    shading interp
    % set(gca,'yscale','log');
    colorbar;
end

if plotMax == 1
    
    CWT_results = frq(Aidx);
    mostFrequent = mode(CWT_results');
    if data.N == 1 % for special case N = 1
        CWT_results = CWT_results';
    end
    
    figure('Name', 'Max CWT values'); % plots the CWT spectrograms highest values only
    for i=1:data.N^2
        subplot(data.N,data.N,i);
        title(['max CWT of channel ' num2str(i) '. Peak at: '...
            num2str(round(mostFrequent(1,i),2)) ' Hz. (' num2str(round(mostFrequent(1,i)*60,2)) ' BPM)']);
        xlabel('Time [sec]'); ylabel('Frequency [Hz]');
        xlim([data.start_time, data.end_time]);
        if length(FrequencyLimits) > 1
            ylim(FrequencyLimits);
        end
        hold on
        scatter(data.tvec, CWT_results(i,:),20,'filled')
    end
    
end

end % end of function