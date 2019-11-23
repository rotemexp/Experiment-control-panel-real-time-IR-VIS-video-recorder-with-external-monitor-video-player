function signalplot(data, Plot_IR, Plot_filtered_IR, Plot_VIS, Plot_filtered_VIS)

disp ([datestr(now), ' - Calculating signal']); % displays progress

%% plots signal
if Plot_IR == 1 && Plot_VIS == 1
    
    if isfield(data, 'IR_intens2') == 1
        plotit(data, 'IR and VIS signal', data.IR_intens, data.IR_intens2) % needs to add VIS signal
        plotit(data, 'IR diff signal', data.IR_diff)
    else
        plotit(data, 'IR and VIS signal', data.IR_intens) % needs to add VIS signal
    end
    
elseif Plot_IR == 1
    
    if isfield(data, 'IR_intens2') == 1
        plotit(data, 'IR signal', data.IR_intens, data.IR_intens2)
        plotit(data, 'IR diff signal', data.IR_diff)
    else
        plotit(data, 'IR signal', data.IR_intens)
    end
    
elseif Plot_VIS == 1
    
    plotit(data, 'VIS signal', data.VIS_intens)
end

%% plots filtered signal

if Plot_filtered_IR == 1 && Plot_filtered_VIS == 1
    
    if isfield(data, 'IR_filt_intens2') == 1
        plotit(data, 'Filtered IR and VIS signal', data.IR_filt_intens, data.IR_filt_intens2) % needs to add VIS signal
        plotit(data, 'Filtered IR diff signal', data.IR_filt_diff)
    else
        plotit(data, 'Filtered IR and VIS signal', data.IR_filt_intens) % needs to add VIS signal
    end
    
elseif Plot_filtered_IR == 1
    
    if isfield(data, 'IR_filt_intens2') == 1
        plotit(data, 'Filtered IR signal', data.IR_filt_intens, data.IR_filt_intens2)
        plotit(data, 'Filtered IR diff signal', data.IR_filt_diff)
    else
        plotit(data, 'Filtered IR signal', data.IR_filt_intens)
    end
    
elseif Plot_filtered_VIS == 1
    
    plotit(data, 'Filtered VIS signal', data.VIS_filt_intens)
    
end

end % end of function
