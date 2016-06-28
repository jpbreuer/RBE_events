clear all;close all;

all = 0; % 0 individual event plots
data_download = 1; % 1 downloads text files per event

old_eventTimes = importdata('RBE_times.txt',' ');
old_eventTime = datenum(old_eventTimes, 'yyyy-mm-dd HH:MM:SS');
RelativeTime = ([7, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;

old_BeforeTime = old_eventTime - RelativeTime;
old_AfterTime = old_eventTime + RelativeTime;
old_startTime = cellstr(datestr(old_BeforeTime, 'yyyy-mm-dd HH:MM:SS'));
old_endTime = cellstr(datestr(old_AfterTime, 'yyyy-mm-dd HH:MM:SS'));
    
BeforeTime = []; AfterTime = []; eventTime = [];
for ii = 1:length(old_startTime)
%     if data_download == 1
%         api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
%         url = sprintf([api '?format=text&quantity=E_8,E2_0&resource=GOES-13,GOES-13&resourceInstance=GOES-13,GOES-13&end-time=%s&begin-time=%s'],old_endTime{ii},old_startTime{ii});
%         filename = sprintf('GOES_e-_flux_%s_tmp.txt',old_eventTimes{ii}(1:10));
%         outfilename = websave(filename,url);
%     end
    
    E_flux_data = importdata(sprintf('GOES_e-_flux_%s_tmp.txt',old_eventTimes{ii}(1:10)),' ',1);
    
    Timestamp = [strcat(E_flux_data.textdata(2:end,1),{' '},E_flux_data.textdata(2:end,2))];
    E_flux_data_08 = E_flux_data.data(:,1);
    E_flux_data_20 = E_flux_data.data(:,2);
    
    errorIndex = find(E_flux_data_08 == -100000);
    E_flux_data_08(errorIndex) = NaN;
    errorIndex = find(E_flux_data_20 == -100000);
    E_flux_data_20(errorIndex) = NaN;
    
    pfu_correction = find(E_flux_data_08 >= 10^5);
    if isempty(pfu_correction) == 1
        pfu_correction = find(max(E_flux_data_08));
    end
    eventTime = [eventTime; datenum(Timestamp(pfu_correction(1)))];
    
    BeforeTime = [BeforeTime;eventTime - RelativeTime];
    AfterTime = [AfterTime;eventTime + RelativeTime];
end
eventTimes = cellstr(datestr(eventTime));

startTime = cellstr(datestr(BeforeTime, 'yyyy-mm-dd HH:MM:SS'));
endTime = cellstr(datestr(AfterTime, 'yyyy-mm-dd HH:MM:SS'));

%%
for ii = 1%:length(old_startTime)  
    %% IMF Bz
    if data_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=B_z&resource=ACE&resourceInstance=ACE&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
        filename = sprintf('IMF_Bz_%s.txt',eventTimes{ii}(1:11));
        outfilename = websave(filename,url);
    end
    
    IMF_Bz_data = importdata(sprintf('IMF_Bz_%s.txt',eventTimes{ii}(1:11)),' ',1);
    
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
    
    Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
    t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
    
    if all == 1
        figure(1)
        subplot(6,1,1)
        plot(plotRange,Bz);hold on;ylabel('IMF Bz [nT]');grid on
        title('RBE Events [+/- 7 days]');
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,1)
        plot(plotRange,Bz);hold on;ylabel('IMF Bz [nT]');grid on
        title(sprintf('RBE Event Time: %s [+/- 7 days]',datestr(eventTime(ii))));
%         set(gca, 'XTick',[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
%         set(gca, 'xtick',plotRange(1:length(plotRange)/15:end));
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
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
        plot(plotRange,BulkSpeed);hold on;ylabel('SW Vel. [km/s]');grid on
%         set(gca, 'XTick',[length(BulkSpeed)/15 length(BulkSpeed)*2/15 length(BulkSpeed)*3/15 length(BulkSpeed)*4/15 length(BulkSpeed)*5/15 length(BulkSpeed)*6/15 length(BulkSpeed)*7/15 length(BulkSpeed)*8/15 length(BulkSpeed)*9/15 length(BulkSpeed)*10/15 length(BulkSpeed)*11/15 length(BulkSpeed)*12/15 length(BulkSpeed)*13/15 length(BulkSpeed)*14/15 length(BulkSpeed)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,2)
        plot(plotRange,BulkSpeed);hold on;ylabel('SW Vel. [km/s]');grid on
%         set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
%         set(gca, 'XTick',[length(BulkSpeed)/15 length(BulkSpeed)*2/15 length(BulkSpeed)*3/15 length(BulkSpeed)*4/15 length(BulkSpeed)*5/15 length(BulkSpeed)*6/15 length(BulkSpeed)*7/15 length(BulkSpeed)*8/15 length(BulkSpeed)*9/15 length(BulkSpeed)*10/15 length(BulkSpeed)*11/15 length(BulkSpeed)*12/15 length(BulkSpeed)*13/15 length(BulkSpeed)*14/15 length(BulkSpeed)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
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
        plot(plotRange,log(E_flux_data_08));hold on;ylabel('log(e- Flux) [0.8 MeV]');grid on
%         set(gca, 'XTick',[length(E_flux_data_08)/15 length(E_flux_data_08)*2/15 length(E_flux_data_08)*3/15 length(E_flux_data_08)*4/15 length(E_flux_data_08)*5/15 length(E_flux_data_08)*6/15 length(E_flux_data_08)*7/15 length(E_flux_data_08)*8/15 length(E_flux_data_08)*9/15 length(E_flux_data_08)*10/15 length(E_flux_data_08)*11/15 length(E_flux_data_08)*12/15 length(E_flux_data_08)*13/15 length(E_flux_data_08)*14/15 length(E_flux_data_08)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        subplot(6,1,4) % startIndex:endIndex instead of plotRange; E_flux_data_20(startIndex:endIndex)
        plot(plotRange,log(E_flux_data_20));hold on;ylabel('log(e- Flux) [2.0 MeV]');grid on
%         set(gca, 'XTick',[length(E_flux_data_20)/15 length(E_flux_data_20)*2/15 length(E_flux_data_20)*3/15 length(E_flux_data_20)*4/15 length(E_flux_data_20)*5/15 length(E_flux_data_20)*6/15 length(E_flux_data_20)*7/15 length(E_flux_data_20)*8/15 length(E_flux_data_20)*9/15 length(E_flux_data_20)*10/15 length(E_flux_data_20)*11/15 length(E_flux_data_20)*12/15 length(E_flux_data_20)*13/15 length(E_flux_data_20)*14/15 length(E_flux_data_20)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,3)
        plot(plotRange,log(E_flux_data_08));hold on;ylabel('log(e- Flux)');grid on
        plot(plotRange,log(E_flux_data_20));hold on;
        legend({'[0.8 MeV]','[2.0 MeV]'},'FontSize',8,'FontWeight','bold','Location','northwest');
        legend boxoff
%         set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
%         set(gca, 'XTick',[length(E_flux_data_08)/15 length(E_flux_data_08)*2/15 length(E_flux_data_08)*3/15 length(E_flux_data_08)*4/15 length(E_flux_data_08)*5/15 length(E_flux_data_08)*6/15 length(E_flux_data_08)*7/15 length(E_flux_data_08)*8/15 length(E_flux_data_08)*9/15 length(E_flux_data_08)*10/15 length(E_flux_data_08)*11/15 length(E_flux_data_08)*12/15 length(E_flux_data_08)*13/15 length(E_flux_data_08)*14/15 length(E_flux_data_08)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    %% KP
    if data_download == 1
        KPTime = datenum(old_eventTimes{ii}, 'yyyy-mm-dd HH:MM:SS');
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
        plot(plotRange,KPindex_data);hold on;ylabel('KP Index');grid on
        KP = KPindex_data;
%         set(gca, 'XTick',[length(KP)/15 length(KP)*2/15 length(KP)*3/15 length(KP)*4/15 length(KP)*5/15 length(KP)*6/15 length(KP)*7/15 length(KP)*8/15 length(KP)*9/15 length(KP)*10/15 length(KP)*11/15 length(KP)*12/15 length(KP)*13/15 length(KP)*14/15 length(KP)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,4)
        plot(plotRange,KPindex_data);hold on;ylabel('KP Index');grid on
%         set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
        KP = KPindex_data;
%         set(gca, 'XTick',[length(KP)/15 length(KP)*2/15 length(KP)*3/15 length(KP)*4/15 length(KP)*5/15 length(KP)*6/15 length(KP)*7/15 length(KP)*8/15 length(KP)*9/15 length(KP)*10/15 length(KP)*11/15 length(KP)*12/15 length(KP)*13/15 length(KP)*14/15 length(KP)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
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
        plot(plotRange,TotalField);hold on;ylabel('Obs. B [nT]');grid on
%         set(gca, 'XTick',[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    elseif all == 0
        figure(ii)
        subplot(5,1,5)
        plot(plotRange,TotalField);hold on;ylabel('Obs. B [nT]');xlabel('Time [Days]');grid on
%         set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
%         set(gca, 'XTick',[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        saveFigure(gcf, sprintf('%s.png',old_eventTimes{ii}(1:10)));
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
