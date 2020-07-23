%% Load data
clear all
load('C:\Users\saul6\Documents\Electrooptical Eng\Thesis\MATLAB\Analayze\Analayzed data\pilot2 sub1.mat')
ir = flipper(ir, 'Played order');
vis = flipper(vis, 'Played order');

vid_num = 56;
sig(1,:) = vis{1, vid_num}.R(:,1);
sig(2,:) = vis{1, vid_num}.G(:,1);
sig(3,:) = vis{1, vid_num}.B(:,1);
sig(4,:) = ir{1, vid_num}.sig(:,5);
fps = ir{1, vid_num}.play_list(vid_num,8);
len = size(sig, 2);
how_many = size(sig, 1);
tvec = linspace(0, len, len) ./ fps; % create the time axis vector

sig = (sig - mean(sig, 2)) ./ std(sig, 0, 2);
sig_ica = fastICA(sig, 4);

for i=1:how_many
    if i <= size(sig, 1)
        SIG(i, :) = perform_FFT(sig(i, :));
    end
    if i <= size(sig_ica, 1)
        SIG_ICA(i, :) = perform_FFT(sig_ica(i, :));
    end
end

SIG_len = length(SIG);
fvec = (0:SIG_len-1) ./ (SIG_len-1) .* (fps/2); % constructing the FFT x-axis vector

%sig_vis_m = filterit(sig_vis_m, fps, 'high', 0.3, 1);
% sig_vis_m = filterit(sig_vis_m, fps, 'stop', [1, 1.66], 1);

%sig_ir_m = filterit(sig_ir_m, fps, 'high', 0.3, 1);
% sig_ir_m = filterit(sig_ir_m, fps, 'stop', [1, 1.66], 1);

%sig_vis_m = (sig_vis_m - mean(sig_vis_m)) / std(sig_vis_m);
%sig_ir_m = (sig_ir_m - mean(sig_ir_m)) / std(sig_vis_m);

%% plot

colors = ['r'; 'g'; 'b'; 'k'];

figure('Name', 'Original');

subplot(1,2,1);
for i=1:size(sig, 1)
    plot(tvec, sig(i, :), colors(i));
    hold on;
end
title('Original signals')

subplot(1,2,2);
for i=1:size(sig_ica, 1)
    plot(tvec, sig_ica(i, :), colors(i));
    hold on;
end
title('ICA')


figure('Name', 'Original');

subplot(1,2,1);
for i=1:size(SIG, 1)
    plot(fvec, SIG(i, :), colors(i));
    hold on;
end
title('Original signals')

subplot(1,2,2);
for i=1:size(SIG_ICA, 1)
    plot(fvec, SIG_ICA(i, :), colors(i));
    hold on;
end
title('ICA')

%% ICA result STFT
%{
ns = 6; % divide the signal into ns sections of equal length
ov = 0.5; % precentage overlap between sections
sig_vis = ica_res(1,:);
sig_ir = ica_res(2,:);

% sig_vis = sig_vis_m;
% sig_ir = sig_ir_m;

len = size(sig_vis, 2);
nsc = floor(len/ns); % divide the signal into sections of length nsc
nff = max(256,2^nextpow2(nsc)); % number of DFT points
lsc = floor(len/(ns-(ns-1)*ov)); % windows size

[WTk_spect_vis, frq_spect_vis, tvec_spect_vis] = spectrogram(sig_vis, lsc, floor(ov*lsc), nff, fps, 'yaxis');
[WTk_spect_ir, frq_spect_ir, tvec_spect_ir] = spectrogram(sig_ir, lsc, floor(ov*lsc), nff, fps, 'yaxis');

figure('Name', 'fastICA STFT');

subplot(1,2,1);
surf(tvec_spect_vis, frq_spect_vis, abs(WTk_spect_vis)) % plot the signal
shading interp;
axis tight;
view(0, 90); % remove for 3D view
colorbar;
title('VIS')

subplot(1,2,2);
surf(tvec_spect_ir, frq_spect_ir, abs(WTk_spect_ir)) % plot the signal
shading interp;
axis tight;
view(0, 90); % remove for 3D view
colorbar;
title('IR')
%}
