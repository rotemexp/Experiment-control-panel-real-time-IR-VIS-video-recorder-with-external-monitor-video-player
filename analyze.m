%%  Code written in MATLAB 2018b by Shaul Shvimmer, Electro-Optical engineering M.Sc student. saulsh@post.bgu.ac.il
%clear all; close all; clc

if ~exist('data','var')
   data.create = 1; 
end

% video file name to open:
mainFolder = 'C:\Users\saul6\Documents\Electrooptical Eng\Thesis\Matlab\Record and Analayze\';
subFolder = 'Recordings\';
fileName = 'read_max_FPS';
file2load = fullfile(mainFolder,subFolder,fileName);

% select calculation options:

ROIcomparison = 0; % select 2 ROI: 0 = no, 1 = manual select, [x, x, x, x] = coordinates to calculate
crop_cor1 = 0; % [x, x, x, x] = coordinates to calculate, 0\1 = manual select
start_time = 0; % time to start the calculations. 0: runs from the begining of the video file
end_time = 0; % time to finish the calculations. 0: runs until the end of the video file
N = 1; % Divides the large ROI to NxN squares
newFrameRate = 0; % changes VID video frame rate
face_detect = 0; % auto face detect: 0 = no, 1 = yes.
enhance_image = 0; % enhancment of the image before processing: 0 = no, 1 = yes.
%normalize = 1; % normalize graylevel. 0 = no, 1 = yes.
average2zero = 0; % average the results to flactuate around zero (minus average)

data = IR_analysis(data, file2load, N, start_time, end_time, enhance_image, crop_cor1, ROIcomparison, average2zero);

%data = VIS_analysis(data, file2load, N, start_time, end_time, enhance_image, crop_cor1, ROIcomparison, newFrameRate);
%data = IR_analysis_facial_track(data, file2load, N, start_time, end_time, enhance_image, crop_cor1, ROIcomparison, face_detect);
%% FLIR file analysis
reduce_frame_rate = 1; % reduce the frame rate of the FLIR IR video from 80 to 40.
average2zero = 0; % average the results to flactuate around zero (minus average)
start_time = 0; % time to start the calculations. 0: runs from the begining of the video file
end_time = 0; % time to finish the calculations. 0: runs until the end of the video file
crop_cor = 0; % [x, x, x, x] = coordinates to calculate, 0\1 = manual select
N = 1; % Divides the large ROI to NxN squares

FLIRdata = FLIR_IR_analysis(N, reduce_frame_rate, average2zero, crop_cor, start_time, end_time);

%% Filters

filter_type = 'high'; % 'low' / 'high' / 'bandpass' / 'no'
cutoff_freq = 0.03; % positive number in case filter is low / high. for bandpass use: [f_low, f_high]
median = 0; % perform moving median: 0 = no, 1 = yes;

data = filterit(filter_type, cutoff_freq, median, ...
    data);

%% Plot signal
description = 'FLIR IR signals';
% plots colors by entered order: 1- Blue, 2- Orange, 3- Yellow, 4- Purple.
plotit(data, description,...
     data.IR_intens) % can plot up to 4 signals on each graph

%% FFT
FrequencyLimits = [0.03, 3]; % 2 element vector as x axis (frequency) limits
FFTplot(data, FrequencyLimits, ...
    data.IR_intens)
    
%% CWT

plotMax = 0; % plot maximum value of each frame: 0 = no, 1 = yes.
gamma = 3; % standard = 3; must be greater then 1 and lower then timeBandwidth.
timeBandwidth = 120; % must be a scalar in the range 3-120. The standard deviation of the Morse wavelet in time is approximately sqrt(TimeBandwidth/2). The standard deviation of the Morse wavelet in frequency is approximately 1/2*sqrt(2/TimeBandwidth)
VoicesPerOctave = 10; % must be an even integer from 4 to 48, defines the number of scales of the wavelet, between integer scales (fractions)
FrequencyLimits = [0, 5]; % 2 element vector as x axis (frequency) limits

CWTplot(data, plotMax, FrequencyLimits, gamma, timeBandwidth, VoicesPerOctave,...
    data.IR_intens);

%% STFT

FrequencyLimits = [0, 5]; % 2 element vector as x axis (frequency) limits
plotMax = 0; % plot maximum value of each frame: 0 = no, 1 = yes.
ns = 16; % divide the signal into ns sections of equal length
ov = 0.5; % precentage overlap between sections

STFTplot(FLIRdata, plotMax, FrequencyLimits, ns, ov,...
    FLIRdata.IR_intens);
%% Play video

% video file name to open:
mainFolder = 'C:\Users\saul6\Documents\Electrooptical Eng\Thesis\Matlab\Record and Analayze\';
subFolder = 'Recordings\';
fileName = 'Small_movements_IR';
file2load = fullfile(mainFolder,subFolder,fileName);

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
