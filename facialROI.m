function [forehead_cor, nose_cor] = facialROI(frame)



frame2 = frame ./ max(max(frame));
frame2 = frame2 .* 256;
frame2 = uint8(frame2);
frame2 = histeq(frame2);

% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();
face_cor = step(faceDetector, frame2);
bboxPoints = bbox2points(face_cor(1, :));

points = detectMinEigenFeatures(frame2, 'ROI', face_cor);

pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Initialize the tracker with the initial point locations and the initial
% video frame.
points = points.Location;
initialize(pointTracker, points, frame2);

oldPoints = points;


% Track the points. Note that some points may be lost.
[points, isFound] = step(pointTracker, frame2);
visiblePoints = points(isFound, :);
oldInliers = oldPoints(isFound, :);

if size(visiblePoints, 1) >= 2 % need at least 2 points
    
    % Estimate the geometric transformation between the old points
    % and the new points and eliminate outliers
    [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
        oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
    
    % Apply the transformation to the bounding box points
    bboxPoints = transformPointsForward(xform, bboxPoints);
    
    % Insert a bounding box around the object being tracked
    bboxPolygon = reshape(bboxPoints', 1, []);
    %frame2 = insertShape(frame2, 'Polygon', bboxPolygon, 'LineWidth', 2);
    
    % Display tracked points
    %videoFrame = insertMarker(videoFrame, visiblePoints, '+', ...
    %'Color', 'white');
    
    % Reset the points
    oldPoints = visiblePoints;
    setPoints(pointTracker, oldPoints);
end


%figure, imshow(frame2), hold on, title('Detected features');
%plot(points);


% Clean up
release(videoFileReader);
release(videoPlayer);
release(pointTracker);

forehead_cor = 1;
nose_cor = 1;
end