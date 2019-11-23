function FFTplot(data, sig, xlimit)
%% performing FFT calculations

disp ([datestr(now), ' - Calculating FFT']); % displays progress

SIG = abs(fftshift(fft(sig))); % Performing FFT 

if mod(length(SIG),2) == 0 % checks if number of frames to process is even (0) or odd (1)
    SIG_positive = SIG(round(length(SIG)/2 + 1) : end,:); % taking only the positive frequancies data
else % case odd
    SIG_positive = SIG(round(length(SIG)/2) : end,:); % taking only the positive frequancies data
end

fvecLen = numel(SIG_positive(:,1)); % finding the length of the positive values FFT matrix
fvec = (0:fvecLen-1)./(fvecLen-1).*(data.frame_rate/2); % constructing the FFT x-axis vector

%maxF = max(max(SIG_positive));

figure('Name', 'FFT'); % plots the FFT spectrograms
for i=1:data.N^2
    subplot(data.N,data.N,i); plot(fvec, SIG_positive(:,i)); axis on;
    title(['FFT of channel ' num2str(i)]);
    xlabel('Frequency [Hz]'); ylabel('Normalized intensty');
    if exist('xlimit','var')
        if length(xlimit) == 2
            xlim(xlimit);
        end
    end
    %ylim([0, maxF]);
    grid on;
end

end % end of function
