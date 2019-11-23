%%  Code written in MATLAB 2018b by Shaul Shvimmer, Electro-Optical engineering M.Sc student. saulsh@post.bgu.ac.il
clear all; close all; clc

% video file name to open:
mainFolder = 'C:\Users\saul6\Documents\Electrooptical Eng\Thesis\Matlab\Record and Analayze\';
subFolder = 'Recordings\';
fileName = '2cameras_test';
file2load = fullfile(mainFolder,subFolder,fileName);

% select calculation options:
data.create = 1;
ROIcomparison = 1; % select 2 ROI: 0 = no, 1 = manual select, [x, x, x, x] = coordinates to calculate
crop_cor1 = 0; % [x, x, x, x] = coordinates to calculate, 0\1 = manual select
improve_img = 0; % perform 2D image processing methods on each frame: 0 = no, 1 = yes (works only for RGB IR video)
start_time = 0; % time to start the calculations. 0: runs from the begining of the video file
end_time = 0; % time to finish the calculations. 0: runs until the end of the video file
N = 4; % Divides the large ROI to NxN squares
newFrameRate = 0; % changes VID video frame rate

data = VIS_analysis(data, file2load, N, start_time, end_time, improve_img, crop_cor1, ROIcomparison, newFrameRate);

data = IR_analysis(data, file2load, N, start_time, end_time, improve_img, crop_cor1, ROIcomparison);

%% Filters and plot signal

filter_type = 'high'; % 'low' / 'high' / 'bandpass' / 'no'
cutoff_freq = 0.01;% [3, 3.999] % positive number in case filter is low / high. for bandpass use: [f_low, f_high]
median = 1; % perform moving median: 0 = no, 1 = yes;

data = filterit(data, filter_type, cutoff_freq, median, data.IR_diff);

description = 'plot';
% plots colors by entered order: 1- Blue, 2- Orange, 3- Yellow, 4- Purple.
plotit(data, description, data.IR_diff, data.filt_sig1) % can plot up to 4 signals on each graph

%Plot_IR = 1;
%Plot_filtered_IR = 1;
%Plot_VIS = 0;
%Plot_filtered_VIS = 0;
%data = filter_data(data, filter_type, cutoff_freq, median);
%signalplot(data, Plot_IR, Plot_filtered_IR, Plot_VIS, Plot_filtered_VIS);

%% FFT
xlimit = [0.2, 2]; % 2 element vector as x axis limits
FFTplot(data, data.filt_sig1, xlimit)
    
%% CWT

plotMax = 0; % plot maximum value of each frame: 0 = no, 1 = yes.
gamma = 3; % standard = 3; must be greater then 1 and lower then timeBandwidth.
timeBandwidth = 120; % must be a scalar in the range 3-120. The standard deviation of the Morse wavelet in time is approximately sqrt(TimeBandwidth/2). The standard deviation of the Morse wavelet in frequency is approximately 1/2*sqrt(2/TimeBandwidth)
VoicesPerOctave = 10; % must be an even integer from 4 to 48, defines the number of scales of the wavelet, between integer scales (fractions)
FrequencyLimits = [0.2, 2]; % 2 element vector as x axis (frequency) limits

CWTplot(data, data.filt_sig1, plotMax, FrequencyLimits, gamma, timeBandwidth, VoicesPerOctave);

%% STFT

FrequencyLimits = [0, 4]; % 2 element vector as x axis (frequency) limits
plotMax = 0; % plot maximum value of each frame: 0 = no, 1 = yes.
ns = 16; % divide the signal into ns sections of equal length
ov = 0.5; % precentage overlap between sections

STFTplot(data, data.filt_sig1, plotMax, FrequencyLimits, ns, ov);
%% Play video

fast_play = 1;

play(file2load, fast_play);

%% Save
fileName_analayzed = erase(fileName,'.mat');
Analayzed_file_location =([mainFolder, 'Analayzed noise\', fileName_analayzed, '_analayzed']);

save(Analayzed_file_location,'data');

if save_data == 1
    %Datafilename = ['Data\', file_name, '_analysed.mat']; % no time stamp
    Datafilename = ['Data\', num2str(now),'_', file_name, '_analysed.mat']; % with time stamp

    if ~exist([pwd, '\Data'], 'dir') % checks if Data folder exists
        mkdir('Data\') % if it dosent - create it
    end

    save(Datafilename,'-v7.3','data'); % Saves V7.3 data file (fits Python as well)
end
