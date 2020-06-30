function better_frame = img_enhancement(frame)

if length(size(frame)) == 3 % case color image
    
    better_frame = histeq(frame); % perofrms histogram equalization
    better_frame(:,:,1) = medfilt2(better_frame(:,:,1), [5, 5]); % performs 2D median filter
    better_frame(:,:,2) = medfilt2(better_frame(:,:,2), [5, 5]); % performs 2D median filter
    better_frame(:,:,3) = medfilt2(better_frame(:,:,3), [5, 5]); % performs 2D median filter
    better_frame = rgb2gray(better_frame); % RGB image to gray scale
    better_frame = imgaussfilt(better_frame); % perform 2D gaussian filter
    better_frame = histeq(better_frame);
    
else % case black & white image (thermal)
    
    better_frame = frame ./ max(max(frame));
    better_frame = better_frame .* 256;
    better_frame = uint8(better_frame);
    %better_frame = histeq(better_frame);
    
end

end