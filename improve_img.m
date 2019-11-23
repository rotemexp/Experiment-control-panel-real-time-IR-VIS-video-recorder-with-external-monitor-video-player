function better_img = improve_img(img)

better_img = histeq(img); % perofrms histogram equalization
better_img(:,:,1) = medfilt2(better_img(:,:,1), [5, 5]); % performs 2D median filter
better_img(:,:,2) = medfilt2(better_img(:,:,2), [5, 5]); % performs 2D median filter
better_img(:,:,3) = medfilt2(better_img(:,:,3), [5, 5]); % performs 2D median filter
better_img = rgb2gray(better_img); % RGB image to gray scale
better_img = imgaussfilt(better_img); % perform 2D gaussian filter
better_img = histeq(better_img);

end