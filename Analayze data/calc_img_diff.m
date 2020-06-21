function [diff_img, sum_diff_img] = calc_img_diff(img1, img2, normalize)

diff_img = abs(img1 - img2);

if normalize == 1
    mini = min(min(diff_img));
    maxi = max(max(diff_img));
    diff_img_norm = diff_img - mini;
    diff_img = 255*(diff_img_norm ./ maxi);
end

end

