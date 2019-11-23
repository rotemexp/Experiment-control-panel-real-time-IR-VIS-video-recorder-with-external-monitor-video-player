function plotit(data, description, sig1, sig2, sig3, sig4)
% function plots up to 4 data vectors on each graph

if isfield(data, 'eventsTiming') == 1
    eventsTiming = data.eventsTiming;
end

figure('Name', description); % opens a new figure window
for i=1:data.N^2
    
    if exist('sig1','var') == 1 % plot 1st data vector
        subplot(data.N,data.N,i); plot(data.tvec, sig1(:,i));%, 'Color', [0.68,0.83,0.07]);
        title(['IR intensity at channel ' num2str(i)]);
        xlabel('Time [sec]'); ylabel('Temperature [c]');
        xlim([data.start_time, data.end_time]);
        hold on;
        axis on;
        mini(1) = min(sig1(:,i));
        maxi(1) = max(sig1(:,i));
    end
    
    if exist('sig2','var') == 1 % plot 2nd data vector - if exist
        subplot(data.N,data.N,i); plot(data.tvec, sig2(:,i));%, 'Color', [0.5 0.5 0.5]);
        title(['Average temperature / intensity at channel ' num2str(i)]);
        xlabel('Time [sec]'); ylabel('Temperature [c]');
        xlim([data.start_time, data.end_time]);
        hold on;
        axis on;
        mini(2) = min(sig2(:,i));
        maxi(2) = max(sig2(:,i));
    end
    
    if exist('sig3','var') == 1 % plot 3rd data vector - if exist
        subplot(data.N,data.N,i); plot(data.tvec, sig3(:,i));%, 'Color', [0.5 0.5 0.5]);
        title(['Average temperature / intensity at channel ' num2str(i)]);
        xlabel('Time [sec]'); ylabel('Temperature [c]');
        xlim([data.start_time, data.end_time]);
        hold on;
        axis on;
        mini(3) = min(sig3(:,i));
        maxi(3) = max(sig3(:,i));
    end
    
    if exist('sig4','var') == 1 % plot 4th data vector - if exist
        subplot(data.N,data.N,i); plot(data.tvec, sig4(:,i));%, 'Color', [0.5 0.5 0.5]);
        title(['Average temperature / intensity at channel ' num2str(i)]);
        xlabel('Time [sec]'); ylabel('Temperature [c]');
        xlim([data.start_time, data.end_time]);
        hold on;
        axis on;
        mini(4) = min(sig4(:,i));
        maxi(4) = max(sig4(:,i));
    end
    
    if isfield(data, 'eventsTiming') == 1
        for j=1:length(eventsTiming) % prints experiments timing lines on each plot
            line([eventsTiming(j,1), eventsTiming(j,1)],[min(mini), max(maxi)],'LineStyle',':','Color','blue') % start
            line([eventsTiming(j,2), eventsTiming(j,2)],[min(mini), max(maxi)],'LineStyle',':','Color','red') % end
        end
    end

end

end