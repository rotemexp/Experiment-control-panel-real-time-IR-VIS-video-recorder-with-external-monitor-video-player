clear all; 

% initialize the interface as a global variable
global IRInterface;
IRInterface = EvoIRMatlabInterface; 

% initialize the viewer
IRViewer = EvoIRViewer; 
global viewer_is_running; 

% check for connection error
if ~IRInterface.connect()                   
    return
end

% set temp range (uncomment next line for usage)
%IRInterface.set_temperature_range(-20, 100);
tic
% main loop
parfor i=1:100

    % grab image data
    RGB = IRInterface.get_palette();        % grab palette image
    THM = IRInterface.get_thermal();        % grab thermal image
    
    % process data here...
    
    % draw RGB image
    imagesc(RGB);                           
    drawnow();   
    
end
toc
IRInterface.terminate();                    % disconnect from camera

close all; 
