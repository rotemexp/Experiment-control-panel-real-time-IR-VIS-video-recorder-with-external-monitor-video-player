%%  Code written in MATLAB 2018b by Shaul Shvimmer, Electro-Optical engineering M.Sc student. saulsh@post.bgu.ac.il
clear all;
close all;
clc
tic

final_img_disp = 0; % display last frame of each video: 0 = no, 1 = yes.
ROIcomparison = 0; % select 2 ROI: 0 = no, 1 = manual select, [x, x, x, x] = coordinates to calculate
IR_crop_cor = 0; % [152,215,106,74]; %0; % [x, x, x, x] = coordinates to calculate, 0\1 = manual select
VIS_crop_cor = 0; % [275,118,183,52]; %0; % [x, x, x, x] = coordinates to calculate, 0\1 = manual select
start_time = 0; % time to start the calculations. 0: runs from the begining of the video file
end_time = 0; % time to finish the calculations. 0: runs until the end of the video file
N = 1; % Divides the large ROI to NxN squares
newFrameRate = 0; % changes VID video frame rate
face_detect = 0; % auto face detect: 0 = no, 1 = yes.
enhance_image = 0; % enhancment of the image before processing: 0 = no, 1 = yes.
%normalize = 1; % normalize graylevel. 0 = no, 1 = yes.
average2zero = 0; % average the results to flactuate around zero (minus average)
%data = IR_analysis_facial_track(data, file2load, N, start_time, end_time, enhance_image, crop_cor1, ROIcomparison, face_detect);

% video file name to open:
subFolder = 'Recordings\';
file_name = 'Pilot Sub 5 - Spooky';
file2load = fullfile(subFolder,file_name);
file_details = whos('-file', file2load);
max_data_vars = (numel(file_details)-1)/2;
k = 1;

max_loop_run = max_data_vars;
for idx=1:1
    
    disp(['Calculating... ', num2str(idx), '/', num2str(max_loop_run), ' (',...
    num2str(round(((idx/max_loop_run)*100),2)), ' %)'])
    
    [raw_vis, raw_ir, properties] = get_raw_vid(file2load, idx, 'VISIR'); % get video from data file
    
    % select calculation options:
    
    if exist('raw_ir','var')
        if exist('ir','var')
            IR_crop_cor = ir{1, 1}.IR_crop_cor1;
        end
        ir{k} = IR_analysis(raw_ir, properties, file_name,...
            idx, N, start_time, end_time, enhance_image, IR_crop_cor,...
            ROIcomparison, average2zero, final_img_disp);
    end
    
    if exist('raw_vis','var')
        if exist('vis','var')
            VIS_crop_cor = vis{1, 1}.VIS_crop_cor1;
        end
        vis{k} = VIS_analysis(raw_vis, properties, file_name,...
            idx, N, start_time, end_time, enhance_image, VIS_crop_cor,...
            ROIcomparison, newFrameRate, final_img_disp);
    end
    
    k=k+1;
end
disp ('Done.');
toc

%% Save data to file:

remarks = 'IR: mouth-nose, VIS: forehead';

[~, dir_feedback, ~] = mkdir ('Analayzed data'); % creates dir if it doesn't exist yet
filename = avoidOverwrite([file_name,'.mat'], [pwd, '\Analayzed data\'], 3);
filename = erase(filename, '.mat');
Analayzed_file_location =(['Analayzed data\', filename]);

if exist('vis','var') && exist('ir','var')
    save(Analayzed_file_location, 'vis', 'ir', 'properties', 'remarks');
else
    
    if exist('ir','var')
        save(Analayzed_file_location, 'ir', 'properties', 'remarks');
    end
    
    if exist('vis','var')
        save(Analayzed_file_location, 'vis', 'properties', 'remarks');
    end
    
end

disp(['Data file saved sucsusfully (', Analayzed_file_location, '.mat)'])

%% Plot signal

subplot = 4;
frame_plot = 0;
filter_type = 'no'; % 'low' / 'high' / 'bandpass' / 'median' / 'dc' / 'no'

cutoff_freq = [0.2, 0.4]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

signal_plot(ir, 'IR', subplot, frame_plot, filter_type, cutoff_freq)

cutoff_freq = [0.8, 1.5]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

signal_plot(vis, 'VIS', subplot, frame_plot, filter_type, cutoff_freq)


%% FFT

subplot = 4;
freq_limit = 0; %[0.1, 2]; % 2 element vector as frequency (x-axis) limits or 1 element for none.
pow_limit = 0; %[0, 1]; % 2 element vector as power (y-axis) limits or 1 element for none.
filter_type = 'dc'; % 'low' / 'high' / 'bandpass' / 'median' / 'dc' / 'no'
cutoff_freq = 0.02; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

FFT_plot(ir, 'IR', freq_limit, pow_limit, subplot, filter_type, cutoff_freq)
FFT_plot(vis, 'VIS', freq_limit, pow_limit, subplot, filter_type, cutoff_freq)

%% STFT

subplot = 4;
freq_limit = [0.5, 3]; % 2 element vector as frequency (x-axis) limits or 1 element for none.
plotMax = 0; % plot maximum value of each frame: 0 = no, 1 = yes.
ns = 6; % divide the signal into ns sections of equal length
ov = 0.5; % precentage overlap between sections

filter_type = 'dc'; % 'low' / 'high' / 'bandpass' / 'median' / 'dc' / 'no'
cutoff_freq = [0.5, 3]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

STFTplot(ir, 'IR', freq_limit, subplot, plotMax, ns, ov, filter_type, cutoff_freq);
STFTplot(vis, 'VIS', freq_limit, subplot, plotMax, ns, ov, filter_type, cutoff_freq);

%% CWT

subplot = 4;
plotMax = 0; % plot maximum value of each frame: 0 = no, 1 = yes.

filter_type = 'dc'; % 'low' / 'high' / 'bandpass' / 'median' / 'dc' / 'no'
cutoff_freq = [0.5, 3]; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]

filter_bank.gamma = 3; % standard = 3; must be greater then 1 and lower then timeBandwidth.
filter_bank.timeBandwidth = 120; % must be a scalar in the range 3-120. The standard deviation of the Morse wavelet in time is approximately sqrt(TimeBandwidth/2). The standard deviation of the Morse wavelet in frequency is approximately 1/2*sqrt(2/TimeBandwidth)
filter_bank.VoicesPerOctave = 48; % must be an even integer from 4 to 48, defines the number of scales of the wavelet, between integer scales (fractions)

filter_bank.freq_limit = [0.1, 0.6]; % 2 element vector as x axis (frequency) limits
CWT_plot(ir, 'IR', plotMax, filter_bank, subplot, filter_type, cutoff_freq);

filter_bank.freq_limit = [0.5, 2]; % 2 element vector as x axis (frequency) limits
CWT_plot(vis, 'VIS', plotMax, filter_bank, subplot, filter_type, cutoff_freq);

%% Play video

% video file name to open:
subFolder = 'Recordings\';
file_name = 'Pilot Sub 6 - Spooky';
file2load = fullfile(subFolder,file_name);

fast_play = 0; % 0: regular / manual, 1: fast
segment_time = 0; % time between frames [sec]
show_differences = 2; % 0-1: no (regular), >2: show frame differences between this value.
video_number = 1; % video number to play

play(file2load, 'VIS', video_number, fast_play, segment_time, show_differences);

