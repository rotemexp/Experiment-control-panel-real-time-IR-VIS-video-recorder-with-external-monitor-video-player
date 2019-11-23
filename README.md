# Thermal-Visible-face-videos-recorder-with-UI: 
Thermal and Visible video recorder software, designed to work with up to 2 cameras - Infrared and visible.

Run Main_V1_exported.m to start:  https://i.imgur.com/sT9h6Z4.png

# Video analayzer for physiologicals signals extraction:
Can be used for heart rate extraction, respiratory rate and other physiological parameters. 

Run analyze.mat to start.

# Visible spectrum camera:
It is best to record the face video's with F/# value not too low! (about 2.2 - 2.8 should be ok) so the whole face will be kept in focus during the recording. It is also reccomended to use as low ISO value as possible, to reduce sensor noise.

# Infrared camera:
The video recorder fits OPTRIS IR camera's and specifically PI450 model.

# Remarks:

 - You need image processing, signal processing, wavelet toolboxes to run this code properly.

- Some of the VISanalysis function algorithm was inspired by the paper: Motion-resistant heart rate measurement from face videos using patch-based fusion
https://www.researchgate.net/publication/330323577_Motion-resistant_heart_rate_measurement_from_face_videos_using_patch-based_fusion

- Code written in MATLAB 2018b by Shaul Shvimmer, Electro-Optical engineering M.Sc student. saulsh@post.bgu.ac.il
This code was written for reaserch purposes, if this work assists you please cite.
