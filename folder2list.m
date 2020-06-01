function list = folder2list(~, location)

try
    if location(end) ~= '\' % case last backslesh is missing
        location = [location, '\'];
    end
    
    files = [dir([location,'*.mp4']) ; dir([location,'*.avi']) ; dir([location,'*.mov']) ; ...
        dir([location,'*.mts']) ; dir([location,'*.mpg']) ; dir([location,'*.wmv']) ; ...
        dir([location,'*.mkv']) ; dir([location,'*.gif']) ; dir([location,'*.jpg']); ...
        dir([location,'*.png'])];
    %files = nestedSortStruct(files, 'name'); % loading folder content
catch
end

if exist('files','var') == 1 && isempty(files) == 0
    len = length(files);
    for i=1:len % building integer vector with files number
        [token,remain] = strtok(files(i).name,'.');
        files(i).idx = str2num(['uint8(',token,')']);
        
        if isempty(files(i).idx) == 1           
            files(i).idx = str2double(token(1:strfind(token, '_')-1)); % case idx was empty: idxwill be the number at the beginning of the file name (before _)
            
            if isnan(files(i).idx)
               files(i).idx = str2double(token(1:find(isletter(token), 1)-1)); % case idx was empty: idxwill be the number at the beginning of the file name (before _)
            end
            
        end
        
        if strcmp(remain,'.mp4') == 1 || strcmp(remain,'.avi') == 1 || strcmp(remain,'.mov') == 1 ...
                || strcmp(remain,'.mts') == 1 || strcmp(remain,'.mpg') == 1 || strcmp(remain,'.wmv') == 1 ...
                || strcmp(remain,'.mkv') == 1
            vidObj = VideoReader([files(i).folder, '\', files(i).name]); % open video file
            files(i).duration = vidObj.Duration; % saves it's duration to the structure
        else % case file is an image file
            files(i).duration = 0;
            files(i).idx = i;
        end
    end
    
    [~, idx] = sort([files.idx]); % get sorted order indexes
    list = files(idx); % sort by indexes 
    
else
    list = 0;
end

end

%{
    j = 1;
    for i=1:len % arranging file structure by file name in ascending way
        [~, col] = find([files.idx] == i);
        
        if isempty(col) == 0 % case files name are numbered
            list(j) = files(col(1)); % buils the new list
            files(col(1)).idx = []; % remove added value from list
            j = j + 1;
        else % case random file names
            list = files;
            
            for j=1:len
                list(j).idx = j;
            end
            
            break;
        end
    end
        
        [r, c] = size(list);
if c > r
    list = list'; % case images, need to transpose list
end
        
%}

