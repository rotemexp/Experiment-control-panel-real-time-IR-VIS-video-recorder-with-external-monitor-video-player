function [c] = fixTempDrift(params,data)
%% Noise cubic equation:

load('noise.mat');
noise = noise_estimation;
%noise = noise_signal_lowpassed;

for i=1:params.N^2
    signal(:,i) = data.c(:,i);
    fixed_signal(:,i) = signal(:,i) - noise(1:length(signal),1) + mean(signal(:,i));
end

c = fixed_signal;

end