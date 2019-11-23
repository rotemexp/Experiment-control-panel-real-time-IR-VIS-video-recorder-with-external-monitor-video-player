function crop_cor = ROIcrop(app, frame)

if app ~= 2 
    status(app, 'Please crop the Region Of Interest.', 'g', 1, 0);
end

fig = figure('Name', 'Please crop the Region Of Interest');
title('Please crop the Region Of Interest');
hold on; axis on;
[~, crop_cor] = imcrop(frame,[]);
crop_cor = round(crop_cor);

if numel(crop_cor) ~= 0
    close (fig); % case user pressed the X button
end

end