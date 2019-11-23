function play(file2load, fast_play)

disp ('[0] Loading camera data...');

load(file2load);

if exist('buffer_IR','var') == 0 && exist('buffer_VIS','var') == 0 && exist('buffer_IR_palette','var') == 0
    error('No data file to process was found') % no data_IR file to process
    return
end

data_dimenstions = length(size(buffer_IR)); % if = 3: temperature data, if = 4: color data

dual = 0;
if exist('buffer_IR','var') == 1 && exist('buffer_VIS','var') == 1 % checks if VIS camera data file have been loaded
    dual = 1;
end
if exist('buffer_IR','var') == 1 % checks if IR camera data file have been loaded as well
    dual = 0;
end

if frame_rate ~= 0 && fast_play == 0
    just_run = 0;
elseif fast_play == 1
    just_run = 1;
end

segment_time = 1/frame_rate;
len = length(buffer_IR);
i = 1;
fig = figure();
%IRViewer = EvoIRViewer; % opens up the viewer

tStart = tic;

while(i <= len)
    
    if ishandle(fig) == 0
        break;
    end
    
    if dual == 1
        if data_dimenstions == 3
            imagesc(buffer_IR(:,:,i)); colormap(gray);% draw temperature IR image
        elseif data_dimenstions == 4
            imagesc(buffer_IR(:,:,:,i)); colormap(gray);% draw color IR image
        end
        imagesc(subplot(1,2,2),buffer_VIS(:,:,i)); % draw VIS image
    elseif dual == 0
        if data_dimenstions == 3
            imagesc(buffer_IR(:,:,i)); colormap(gray);% draw temperature IR image
        elseif data_dimenstions == 4
            imagesc(buffer_IR(:,:,:,i)); colormap(gray);% draw color IR image
        end
    end
    
    t = toc(tStart);
    
    if t >= segment_time && just_run == 0
        clc
        disp ([num2str(i*segment_time), ' [Sec]']);
        i = i + 1;
        tStart = tic;
    end
    
    if just_run == 1
        clc
        disp ([num2str(i*segment_time), ' [Sec]']);
        i = i + 1;
        tStart = tic;
    end
    drawnow();
end

end