function popup_fig = popup_fig_finder(alwaysontop)

run('popup_fig.mlapp'); % run pop-up file
all_UIfigs = findall(0, 'HandleVisibility', 'off'); % find all currently running UI figures 

for i=1:length(all_UIfigs)
    
    if strcmp(all_UIfigs(i).Name, 'Popup_questions') == 1 % find the right UI figure
        break;
    end
    
end

popup_fig = all_UIfigs(i); % get the right figure handle
uifigureOnTop(popup_fig, alwaysontop); % perform always-on-top on the UI figure

warn = warning('query','last'); % find last warning (from the always-on-top function)
warning('off',warn.identifier); % disable the last warning (therfore it will apear only once)

end