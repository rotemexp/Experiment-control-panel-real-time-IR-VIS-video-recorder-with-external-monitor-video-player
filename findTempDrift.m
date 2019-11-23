function [temp_drift] = findTempDrift(params)

%%

frame_cutOff = 1;
cutoff_freq = 0.005;

noise_signal = data_IR.c(frame_cutOff:end,1);

[b, a] = butter(2, cutoff_freq/(params.frameRate/2),'low');
noise_signal_lowpassed = filtfilt(b,a,noise_signal); % Band pass filtering the U & V vectors

x = linspace(1,length(noise_signal_lowpassed),length(noise_signal_lowpassed));
x=x';
y = noise_signal_lowpassed;

[p, S, mu] = polyfit(x, y, 3);
noise_estimation = polyval(p, x, 3, mu);

initial_temp = noise_signal_lowpassed(1,1);
final_temp = noise_signal_lowpassed(end,1);
temp_drift = (final_temp - initial_temp) / length(noise_signal_lowpassed); % temperature drift per frame (at 8 FPS)

%% update noise saved data file

save('noise','noise_signal_lowpassed','noise_estimation','-v7.3','-append');

%%

figure('Name', 'noise_LPF and noise polynom');
plot(noise_signal_lowpassed);
hold on
plot(noise_estimation)

%%

figure('Name', 'noise_signal');
plot(noise_signal);

%%

figure('Name', ['noise_signal_lowpassed at: ', num2str(cutoff_freq)]);
plot(noise_signal_lowpassed);
%%
params.fileName_analayzed = erase(params.fileName,'.mat');
params.Analayzed_noise_file_location =([params.mainFolder, '\Analayzed noise\', params.fileName_analayzed, '_analayzed']);
save(params.Analayzed_noise_file_location,'frame_cutOff','cutoff_freq','noise_signal','noise_signal_lowpassed');
end