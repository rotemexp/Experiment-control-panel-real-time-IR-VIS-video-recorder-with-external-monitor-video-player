function [raw_vis, raw_ir, properties] = get_raw_vid(file2load, idx, channel)

looking4 = idx;
idx = 1;
file_details = whos('-file', file2load); % get variables list from data file
max_data_vars = (numel(file_details)-1)/2;
vid_num = 0;

while idx <= max_data_vars && vid_num ~= looking4

    ir_var = file_details(idx).name; % correlates IR data segment to VIS data segment
    if strcmp(extractBefore(ir_var, "_"), 'IR') == 1
        after = extractAfter(ir_var, "_");
        vis_var = ['VIS_', after];
        vid_num = uint16(str2double(extractBefore(after, "_")));
        if vid_num == 0
            vid_num = uint16(str2double(extractAfter(ir_var, "_")));
        end
        %vid_num2 = uint16(find(strcmp({file_details.name}, vis_var)==1));
    end
    idx = idx + 1;
end

if vid_num ~= looking4
    disp(['Error loading video # ', num2str(looking4), ' from file.']);
    return
end

if strcmp(channel, 'IR')
    load(file2load, ir_var, 'properties');
elseif strcmp(channel, 'VIS')
    load(file2load, vis_var, 'properties');
else
    load(file2load, ir_var, vis_var, 'properties');
end

if exist(ir_var,'var')
    eval(['raw_ir = ', ir_var, ';']);
else
    raw_ir = 0;
end

if exist(vis_var,'var')
    eval(['raw_vis = ', vis_var,';']);
else
    raw_vis = 0;
end

end