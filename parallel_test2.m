clear all;

len = 100;
weblist = webcamlist;
cam = webcam(string(weblist(1,1)));
img = snapshot(cam);
[r, c, ~] = size(img);
vid = zeros(r, c, 3, len);

f = @snapshot;

tic
parfor i=1:len

    vid(:, :, :, i) = feval(f,cam)

end
toc

clear('cam');