function [params, data] = VISanalysis_videoFile(params)

    disp ('[0] Loading video file...');

    vidObj = VideoReader(fullfile(params.mainFolder,params.subFolder,params.fileName)); % opening the video file

    crop = 0;
    
    if params.newFrameRate == 0 % case no need to change frame rate
        params.newFrameRate = vidObj.frameRate;
        skipper = 1;
    else
        skipper = params.newFrameRate / vidObj.frameRate; % calculates the skipper value
        skipper = round(1/skipper); % inverts and rounds the skipper value to the nearest decent value that can divide the original frmae rate
        params.newFrameRate = vidObj.frameRate / skipper; % updates the new frame rate value
    end
    
    % data.eventsTiming = play_list(:,3:4); % takes the start and end time of videos playback
    
    params.frameRate = params.newFrameRate; % assignts it to a local variable so function could work after vidObj was closed
    if params.startTime == 0 % setting parameters to the desired begining
        params.frameStart = 1;
    else
        params.frameStart = round(params.startTime*vidObj.frameRate);
    end
    vidObj.currentTime = params.startTime; % setting video object to the beginning
    k = 1;
    k_skipper = params.frameStart;
   
    if params.endTime == 0, params.endTime = vidObj.Duration; end % setting the end time in range
    params.frameStop = round(params.endTime*vidObj.frameRate); % defining the frame number to stop the calculation at
    duration = params.endTime-params.startTime;
    numOfFrames = params.frameRate*duration;

    size2allocate = floor(params.startTime*vidObj.frameRate + numOfFrames - 1); % expected size of vectors
    
    Ak = zeros(params.N^2,floor(size2allocate)); % preallocating 90% before loop for efficiency
    Aidx = zeros(params.N^2,floor(size2allocate));
    Bk = zeros(params.N^2,floor(size2allocate));
    Bidx = zeros(params.N^2,floor(size2allocate));
    Ck = zeros(params.N^2,floor(size2allocate));
    Cidx = zeros(params.N^2,floor(size2allocate));
    R = zeros(floor(size2allocate), params.N^2);
    G = zeros(floor(size2allocate), params.N^2);
    B = zeros(floor(size2allocate), params.N^2);
    Rgrad = zeros(floor(size2allocate), params.N^2);
    Ggrad = zeros(floor(size2allocate), params.N^2);
    Bgrad = zeros(floor(size2allocate), params.N^2);
    Channel_cor = zeros(params.N^2,4);

    while hasFrame(vidObj) && (k <= (params.frameStop-params.frameStart))% running on each frame of the video file
        clc
        disp ('[1] Extracting signal from face regions...'); % displays precentage of progress
        disp ([num2str(round((k /(vidObj.frameRate*((duration))))*100)), ' [%]']);

        frame = im2double(readFrame(vidObj)); % reads current frame from video

        if mod(k,skipper) == 0 % checks if this frame needs to be calculated according to the new frame rate

            if crop == 0 & params.crop_cor == 0 % getting cropping coordinates by the user - runs only once
                figure(1); title('Please crop the Region Of Interest for the signal claculations');
                hold on; axis on;
                [~, params.crop_cor] = imcrop(frame);
                params.crop_cor = round(params.crop_cor);
                rectangle('Position',params.crop_cor,'LineWidth',1); % print ROI rectangular
                close figure 1;
                crop = 1; % do not run again
            end

            cropped_frame = imcrop(frame,params.crop_cor); % cropping the frame
            [row, col, ~] = size(cropped_frame); % getting cropped frame dimensions
            l = floor(row/params.N); % devides matrix hight by N
            n = floor(col/params.N); % devides matrix width by N
            begin_row = 1; % reseting parameters
            begin_col = 1;
            index = 1;

            for i=1:params.N % large ROI rows loop
                begin_col = 1;
                finish_row = begin_row + l;
                for j=1:params.N % large ROI columns loop
                    finish_col = begin_col + n;

                    if i == params.N, finish_row = row; end % at the last run the limit is the max matrix length
                    if j == params.N, finish_col = col; end % at the last run the limit is the max matrix width

                    % averaging the intensity for each color channel over each one of the small ROI's (channels):
                    R(k_skipper,index) = mean2(cropped_frame(begin_row:finish_row,begin_col:finish_col,1));
                    G(k_skipper,index) = mean2(cropped_frame(begin_row:finish_row,begin_col:finish_col,2));
                    B(k_skipper,index) = mean2(cropped_frame(begin_row:finish_row,begin_col:finish_col,3));

                    % getting the average absolute gradient according to equation 8 in the paper
                    Rgrad(k_skipper,index) = mean2(abs(imgradient(cropped_frame(begin_row:finish_row,begin_col:finish_col,1))));
                    Ggrad(k_skipper,index) = mean2(abs(imgradient(cropped_frame(begin_row:finish_row,begin_col:finish_col,2))));
                    Bgrad(k_skipper,index) = mean2(abs(imgradient(cropped_frame(begin_row:finish_row,begin_col:finish_col,3))));

                    if k == skipper % runs only once - at the first video frames loop
                        Channel_cor(index,:) = [begin_col + params.crop_cor(1,1) - 1, begin_row + params.crop_cor(1,2) - 1,...
                            finish_col - begin_col, finish_row - begin_row]; % getting channel's coordinates
                    end

                    begin_col = finish_col + 1;
                    index = index + 1;
                end
                begin_row = finish_row + 1;
            end
            k_skipper = k_skipper + 1; % increasing the skipping index
        end % end if frame needs to be calculated

        k = k + 1; % increasing the loop index for the next frame extraction itteration

    end % end while

    %% Preparing final chrominance data matrix: c
    clc
    disp ('Calculating chrominance data'); % displays progress
    
    data.V = 1.5.*R(params.frameStart:k_skipper - 1) + 2.*G(params.frameStart:k_skipper - 1) - 1.5.*B(params.frameStart:k_skipper - 1);
    data.U = 3.*R(params.frameStart:k_skipper - 1) - 2.*G(params.frameStart:k_skipper - 1);

    lambda = std(data.U) / std(data.V);
    data.c = data.U - lambda*data.V; % final data matrix: equation 3 in the paper

    data.len = k_skipper - params.frameStart; % finds the length of the data matrix ( number of frames )
    %data.tvec = linspace(params.startTime,params.endTime,floor(numOfFrames));
    data.tvec = (params.frameStart + 1 : data.len + params.frameStart) / params.frameRate;
    
    figure('Name','VIS camera: ROI selected');
    imshow(frame,[]); axis on; % plotting image and channels locations
    title(['Video file name: ', params.fileName]);
    for i=1:params.N^2
        rectangle('Position',Channel_cor(i,:),'LineWidth',1); % prints channels (small ROI) rectangular
        text(Channel_cor(i,1) + round(Channel_cor(i,3)/15), Channel_cor(i,2) +...
            round(Channel_cor(i,4)/15), num2str(i)); % prints channels numbers
    end

    if params.timeStamp4savedFile == 0 && params.saveData == 1
        Datafilename = ['Data\', params.fileName, '_analysed.mat'];
    elseif params.timeStamp4savedFile == 1 && saveData == 1
        Datafilename = ['Data\', num2str(now),'_', params.fileName, '_analysed.mat'];
    end

    if ~exist([pwd, '\Data'], 'dir') % checks if Data folder exists
        mkdir('Data\') % if it dosent - create it
    end

    clear buffer_THM; clear t; % clears unnecessary data
    if params.saveData == 1
        save(Datafilename,'-v7.3','params'); % Saves V7.3 data file (fits Python as well)
    end

    delete(vidObj); % deletes the opened video file from memory
    
    clc
    disp ('Done.');

end % end of function