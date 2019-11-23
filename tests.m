%%
s = serial('COM4','BaudRate',115200);
fopen(s)
set(s,'Terminator','CR');
fgets(s)

%%
s = serial('COM4','BaudRate',115200);
fopen(s)
fprintf(s,'T?')

s.BytesAvailable
out = fread(s,s.BytesAvailable,'uint8')
%% close

fclose(s)
delete(s)
clear s