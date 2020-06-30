function [raw_vis, raw_ir, var_name, properties] = get_raw_vid(file2load, idx, channel, extract_after)

looking4 = idx;
idx = 1;
file_details = whos('-file', file2load); % get variables list from data file
max_data_vars = round((numel(file_details)-1)/2);
vid_num = 0;

while idx <= max_data_vars && vid_num ~= looking4

    ir_var = file_details(idx).name; % correlates IR data segment to VIS data segment
    
    if strcmp(extractBefore(ir_var, "_"), 'IR') == 1
        
        var_name = extractAfter(ir_var, "_");
        
        if extract_after == 1
            vis_var = ['VIS_', var_name];
            vid_num = uint16(str2double(extractBefore(var_name, "_")));
            if vid_num == 0
                vid_num = uint16(str2double(extractAfter(ir_var, "_")));
            end
        else
            after2 = extractAfter(var_name, "_");
            vis_var = ['VIS_', var_name];
            vid_num = uint16(str2double(extractAfter(var_name, "_")));
            if vid_num == 0
                vid_num = uint16(str2double(after2));
            end
        end

    else
        % need to write for a case of VIS data files only
    end
    idx = idx + 1;
end

if vid_num ~= looking4
    raw_vis = 0;
    raw_ir = 0;
    properties = 0;
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