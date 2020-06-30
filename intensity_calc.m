function ret = intensity_calc(N, frame, crop_cor)

[row, col, ~] = size(frame); % getting cropped frame dimensions
l = floor(row/N); % devides matrix hight by N
n = floor(col/N); % devides matrix width by N
begin_row = 1; % reseting parameters
%begin_col = 1;
index = 1;

for i=1:N % large ROI rows loop
    begin_col = 1;
    finish_row = begin_row + l;
    for j=1:N % large ROI columns loop
        finish_col = begin_col + n;
        
        if i == N, finish_row = row; end % at the last run the limit is the max matrix length
        if j == N, finish_col = col; end % at the last run the limit is the max matrix width
        
        if numel(crop_cor) == 1 % case intensity calculation is required
            
            ret(index) = mean2(frame(begin_row:finish_row,begin_col:finish_col,:)); % averaging the intensity over each one of the small ROI's (channels):
            
        else % case ROI coordinates is required
            
            ret(index,:) = [begin_col + crop_cor(1,1) - 1, begin_row + ...
                crop_cor(1,2) - 1, finish_col - begin_col, finish_row - begin_row]; % getting channel's coordinates
        end
        
        begin_col = finish_col + 1;
        index = index + 1;
    end
    begin_row = finish_row + 1;
end

end