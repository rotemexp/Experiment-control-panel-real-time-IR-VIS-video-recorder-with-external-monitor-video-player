function play(file2load, channel, video_number, fast_play, segment_time, show_differences)

[raw_vis, raw_ir, properties] = get_raw_vid(file2load, video_number, channel); % get video from data file

if ndims(raw_vis) > 2 & ndims(raw_ir) > 2  % checks if VIS camera data file have been loaded
    vis_dimenstions = ndims(raw_vis);
    ir_dimenstions = ndims(raw_ir);
    len = size(raw_ir, ir_dimenstions);
    mode = 1;
elseif ndims(raw_vis) > 2 % checks if IR camera data file have been loaded
    vis_dimenstions = ndims(raw_vis);
    ir_dimenstions = 0;
    len = size(raw_vis, vis_dimenstions);
    mode = 0;
elseif ndims(raw_ir) > 2 % checks if IR camera data file have been loaded
    ir_dimenstions = ndims(raw_ir);
    vis_dimenstions = 0;
    len = size(raw_ir, ir_dimenstions);
    mode = 0;
else
    disp('Error loading video from data file.');
    return
end

if show_differences == 1
    show_differences = 0;
end

frame_rate = properties.play_list(video_number, 8);

if segment_time == 0
    segment_time = 1/frame_rate; % original frame time
end

i = 1;
fig = figure();
tStart = tic;
frame_counter = 0;
if vis_dimenstions == 3     
    sum_diff_img = uint16(zeros(size(raw_vis(:,:,1))));
elseif vis_dimenstions == 4
    sum_diff_img = uint16(zeros(size(raw_vis(:,:,:,1))));
end
%tTotal = tic;

while(i < (len - show_differences)) & (ishandle(fig) == 1)
    
    if mode == 1 % dual channel view
        
        imagesc(subplot(1,2,1));
        
        if ir_dimenstions == 3
            
            if show_differences == 0
                imagesc(raw_ir(:,:,i));
            else
                diff_img = abs(raw_ir(:,:,i) - raw_ir(:,:,i + show_differences));
                mini = min(min(diff_img));
                maxi = max(max(diff_img));
                diff_img_norm = 255 * (diff_img - mini)./(maxi-mini);
                imagesc(diff_img_norm);
            end
            
            if i == 1
                colormap(gray);% draw temperature IR image
            end
            
        elseif ir_dimenstions == 4
            
            if show_differences == 0
                imagesc(raw_ir(:,:,:,i));
            else
                diff_img = abs(raw_ir(:,:,:,i) - raw_ir(:,:,:,i + show_differences));
                mini = min(min(diff_img));
                maxi = max(max(diff_img));
                diff_img_norm = 255 * (diff_img - mini)./(maxi-mini);
                imagesc(diff_img_norm);
            end
            
        end
        
        imagesc(subplot(1,2,2));
        
        if vis_dimenstions == 3
            
            if show_differences == 0
                imagesc(raw_vis(:,:,i)); % draw VIS image
            else
                diff_img = abs(raw_vis(:,:,i) - raw_vis(:,:,i + show_differences));
                mini = min(min(diff_img));
                maxi = max(max(diff_img));
                diff_img_norm = diff_img - mini;
                diff_img_norm = 255*(diff_img_norm ./ maxi);
                imagesc(diff_img_norm);
            end
            
            if i == 1
                colormap(gray);% draw temperature IR image
            end
            
        elseif vis_dimenstions == 4
            
            if show_differences == 0
                imagesc(raw_vis(:,:,:,i)); % draw VIS image
            else
                diff_img = abs(raw_vis(:,:,:,i) - raw_vis(:,:,:,i + show_differences));
                mini = min(min(diff_img));
                maxi = max(max(diff_img));
                diff_img_norm = diff_img - mini;
                diff_img_norm = 255*(diff_img_norm ./ maxi);
                imagesc(diff_img_norm);
            end
            
            %else
            % disp(['Error playing video # ', num2str(video_number)])
            % return
        end
        
    elseif mode == 0 % single channel view
        
        if ir_dimenstions == 3
            
            if show_differences == 0
                imagesc(raw_ir(:,:,i));
            else
                diff_img = abs(raw_ir(:,:,i) - raw_ir(:,:,i + show_differences));
                mini = min(min(diff_img));
                maxi = max(max(diff_img));
                diff_img_norm = 255 * (diff_img - mini)./(maxi-mini);
                imagesc(diff_img_norm);
            end
            
            if i == 1
                colormap(gray);% draw temperature IR image
            end
            
        elseif ir_dimenstions == 4
            
            if show_differences == 0
                imagesc(raw_ir(:,:,:,i));
            else
                diff_img = abs(raw_ir(:,:,:,i) - raw_ir(:,:,:,i + show_differences));
                mini = min(min(diff_img));
                maxi = max(max(diff_img));
                diff_img_norm = 255 * (diff_img - mini)./(maxi-mini);
                imagesc(diff_img_norm);
            end
            
        end
        
        if vis_dimenstions == 3
            
            if show_differences == 0
                imagesc(raw_vis(:,:,i));
            else
                diff_img = abs(raw_vis(:,:,i) - raw_vis(:,:,i + show_differences));
                mini = min(min(diff_img));
                maxi = max(max(diff_img));
                diff_img_norm = diff_img - mini;
                diff_img_norm = 255*(diff_img_norm ./ maxi);
                imagesc(diff_img_norm);
            end
            
            if i == 1
                colormap(gray);% draw temperature IR image
            end
            
        elseif vis_dimenstions == 4
            
            if show_differences == 0
                imagesc(raw_vis(:,:,:,i));
            else
                diff_img = abs(raw_vis(:,:,:,i) - raw_vis(:,:,:,i + show_differences));
                mini = min(min(diff_img));
                maxi = max(max(diff_img));
                diff_img_norm = diff_img - mini;
                diff_img_norm = 255*(diff_img_norm ./ maxi);
                imagesc(diff_img_norm);
            end
            
        end
        
    end
    
    sum_diff_img = sum_diff_img + uint16(diff_img);
    frame_counter = frame_counter + 1;
    drawnow();
    t = toc(tStart);
    
    if fast_play == 0
        
        if t >= segment_time
            clc
            disp ([num2str(i/frame_rate), ' [Sec]']);
            
            if show_differences == 0
                i = i + 1;
            else
                i = i + show_differences;
            end
            
            tStart = tic;
        else
            pause(segment_time - t);
            clc
            disp ([num2str(i/frame_rate), ' [Sec]']);
            
            if show_differences == 0
                i = i + 1;
            else
                i = i + show_differences;
            end
            
            tStart = tic;
        end
        
    elseif fast_play == 1
        
        clc
        disp ([num2str(i/frame_rate), ' [Sec]']);
        
        if show_differences == 0
            i = i + 1;
        else
            i = i + show_differences;
        
        end
        tStart = tic;
        
    end
    
end % end while loop
%toc(tTotal)
if ishandle(fig) == 1
    close(fig);
end


%{
figure();
mini = min(min(sum_diff_img));
maxi = max(max(sum_diff_img));
sum_diff_img_norm = sum_diff_img - mini;
sum_diff_img_norm = 255*(sum_diff_img_norm ./ maxi);
imshow(sum_diff_img_norm,[])
%}
end