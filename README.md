# Thermal-Visible-face-videos-recorder-with-UI: 
Thermal and Visible video recorder software and player, designed to work with up to 2 cameras - Infrared and visible while playing emotions stimulating videos on another screen.

Written for a combined reaserch of the psycology and the electrical engineering department at Ben Gurion Univesity of the Negev.

Run main.mlapp to start the program, screen shot available here:
https://github.com/CallShaul/Experiment-control-panel---IR-VIS-camera-reconder-with-emotions-arousing-player/blob/master/Control%20panel%20image.PNG

# Video analayzer for physiologicals signals extraction:
Can be used for heart rate extraction, respiratory rate and other physiological parameters. 
Run analyze.mat to start.

# Visible spectrum camera:

If using DSLR or mirrorless camera, with USB-HDMI adapter: 
It is best to record the face video's with F/# value not too low! (about 2.2 - 2.8 should be ok) so the whole face will be kept in focus during the recording. It is also reccomended to use as low ISO value as possible, to reduce sensor noise - so good lightning is required for that.

I reccomend using ELP USB camera, with manual optical zoom and focus, based on the sensor: Sony IMX179, link for the camera:
https://www.amazon.com/gp/product/B07R4CLRQH/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1


# Infrared camera:
The video recorder fits OPTRIS IR camera's and specifically PI450 model, and it can be easily modified to work with other IR cameras.
link for the PI450 IR camera: https://www.optris.global/thermal-imager-optris-pi-400i-pi-450i

# Remarks:
Requirements:
- Image processing toolbox is required.
- “MATLAB Support Package for USB Webcams” and “MATLAB Support for MinGW-w64 C/C++ Compiler” add-ons are required.
- VLC player is required in order to use the "play videos" functions (For Windows 10, 64 bit: https://download.cnet.com/VLC-Media-Player-64-bit/3000-13632_4-75761094.html).

- Some of the VISanalysis function algorithm was inspired by the paper: Motion-resistant heart rate measurement from face videos using patch-based fusion
https://www.researchgate.net/publication/330323577_Motion-resistant_heart_rate_measurement_from_face_videos_using_patch-based_fusion

- Code written in MATLAB 2019b by Shaul Shvimmer, Electro-Optical engineering M.Sc student. saulsh@post.bgu.ac.il
This code was written for reaserch purposes, if this work assists you please cite.
