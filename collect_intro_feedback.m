function [age, sex, orientation] = collect_intro_feedback(app)

age = uint8(str2double(app.DropDown_age.Value));

if app.Button_male.Value == 1
    sex = 'male';
elseif app.Button_female.Value == 1
    sex = 'female';    
end


if app.Button_hetro.Value == 1
    orientation = 'hetro';
elseif app.Button_homo.Value == 1
    orientation = 'homo';
elseif app.Button_bi.Value == 1
    orientation = 'bi';
elseif app.Button_no_ans.Value == 1
    orientation = 'no_ans';
end

end

