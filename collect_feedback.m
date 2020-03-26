function [posneg, wake, feel] = collect_feedback(app)

feel = zeros(1,5);
posneg = 0;
wake = 0;

if app.posneg_1.Value == 1
    posneg = 1;
elseif app.posneg_2.Value == 1
    posneg = 2;
elseif app.posneg_3.Value == 1
    posneg = 3;
elseif app.posneg_4.Value == 1
    posneg = 4;
elseif app.posneg_5.Value == 1
    posneg = 5;
elseif app.posneg_6.Value == 1
    posneg = 6;
elseif app.posneg_7.Value == 1
    posneg = 7; 
elseif app.posneg_8.Value == 1
    posneg = 8;
elseif app.posneg_9.Value == 1
    posneg = 9;
end

if app.wake_1.Value == 1
    wake = 1;
elseif app.wake_2.Value == 1
    wake = 2;
elseif app.wake_3.Value == 1
    wake = 3;
elseif app.wake_4.Value == 1
    wake = 4;
elseif app.wake_5.Value == 1
    wake = 5;
elseif app.wake_6.Value == 1
    wake = 6;
elseif app.wake_7.Value == 1
    wake = 7;
elseif app.wake_8.Value == 1
    wake = 8;
elseif app.wake_9.Value == 1
    wake = 9;
end

if app.feel_1.Value == 1
    feel(1) = 1;
end
if app.feel_2.Value == 1
    feel(2) = 1;
end
if app.feel_3.Value == 1
    feel(3) = 1;
end
if app.feel_4.Value == 1
    feel(4) = 1;
end
if app.feel_5.Value == 1
    feel(5) = 1;
end 

end