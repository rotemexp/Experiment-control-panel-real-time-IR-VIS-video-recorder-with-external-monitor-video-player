%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Noise measurement                  %
%             with MATLAB Implementation              %
%                                                     %
% Author: M.Sc. Eng. Hristo Zhivomirov       07/15/12 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function noisemeasure(x, win, noverlap, nfft, fs)

% function: noisemeasure(x, win, noverlap, nfft, fs)
% x - signal in the time domain
% win - window function in the time domain
% noverlap - overlap samples from section to section
% nfft - size of the fft
% fs - sampling frequency, Hz

% organize question dialog menu abput the weightig
quest = 'What type of filter to be applied on the signal?';
dlgtitle = 'Choose filter';
btn1 = 'A-weighting filter';
btn2 = 'C-weighting filter';
defbtn = btn1;
answer = questdlg(quest, dlgtitle, btn1, btn2, defbtn);

% remove the DC component
x = x - mean(x);

% generate time vector
N = length(x);
t = (0:N-1)/fs;

% plot the signal
figure(1)
subplot(2, 1, 1)
plot(t, x, 'r')
grid on
hold on
xlim([0 max(t)])
ylim([-1.1*max(abs(x)) 1.1*max(abs(x))])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 13)
xlabel('Time, s')
ylabel('Amplitude, V')
title('Signal in the time domain')

% apply the weighting filter
if strcmp(answer, btn1)
    xW = filterA(x, fs); 
else
    xW = filterC(x, fs); 
end

% plot the weighted signal
subplot(2, 1, 1)
plot(t, xW, '-b')
legend('Original signal', 'Weighted signal')

% PSD (Power Spectral Density, dBW/Hz)
[PSD, f] = pwelch(x, win, noverlap, nfft, fs, 'onesided');
PSDdB = 10*log10(PSD);

% plot the PSD 
subplot(2, 1, 2)
plot(f, PSDdB, 'r', 'LineWidth', 1.5)
grid on
xlim([0 max(f)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 13)
xlabel('Frequency, Hz')
ylabel('Magnitude, dBW/Hz')
title('Power Spectral Density of the signal (before the weighting)')

% display the the Equivalent Noise Bandwidth of the window function
disp(['ENBW of the window function = ' num2str(enbw(win)) ' Hz'])

% calculate and display the average PSD before the weighting
PSDavr = mean(PSD);
disp(['Average Power Spectral Density before the weighting = ' num2str(PSDavr) ' W/Hz or ' ...
       num2str(10*log10(PSDavr)) ' dBW/Hz'])

% calculate and display the average PSD after the weighting
PSDA = pwelch(xW, win, noverlap, nfft, fs, 'onesided');
PSDWavr = mean(PSDA);
disp(['Average Power Spectral Density after the weighting = ' num2str(PSDWavr) ' W/Hz or ' ...
       num2str(10*log10(PSDWavr)) ' dBW/Hz'])

% calculate and display the output noise U, Vrms (by TrueRMS Voltmeter) before the weighting (Reference to Output)
Urms_noise_V = 1000*std(x);
disp(['Output noise (by TrueRMS Voltmeter) before the weighting = ' num2str(Urms_noise_V) ' mVrms or '...
       num2str(20*log10(Urms_noise_V/1000)) ' dBV'])

% calculate and display the output noise U, Vrms (by TrueRMS Voltmeter) after the weighting (Reference to Output)
Urms_noise_VW = 1000*std(xW);
disp(['Output noise (by TrueRMS Voltmeter) after the weighting = ' num2str(Urms_noise_VW) ' mVrms or '....
       num2str(20*log10(Urms_noise_VW/1000)) ' dBV'])