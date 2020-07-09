function flipped_data = flipper(data, group_by)

len = size(data, 2);
counter = 1;

if strcmp(group_by, 'Played order')
    
    for i = 1:len
        if ~isempty(data{i})
            
            play_order(1, counter) = str2double((extractBefore(data{i}.var_name, '_')));
            play_order(2, counter) = i;
            counter = counter + 1;
            
        end
    end
    
    len = size(play_order, 2);
    
    for i = 1:len
        
        idx = find(play_order(1,:) == i);
        if ~isempty(idx)
            flipped_data{i} = data{play_order(2, idx)};
        end
        
    end
    
elseif strcmp(group_by, 'Video index')
    
    for i = 1:len
        if ~isempty(data{i})
            
            play_order(1, counter) = str2double((extractAfter(data{i}.var_name, '_')));
            play_order(2, counter) = i;
            counter = counter + 1;
            
        end
    end
    
    counter = 1;
    max_idx = max(play_order(1, :));
    min_idx = min(play_order(1, :));
    
    for i = min_idx:max_idx
        
        idx = find(play_order(1,:) == i);
        
        if ~isempty(idx)
            flipped_data{counter} = data{play_order(2, idx)};
            counter = counter + 1;
        end
        
    end
    
elseif strcmp(group_by, 'Emotions')
    
    for i = 1:len
        if ~isempty(data{i})
            
            play_order(1, counter) = str2double((extractAfter(data{i}.var_name, '_')));
            play_order(2, counter) = i;
            emotions(counter) = data{i}.expected_emotion;
            counter = counter + 1;
            
        end
    end

    neutral_idx = find(strcmp(emotions, 'Neutral'));
    disguat_idx = find(strcmp(emotions, 'Disguat'));
    fear_idx = find(strcmp(emotions, 'Fear'));
    amusment_idx = find(strcmp(emotions, 'Amusment'));
    sexual_Desire = find(strcmp(emotions, 'Sexual Desire'));
    none_idx = find(strcmp(emotions, 'none'));
    nan_idx = find(strcmp(emotions, 'nan'));
    
    counter = 1;
    
    for i = neutral_idx
        flipped_data{counter} = data{play_order(2, i)};
        counter = counter + 1;
    end
    
    for i = disguat_idx
        flipped_data{counter} = data{play_order(2, i)};
        counter = counter + 1;
    end
    
    for i = fear_idx
        flipped_data{counter} = data{play_order(2, i)};
        counter = counter + 1;
    end
    
    for i = amusment_idx
        flipped_data{counter} = data{play_order(2, i)};
        counter = counter + 1;
    end
    
    for i = sexual_Desire
        flipped_data{counter} = data{play_order(2, i)};
        counter = counter + 1;
    end
    
    for i = none_idx
        flipped_data{counter} = data{play_order(2, i)};
        counter = counter + 1;
    end
    
    for i = nan_idx
        flipped_data{counter} = data{play_order(2, i)};
        counter = counter + 1;
    end
    
end

end