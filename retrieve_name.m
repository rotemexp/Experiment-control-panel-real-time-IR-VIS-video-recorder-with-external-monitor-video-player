function file_name = retrieve_name(file2load)

[token, ~] = strtok(file2load,'.'); % removes the '.mat' if exists

if numel(strfind(token,'\')) == 0 % case there's no '\' to stop the upcoming while loop
   file_name = 0;
   return 
end

i = 0;
while (true)
    
    if strcmp(token(end-i),'\') == 1 || strcmp(token(end-i),'/') == 1 % check if need to break while loop
        break
    else
        name(i+1) = token(end-i); % get right to left file name
    end
    i = i + 1;
    
end

for i=1:numel(name)
    file_name(i) = name(end-i+1); % fix file name: left to right
end

end