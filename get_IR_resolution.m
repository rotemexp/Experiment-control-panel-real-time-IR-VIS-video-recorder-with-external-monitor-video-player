function res = get_IR_resolution(properties, IRInterface)

if properties.tempORcolor == 1
    THM = single(IRInterface.get_thermal()); % get gray image from IR camera
    frame_IR = ((THM - 10000) ./ 100); % change values to Celsius temperature values
elseif properties.tempORcolor == 0
    frame_IR = (IRInterface.get_palette()); % get color image from IR camera
end

res = size(frame_IR);

end