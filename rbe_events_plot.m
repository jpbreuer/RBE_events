clear all;close all;

eventTimes = importdata('RBE_times.txt',' ');
eventTime = datenum(eventTimes, 'yyyy-mm-dd HH:MM:SS');
RelativeTime = ([7, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;

BeforeTime = eventTime - RelativeTime;
AfterTime = eventTime + RelativeTime;
startTime = cellstr(datestr(BeforeTime, 'yyyy-mm-dd HH:MM:SS'));
endTime = cellstr(datestr(AfterTime, 'yyyy-mm-dd HH:MM:SS'));

all = 1; % 0 individual event plots
data_download = 0; % 1 downloads text files per event

for ii = 1:length(startTime)
    %% IMF Bz
    if data_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=B_z&resource=ACE&resourceInstance=ACE&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
        filename = sprintf('IMF_Bz_%s.txt',eventTimes{ii}(1:10));
        outfilename = websave(filename,url);
    end
    
    IMF_Bz_data = importdata(sprintf('IMF_Bz_%s.txt',eventTimes{ii}(1:10)),' ',1);
    
    Timestamp = [strcat(IMF_Bz_data.textdata(2:end,1),{' '},IMF_Bz_data.textdata(2:end,2))];
    Bz = IMF_Bz_data.data(:,1);
    
    errorIndex = find(Bz == -999.9);
    Bz(errorIndex) = NaN;
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    t = datenum(Timestamp);
    dt = length(startIndex:endIndex);
    %     plotRange = linspace(0,1,dt);
    plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);

    if all == 1
        figure(1)
        subplot(6,1,1)
        plot(startIndex:endIndex,Bz(startIndex:endIndex));hold on;ylabel('IMF Bz [nT]');grid minor
        title('RBE Events [+/- 7 days]');
        set(gca, 'XTick',[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,1)
        plot(plotRange,Bz(startIndex:endIndex));hold on;ylabel('IMF Bz [nT]');grid minor
        title(sprintf('RBE Event Time: %s [+/- 7 days]', eventTimes{ii}));
        set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
        set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
    end
    %% Solar Wind BulkSpeed
    if data_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=BulkSpeed&resource=ACE&resourceInstance=ACE&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
        filename = sprintf('SW_BulkSpeed_%s.txt',eventTimes{ii}(1:10));
        outfilename = websave(filename,url);
    end
    
    BulkSpeed_data = importdata(sprintf('SW_BulkSpeed_%s.txt',eventTimes{ii}(1:10)),' ',1);
    
    Timestamp = [strcat(BulkSpeed_data.textdata(2:end,1),{' '},BulkSpeed_data.textdata(2:end,2))];
    BulkSpeed = BulkSpeed_data.data(:,1);
    
    errorIndex = find(BulkSpeed == -9999.9);
    BulkSpeed(errorIndex) = NaN;
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    t = datenum(Timestamp);
    dt = length(startIndex:endIndex);
    %     plotRange = linspace(0,1,dt);
    plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);

    if all == 1
        subplot(6,1,2)
        plot(startIndex:endIndex,BulkSpeed(startIndex:endIndex));hold on;ylabel('SW Vel. [km/s]');grid minor
        set(gca, 'XTick',[length(BulkSpeed)/15 length(BulkSpeed)*2/15 length(BulkSpeed)*3/15 length(BulkSpeed)*4/15 length(BulkSpeed)*5/15 length(BulkSpeed)*6/15 length(BulkSpeed)*7/15 length(BulkSpeed)*8/15 length(BulkSpeed)*9/15 length(BulkSpeed)*10/15 length(BulkSpeed)*11/15 length(BulkSpeed)*12/15 length(BulkSpeed)*13/15 length(BulkSpeed)*14/15 length(BulkSpeed)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,2)
        plot(plotRange,BulkSpeed(startIndex:endIndex));hold on;ylabel('SW Vel. [km/s]');grid minor
        set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
        set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
    end
    

    %% GOES e- flux (0.8 - 2 MeV)
    if data_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=E_8,E2_0&resource=GOES-13,GOES-13&resourceInstance=GOES-13,GOES-13&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
        filename = sprintf('GOES_e-_flux_%s.txt',eventTimes{ii}(1:10));
        outfilename = websave(filename,url);
    end
    
    E_flux_data = importdata(sprintf('GOES_e-_flux_%s.txt',eventTimes{ii}(1:10)),' ',1);
    
    Timestamp = [strcat(E_flux_data.textdata(2:end,1),{' '},E_flux_data.textdata(2:end,2))];
    E_flux_data_08 = E_flux_data.data(:,1);
    E_flux_data_20 = E_flux_data.data(:,2);
    
    errorIndex = find(E_flux_data_08 == -100000);
    E_flux_data_08(errorIndex) = NaN;
    
    errorIndex = find(E_flux_data_20 == -100000);
    E_flux_data_20(errorIndex) = NaN;
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    t = datenum(Timestamp);
    dt = length(startIndex:endIndex);
    %     plotRange = linspace(0,1,dt);
    plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);

    if all == 1
        subplot(6,1,3)
        plot(startIndex:endIndex,E_flux_data_08(startIndex:endIndex));hold on;ylabel('e- Flux [0.8 MeV]');grid minor
        set(gca, 'XTick',[length(E_flux_data_08)/15 length(E_flux_data_08)*2/15 length(E_flux_data_08)*3/15 length(E_flux_data_08)*4/15 length(E_flux_data_08)*5/15 length(E_flux_data_08)*6/15 length(E_flux_data_08)*7/15 length(E_flux_data_08)*8/15 length(E_flux_data_08)*9/15 length(E_flux_data_08)*10/15 length(E_flux_data_08)*11/15 length(E_flux_data_08)*12/15 length(E_flux_data_08)*13/15 length(E_flux_data_08)*14/15 length(E_flux_data_08)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        subplot(6,1,4)
        plot(startIndex:endIndex,E_flux_data_20(startIndex:endIndex));hold on;ylabel('e- Flux [2.0 MeV]');grid minor
        set(gca, 'XTick',[length(E_flux_data_20)/15 length(E_flux_data_20)*2/15 length(E_flux_data_20)*3/15 length(E_flux_data_20)*4/15 length(E_flux_data_20)*5/15 length(E_flux_data_20)*6/15 length(E_flux_data_20)*7/15 length(E_flux_data_20)*8/15 length(E_flux_data_20)*9/15 length(E_flux_data_20)*10/15 length(E_flux_data_20)*11/15 length(E_flux_data_20)*12/15 length(E_flux_data_20)*13/15 length(E_flux_data_20)*14/15 length(E_flux_data_20)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,3)
        plot(plotRange,E_flux_data_08(startIndex:endIndex));hold on;ylabel('e- Flux');grid minor
        plot(plotRange,E_flux_data_20(startIndex:endIndex));hold on;
        legend({'[0.8 MeV]','[2.0 MeV]'},'FontSize',8,'FontWeight','bold','Location','northwest');
        legend boxoff
        set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
        set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
    end
    
    
    %% KP
    if data_download == 1
        KPTime = datenum(eventTimes{ii}, 'yyyy-mm-dd HH:MM:SS');
        KPRelative = ([7, 3, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
    
        BeforeTime = KPTime - KPRelative;
        AfterTime = KPTime + KPRelative;
    
        KPstartTime = datestr(BeforeTime, 'yyyy-mm-dd HH:MM:SS');
        KPendTime = datestr(AfterTime, 'yyyy-mm-dd HH:MM:SS');
        
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=KP&resource=NOAA-KP&resourceInstance=NOAA-KP&end-time=%s&begin-time=%s'],KPendTime,KPstartTime);
        filename = sprintf('KP_index_%s.txt',eventTimes{ii}(1:10));
        outfilename = websave(filename,url);
    end
    
    KP_data = importdata(sprintf('KP_index_%s.txt',eventTimes{ii}(1:10)),' ',1);
    
    Timestamp = [strcat(KP_data.textdata(2:end,1),{' '},KP_data.textdata(2:end,2))];
    KPindex_data = KP_data.data(:,1);
    
    Timestampnum = datenum(Timestamp);
    [c startIndex] = min(abs(Timestampnum-datenum(startTime{ii})));
    [c endIndex] = min(abs(Timestampnum-datenum(endTime{ii})));
    
    dt = length(startIndex:endIndex);
    %     plotRange = linspace(0,1,dt);
    plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);

    if all == 1
        subplot(6,1,5)
        plot(startIndex:endIndex,KPindex_data(startIndex:endIndex));hold on;ylabel('KP Index');grid minor
        KP = KPindex_data;
        set(gca, 'XTick',[length(KP)/15 length(KP)*2/15 length(KP)*3/15 length(KP)*4/15 length(KP)*5/15 length(KP)*6/15 length(KP)*7/15 length(KP)*8/15 length(KP)*9/15 length(KP)*10/15 length(KP)*11/15 length(KP)*12/15 length(KP)*13/15 length(KP)*14/15 length(KP)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,4)
        plot(plotRange,KPindex_data(startIndex:endIndex));hold on;ylabel('KP Index');grid minor
        set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
        set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
    end
    
    
    %% GOES13 Total B
    if data_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=Hp,He,Hn,TotalField&resource=GOES-13,GOES-13,GOES-13,GOES-13&resourceInstance=GOES-13,GOES-13,GOES-13,GOES-13&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
        filename = sprintf('observed_mag_%s.txt',eventTimes{ii}(1:10));
        outfilename = websave(filename,url);
    end
    
    TotalB_data = importdata(sprintf('observed_mag_%s.txt',eventTimes{ii}(1:10)),' ',1);
    
    Timestamp = [strcat(TotalB_data.textdata(2:end,1),{' '},TotalB_data.textdata(2:end,2))];
    Hp = TotalB_data.data(:,1);He = TotalB_data.data(:,2);Hn = TotalB_data.data(:,3);TotalField = TotalB_data.data(:,4);
    TotalB_data = TotalB_data.data;
    
    errorIndex = find(TotalField == -100000);
    TotalField(errorIndex) = NaN;
    errorIndex = find(TotalField > 500);
    TotalField(errorIndex) = NaN;
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    t = datenum(Timestamp);
    dt = length(startIndex:endIndex);
    %     plotRange = linspace(0,1,dt);
    plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);

    if all == 1
        subplot(6,1,6)
        plot(startIndex:endIndex,TotalField(startIndex:endIndex));hold on;ylabel('Obs. B [nT]');grid minor
        set(gca, 'XTick',[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,5)
        plot(plotRange,TotalField(startIndex:endIndex));hold on;ylabel('Obs. B [nT]');xlabel('Time [dd- HH:MM]');grid minor
        set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
        set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
        
        saveFigure(gcf, sprintf('%s.png',eventTimes{ii}(1:10)));
%         print('-depsc2', 'test.eps')
%         print(gcf, '-dpdf', sprintf('%s.pdf',eventTimes{ii}(1:10)));
    end
end

if all == 1
%     set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 30 20])
%     print('-depsc2', 'test.eps')
%     print(gcf, '-dpdf','all_events.pdf');
    saveFigure(gcf,'all_events.png');
end
