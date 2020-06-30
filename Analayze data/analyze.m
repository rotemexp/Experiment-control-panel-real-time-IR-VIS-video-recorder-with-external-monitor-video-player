%%  Code written in MATLAB 2018b by Shaul Shvimmer, Electro-Optical engineering M.Sc student. saulsh@post.bgu.ac.il
clear all;
close all;
clc
tic

%% Calculate ROI's pixel's intensity average

crop_cors = 6; % choose number of ROI's desired
file_name = 'Pilot2 Sub5';
save_it = 1;
remarks = '6 ROIs'; %remarks = 'IR: eyes, VIS: eyes';

[ir, vis] = get_data(file_name, crop_cors, save_it, remarks);

%% ROI's intensity comparison

folder = 'Analayzed data';
dir_file_list = dir(folder);
dir_file_list = dir_file_list(~ismember({dir_file_list.name},{'.','..'}));

roi_names = ["Forehead", "Left cheek", "Right cheek", "Nose", "Lip", "Background"];
files2process = 6:9; % choose indexes of data files to calc
vids2process = 1:1000;
disp_last_frames = 0; % 1 / 0
mode = 'std'; % diff / avg / std
comparison = 'roi'; % file / roi

var_names_list = intensity_comparison('VIS', folder, files2process, vids2process,...
    disp_last_frames, mode, comparison, roi_names);

%% Plot signal

subplot = 16;
frame_plot = 0;
filter_type = 'dc'; % 'low' / 'high' / 'bandpass' / 'median' / 'dc' / 'no'

cutoff_freq = [0.2, 0.4]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

signal_plot(ir, 'sig', subplot, frame_plot, filter_type, cutoff_freq)

cutoff_freq = [0.8, 1.5]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

%signal_plot(vis, 'sig', subplot, frame_plot, filter_type, cutoff_freq)

%% Signals comparison

folder = 'Analayzed data';
dir_file_list = dir(folder);
dir_file_list = dir_file_list(~ismember({dir_file_list.name},{'.','..'}));
files2process = 3:7; % choose indexes of data files to calc
vids2process = 1:200;

subplot = 25;
filter_type = 'dc'; % 'low' / 'high' / 'bandpass' / 'median' / 'dc' / 'no'

cutoff_freq = 1;%[0.2, 0.4]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]
signals_comparison('IR', subplot, filter_type, cutoff_freq, folder, files2process, vids2process)

cutoff_freq = 1;%[0.8, 1.5]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]
signals_comparison('VIS', subplot, filter_type, cutoff_freq, folder, files2process, vids2process)

%% FFT

subplot = 16;
freq_limit = 0; %[0.1, 2]; % 2 element vector as frequency (x-axis) limits or 1 element for none.
pow_limit = 0; %[0, 1]; % 2 element vector as power (y-axis) limits or 1 element for none.
filter_type = 'dc'; % 'low' / 'high' / 'bandpass' / 'median' / 'dc' / 'no'
cutoff_freq = 0.02; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

%FFT_plot(ir, 'IR', freq_limit, pow_limit, subplot, filter_type, cutoff_freq)
FFT_plot(vis, 'VIS', freq_limit, pow_limit, subplot, filter_type, cutoff_freq)

%% STFT

subplot = 16;
freq_limit = [0.5, 3]; % 2 element vector as frequency (x-axis) limits or 1 element for none.
plotMax = 0; % plot maximum value of each frame: 0 = no, 1 = yes.
ns = 6; % divide the signal into ns sections of equal length
ov = 0.5; % precentage overlap between sections

filter_type = 'dc'; % 'low' / 'high' / 'bandpass' / 'median' / 'dc' / 'no'
cutoff_freq = [0.5, 3]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

%STFTplot(ir, 'IR', freq_limit, subplot, plotMax, ns, ov, filter_type, cutoff_freq);
STFTplot(vis, 'VIS', freq_limit, subplot, plotMax, ns, ov, filter_type, cutoff_freq);

%% CWT

subplot = 16;
plotMax = 0; % plot maximum value of each frame: 0 = no, 1 = yes.

filter_type = 'bandpass'; % 'low' / 'high' / 'bandpass' / 'median' / 'dc' / 'no'
cutoff_freq = [0.5, 3]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

filter_bank.gamma = 3; % standard = 3; must be greater then 1 and lower then timeBandwidth.
filter_bank.timeBandwidth = 10; % must be a scalar in the range 3-120. The standard deviation of the Morse wavelet in time is approximately sqrt(TimeBandwidth/2). The standard deviation of the Morse wavelet in frequency is approximately 1/2*sqrt(2/TimeBandwidth)
filter_bank.VoicesPerOctave = 48; % must be an even integer from 4 to 48, defines the number of scales of the wavelet, between integer scales (fractions)

filter_bank.freq_limit = [0.1, 0.6]; % 2 element vector as x axis (frequency) limits
%CWT_plot(ir, 'IR', plotMax, filter_bank, subplot, filter_type, cutoff_freq);

filter_bank.freq_limit = [0.5, 2]; % 2 element vector as x axis (frequency) limits
CWT_plot(vis, 'VIS', plotMax, filter_bank, subplot, filter_type, cutoff_freq);

%% Play video

% video file name to open:
subFolder = 'Recordings\';
file_name = 'Pilot Sub 6';
file2load = fullfile(subFolder,file_name);

fast_play = 0; % 0: regular / manual, 1: fast
segment_time = 0.25; % time between frames [sec]
show_differences = 4; % 0-1: no (regular), >2: show frame differences between this value.
video_number = 2; % video number to play
order_vid_idx = 1; % 1: search video by play order, 2: search video by video index

play(file2load, 'IR', video_number, fast_play, segment_time, show_differences, order_vid_idx);

