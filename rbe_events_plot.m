clear all;close all;

all = 0; % 0 for individual event plots
summary = 0; % 1 for averaged data and only when all = 1
% NEVER have all = 0 summary = 1

full_download = 0; % run to do initial time correction for 10^5 Eflux
data_download = 0; % 1 downloads text files per event (much faster if local, no timeout)

old_eventTimes = importdata('RBE_times.txt',' ');
old_eventTime = datenum(old_eventTimes, 'yyyy-mm-dd HH:MM:SS');
RelativeTime = ([7, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;

old_BeforeTime = old_eventTime - RelativeTime;
old_AfterTime = old_eventTime + RelativeTime;
old_startTime = cellstr(datestr(old_BeforeTime, 'yyyy-mm-dd HH:MM:SS'));
old_endTime = cellstr(datestr(old_AfterTime, 'yyyy-mm-dd HH:MM:SS'));
    
eventTime = [];
for ii = 1:length(old_startTime)
    if full_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=E_8,E2_0&resource=GOES-13,GOES-13&resourceInstance=GOES-13,GOES-13&end-time=%s&begin-time=%s'],old_endTime{ii},old_startTime{ii});
        filename = sprintf('./data_files/GOES_e-_flux_%s_tmp.txt',old_eventTimes{ii}(1:11));
        outfilename = websave(filename,url);
    end
    
    E_flux_data = importdata(sprintf('./data_files/GOES_e-_flux_%s_tmp.txt',old_eventTimes{ii}(1:11)),' ',1);
    
    Timestamp = [strcat(E_flux_data.textdata(2:end,1),{' '},E_flux_data.textdata(2:end,2))];
    E_flux_data_08 = E_flux_data.data(:,1);
    E_flux_data_20 = E_flux_data.data(:,2);
    
    errorIndex = find(E_flux_data_08 == -100000);
    E_flux_data_08(errorIndex) = NaN;
    errorIndex = find(E_flux_data_20 == -100000);
    E_flux_data_20(errorIndex) = NaN;
    
    pfu_correction = find(E_flux_data_08 >= 10^5);
    if isempty(pfu_correction) == 1
        [value pfu_correction] = max(E_flux_data_08);
        eventTime = [eventTime; datenum(Timestamp(pfu_correction))];
    else
        eventTime = [eventTime; datenum(Timestamp(pfu_correction(1)))];
    end
    
    BeforeTime = eventTime - RelativeTime;
    AfterTime = eventTime + RelativeTime;
end
eventTimes = cellstr(datestr(eventTime));

startTime = cellstr(datestr(BeforeTime, 'yyyy-mm-dd HH:MM:SS'));
endTime = cellstr(datestr(AfterTime, 'yyyy-mm-dd HH:MM:SS'));

%%
for ii = 1:length(old_startTime)  
    %% IMF Bz
    if data_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=B_z&resource=ACE&resourceInstance=ACE&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
        filename = sprintf('./data_files/IMF_Bz_%s.txt',eventTimes{ii}(1:11));
        outfilename = websave(filename,url);
    end
    
    if summary == 0
        IMF_Bz_data = importdata(sprintf('./data_files/IMF_Bz_%s.txt',eventTimes{ii}(1:11)),' ',1);
        
        Timestamp = [strcat(IMF_Bz_data.textdata(2:end,1),{' '},IMF_Bz_data.textdata(2:end,2))];
        Bz = IMF_Bz_data.data(:,1);
        
        errorIndex = find(Bz == -999.9);
        Bz(errorIndex) = NaN;
        
        startIndex = strfind(Timestamp,startTime{ii});
        endIndex = strfind(Timestamp,endTime{ii});
        startIndex = find(not(cellfun('isempty', startIndex)));
        endIndex = find(not(cellfun('isempty', endIndex)));
        
        Timestampnum = datenum(Timestamp);
        %     dt = length(startIndex:endIndex);
        %     plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),length(Bz));
        
        Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
        %     t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
    end
    
    if all == 1 && summary == 0
        daydex = round(median(1:length(Bz))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Bz)];
        
        figure(1)
        subplot(7,1,1);
        plot(startIndex:endIndex,Bz(startIndex:endIndex));hold on;ylim([-30 30]);ylabel('IMF Bz [nT]');grid minor
        title('RBE Events [+/- 7 days]');
        set(gca, 'XTick',xaxis);%[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        %         set(h, 'XTick',t);
        %         set(h, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if summary == 1 && ii == 1
        Bz_summary = []; jump = 0;
        for jj = 1:length(eventTimes)
            Bz_data = importdata(sprintf('./data_files/IMF_Bz_%s.txt',eventTimes{jj}(1:11)),' ',1);
            Timestamp = [strcat(Bz_data.textdata(2:end,1),{' '},Bz_data.textdata(2:end,2))];
            if length(Bz_data.data(:,1)) ~= 20161
                jump = jump + 1;
                continue
            end
            Bz_summary = [Bz_summary; Bz_data.data(:,1)];
        end
    
        errorIndex = find(Bz_summary == -999.9);
        Bz_summary(errorIndex) = NaN;
        
        Bzmatrix = reshape(Bz_summary,[],length(eventTimes)-jump);
        Bz_avg = nanmean(Bzmatrix,2);
        
        Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        %             startIndexKP = 1; endIndexKP = 114;
        
        daydex = round(median(1:length(Bz_avg))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Bz_avg)];
        
        subplot(7,1,1)
        plot(1:length(Bz_avg),Bz_avg);hold on;ylim([-10 10]);ylabel('IMF Bz [nT]');grid minor
        title('RBE Events Averaged [+/- 7 days]');
        set(gca, 'XTick',xaxis);%[length(Bz_avg)/15 length(Bz_avg)*2/15 length(Bz_avg)*3/15 length(Bz_avg)*4/15 length(Bz_avg)*5/15 length(Bz_avg)*6/15 length(Bz_avg)*7/15 length(Bz_avg)*8/15 length(Bz_avg)*9/15 length(Bz_avg)*10/15 length(Bz_avg)*11/15 length(Bz_avg)*12/15 length(Bz_avg)*13/15 length(Bz_avg)*14/15 length(Bz_avg)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if all == 0
        figure(ii)
        h = subplot(6,1,1);
        plot(Timestampnum,Bz);hold on;ylabel(h, 'IMF Bz [nT]');grid minor
        title(h, sprintf('RBE Event Time: %s [+/- 7 days]',datestr(eventTime(ii))));
%         set(gca, 'XTick',[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
%         set(gca, 'xtick',plotRange(1:length(plotRange)/15:end));
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
%         xlabel(h, {'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'},t);
        set(h, 'XTick',t);
        set(h, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});

%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
    end
    %% Solar Wind BulkSpeed
    if data_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=BulkSpeed&resource=ACE&resourceInstance=ACE&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
        filename = sprintf('./data_files/SW_BulkSpeed_%s.txt',eventTimes{ii}(1:11));
        outfilename = websave(filename,url);
    end
    
    if summary == 0
        BulkSpeed_data = importdata(sprintf('./data_files/SW_BulkSpeed_%s.txt',eventTimes{ii}(1:11)),' ',1);
        
        Timestamp = [strcat(BulkSpeed_data.textdata(2:end,1),{' '},BulkSpeed_data.textdata(2:end,2))];
        BulkSpeed = BulkSpeed_data.data(:,1);
        
        errorIndex = find(BulkSpeed == -9999.9);
        BulkSpeed(errorIndex) = NaN;
        
        Timestampnum = datenum(Timestamp);
        %     dt = length(startIndex:endIndex);
        %     plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);
        
        Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
        %     t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
        
        startIndex = strfind(Timestamp,startTime{ii});
        endIndex = strfind(Timestamp,endTime{ii});
        startIndex = find(not(cellfun('isempty', startIndex)));
        endIndex = find(not(cellfun('isempty', endIndex)));
    end
    if all == 1 && summary == 0
        
        daydex = round(median(1:length(BulkSpeed))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(BulkSpeed)];

        subplot(7,1,2)
        plot(startIndex:endIndex,BulkSpeed(startIndex:endIndex));hold on;ylim([200 1100]);ylabel('SW Vel. [km/s]');grid minor
        set(gca, 'XTick',xaxis);%[length(BulkSpeed)/15 length(BulkSpeed)*2/15 length(BulkSpeed)*3/15 length(BulkSpeed)*4/15 length(BulkSpeed)*5/15 length(BulkSpeed)*6/15 length(BulkSpeed)*7/15 length(BulkSpeed)*8/15 length(BulkSpeed)*9/15 length(BulkSpeed)*10/15 length(BulkSpeed)*11/15 length(BulkSpeed)*12/15 length(BulkSpeed)*13/15 length(BulkSpeed)*14/15 length(BulkSpeed)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
%         set(gca, 'XTick',t);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if summary == 1 && ii == 1
        BulkSpeed_summary = [];jump = 0;
        for jj = 1:length(eventTimes)
            BulkSpeed_data = importdata(sprintf('./data_files/SW_BulkSpeed_%s.txt',eventTimes{jj}(1:11)),' ',1);
            Timestamp = [strcat(BulkSpeed_data.textdata(2:end,1),{' '},BulkSpeed_data.textdata(2:end,2))];
            if length(BulkSpeed_data.data(:,1)) ~= 20161
                jump = jump + 1;
                continue
            end
            BulkSpeed_summary = [BulkSpeed_summary; BulkSpeed_data.data(:,1)];
        end
        
        errorIndex = find(BulkSpeed_summary == -9999.9);
        BulkSpeed_summary(errorIndex) = NaN;
        
        BulkSpeedmatrix = reshape(BulkSpeed_summary,[],length(eventTimes)-jump);
        BulkSpeed_avg = nanmean(BulkSpeedmatrix,2);
        
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        %             startIndexKP = 1; endIndexKP = 114;
        
        daydex = round(median(1:length(BulkSpeed_avg))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(BulkSpeed_avg)];
        
        subplot(7,1,2)
        plot(1:length(BulkSpeed_avg),BulkSpeed_avg);hold on;ylim([200 750]);ylabel('SW Vel. [km/s]');grid minor
        set(gca, 'XTick',xaxis);%[length(BulkSpeed)/15 length(BulkSpeed)*2/15 length(BulkSpeed)*3/15 length(BulkSpeed)*4/15 length(BulkSpeed)*5/15 length(BulkSpeed)*6/15 length(BulkSpeed)*7/15 length(BulkSpeed)*8/15 length(BulkSpeed)*9/15 length(BulkSpeed)*10/15 length(BulkSpeed)*11/15 length(BulkSpeed)*12/15 length(BulkSpeed)*13/15 length(BulkSpeed)*14/15 length(BulkSpeed)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if all == 0
        figure(ii)
        subplot(6,1,2)
        plot(Timestampnum,BulkSpeed);hold on;ylabel('SW Vel. [km/s]');grid minor
%         set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
%         set(gca, 'XTick',[length(BulkSpeed)/15 length(BulkSpeed)*2/15 length(BulkSpeed)*3/15 length(BulkSpeed)*4/15 length(BulkSpeed)*5/15 length(BulkSpeed)*6/15 length(BulkSpeed)*7/15 length(BulkSpeed)*8/15 length(BulkSpeed)*9/15 length(BulkSpeed)*10/15 length(BulkSpeed)*11/15 length(BulkSpeed)*12/15 length(BulkSpeed)*13/15 length(BulkSpeed)*14/15 length(BulkSpeed)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    %% Dynamic Pressure
    if data_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=ProtonDensity&resource=ACE&resourceInstance=ACE&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
        filename = sprintf('./data_files/ACE_protonD_%s.txt',eventTimes{ii}(1:11));
        outfilename = websave(filename,url);
    end
    
    if summary == 0
        ACE_protonData = importdata(sprintf('./data_files/ACE_protonD_%s.txt',eventTimes{ii}(1:11)),' ',1);
        Timestamp = [strcat(ACE_protonData.textdata(2:end,1),{' '},ACE_protonData.textdata(2:end,2))];
        ACE_protonD = ACE_protonData.data(:,1);
        
        errorIndex = find(ACE_protonD == -9999.9);
        ACE_protonD(errorIndex) = NaN;
        
        M_proton = 1.6726219*10^-27;
        Pdyn = (0.5 .* (ACE_protonD.*10^6) .* M_proton .* ((BulkSpeed.*1000).^2)).*10^9;
        
        Timestampnum = datenum(Timestamp);
        
        Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
        %     t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
        
        startIndex = strfind(Timestamp,startTime{ii});
        endIndex = strfind(Timestamp,endTime{ii});
        startIndex = find(not(cellfun('isempty', startIndex)));
        endIndex = find(not(cellfun('isempty', endIndex)));
    end
    
    if all == 1 && summary == 0
        daydex = round(median(1:length(Pdyn))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Pdyn)];
        
        subplot(7,1,3)
        plot(startIndex:endIndex,Pdyn(startIndex:endIndex));hold on;ylim([0 15]);ylabel('Dynamic Pressure [nPa]');grid minor
        set(gca, 'XTick',xaxis);%[length(Pdyn)/15 length(Pdyn)*2/15 length(Pdyn)*3/15 length(Pdyn)*4/15 length(Pdyn)*5/15 length(Pdyn)*6/15 length(Pdyn)*7/15 length(Pdyn)*8/15 length(Pdyn)*9/15 length(Pdyn)*10/15 length(Pdyn)*11/15 length(Pdyn)*12/15 length(Pdyn)*13/15 length(Pdyn)*14/15 length(Pdyn)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
%         set(gca, 'XTick',t);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if summary == 1 && ii == 1
        ACE_summary = [];jump = 0;
        for jj = 1:length(eventTimes)
            ACE_protonData = importdata(sprintf('./data_files/ACE_protonD_%s.txt',eventTimes{jj}(1:11)),' ',1);
            Timestamp = [strcat(ACE_protonData.textdata(2:end,1),{' '},ACE_protonData.textdata(2:end,2))];
            if length(ACE_protonData.data(:,1)) ~= 20161
                jump = jump + 1;
                continue
            end
            ACE_summary = [ACE_summary; ACE_protonData.data(:,1)];
        end
        
        errorIndex = find(ACE_summary == -9999.9);
        ACE_summary(errorIndex) = NaN;
        
        ACEmatrix = reshape(ACE_summary,[],length(eventTimes)-jump);
        ACE_avg = nanmean(ACEmatrix,2);
        
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        %             startIndexKP = 1; endIndexKP = 114;
        
        M_proton = 1.6726219*10^-27;
        Pdyn = (0.5 .* (ACE_avg.*10^6) .* M_proton .* ((BulkSpeed_avg.*1000).^2)).*10^9;
        
        daydex = round(median(1:length(Pdyn))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Pdyn)];
        
        subplot(7,1,3)
        plot(1:length(Pdyn),Pdyn);hold on;ylim([0 5]);ylabel('Dyn. Pressure [nPa]');grid minor
        set(gca, 'XTick',xaxis);%[length(Pdyn)/15 length(Pdyn)*2/15 length(Pdyn)*3/15 length(Pdyn)*4/15 length(Pdyn)*5/15 length(Pdyn)*6/15 length(Pdyn)*7/15 length(Pdyn)*8/15 length(Pdyn)*9/15 length(Pdyn)*10/15 length(Pdyn)*11/15 length(Pdyn)*12/15 length(Pdyn)*13/15 length(Pdyn)*14/15 length(Pdyn)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if all == 0
        figure(ii)
        subplot(6,1,3)
        plot(Timestampnum,Pdyn);hold on;ylabel('Dynamic Pressure [nPa]');grid minor
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
        filename = sprintf('./data_files/GOES_e-_flux_%s.txt',eventTimes{ii}(1:11));
        outfilename = websave(filename,url);
    end
    
    if summary == 0
        E_flux_data = importdata(sprintf('./data_files/GOES_e-_flux_%s.txt',eventTimes{ii}(1:11)),' ',1);
        
        Timestamp = [strcat(E_flux_data.textdata(2:end,1),{' '},E_flux_data.textdata(2:end,2))];
        E_flux_data_08 = E_flux_data.data(:,1);
        E_flux_data_20 = E_flux_data.data(:,2);
        
        errorIndex = find(E_flux_data_08 == -100000);
        E_flux_data_08(errorIndex) = NaN;
        
        errorIndex = find(E_flux_data_20 == -100000);
        E_flux_data_20(errorIndex) = NaN;
        
        TimestampnumGOES = datenum(Timestamp);
        %     dt = length(startIndex:endIndex);
        %     plotRange = linspace(0,1,dt);
        %     plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);
        
        Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
        %     t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        %     t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
        t = [median(TimestampnumGOES)-(7*Day) median(TimestampnumGOES)-(6*Day) median(TimestampnumGOES)-(5*Day) median(TimestampnumGOES)-(4*Day) median(TimestampnumGOES)-(3*Day) median(TimestampnumGOES)-(2*Day) median(TimestampnumGOES)-(Day) median(TimestampnumGOES) median(TimestampnumGOES)+(Day) median(TimestampnumGOES)+(2*Day) median(TimestampnumGOES)+(3*Day) median(TimestampnumGOES)+(4*Day) median(TimestampnumGOES)+(5*Day) median(TimestampnumGOES)+(6*Day) median(TimestampnumGOES)+(7*Day)];
        
        startIndex = strfind(Timestamp,startTime{ii});
        endIndex = strfind(Timestamp,endTime{ii});
        startIndex = find(not(cellfun('isempty', startIndex)));
        endIndex = find(not(cellfun('isempty', endIndex)));
    end

    if all == 1 && summary == 0
%         [tf, loc] = ismember(TimestampnumGOES, Timestampnum);
%         GOES_t_all = nan(size(Timestampnum));
%         GOES_all_08 = GOES_t_all;
%         GOES_all_20 = GOES_t_all;
% %         GOES_t_all(loc) = TimestampnumGOES;
%         GOES_all_08(loc) = E_flux_data_08;
%         GOES_all_20(loc) = E_flux_data_20;
%         
%         GOES_t_all = GOES_t_all(~isnan(GOES_t_all));
%         GOES_all_08 = GOES_all_08(~isnan(GOES_all_08));
%         GOES_all_20 = GOES_all_20(~isnan(GOES_all_20));
        
        daydex = round(median(1:length(E_flux_data_08))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(E_flux_data_08)];

        subplot(7,1,4)%startIndex:endIndex
        plot(startIndex:endIndex,log10(E_flux_data_08));hold on;ylim([-2 6]);ylabel('log(e- Flux) [0.8 MeV]');grid minor
        hline = refline([0 5]);
        set(hline,'LineStyle','--')
        set(gca, 'XTick',xaxis);%[length(E_flux_data_08)/15 length(E_flux_data_08)*2/15 length(E_flux_data_08)*3/15 length(E_flux_data_08)*4/15 length(E_flux_data_08)*5/15 length(E_flux_data_08)*6/15 length(E_flux_data_08)*7/15 length(E_flux_data_08)*8/15 length(E_flux_data_08)*9/15 length(E_flux_data_08)*10/15 length(E_flux_data_08)*11/15 length(E_flux_data_08)*12/15 length(E_flux_data_08)*13/15 length(E_flux_data_08)*14/15 length(E_flux_data_08)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
%         set(gca, 'XTick',t);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        subplot(7,1,5) % startIndex:endIndex instead of plotRange; E_flux_data_20(startIndex:endIndex)
        plot(startIndex:endIndex,log10(E_flux_data_20));hold on;ylim([-2 6]);ylabel('log(e- Flux) [2.0 MeV]');grid minor
        hline = refline([0 5]);
        set(hline,'LineStyle','--')
        set(gca, 'XTick',xaxis);%[length(E_flux_data_20)/15 length(E_flux_data_20)*2/15 length(E_flux_data_20)*3/15 length(E_flux_data_20)*4/15 length(E_flux_data_20)*5/15 length(E_flux_data_20)*6/15 length(E_flux_data_20)*7/15 length(E_flux_data_20)*8/15 length(E_flux_data_20)*9/15 length(E_flux_data_20)*10/15 length(E_flux_data_20)*11/15 length(E_flux_data_20)*12/15 length(E_flux_data_20)*13/15 length(E_flux_data_20)*14/15 length(E_flux_data_20)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
%         set(gca, 'XTick',t);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if summary == 1 && ii == 1
        E_flux_data_08_summary = []; E_flux_data_20_summary = [];jump = 0;
        for jj = 1:length(eventTimes)
            E_flux_data = importdata(sprintf('./data_files/GOES_e-_flux_%s.txt',eventTimes{jj}(1:11)),' ',1);
            Timestamp = [strcat(E_flux_data.textdata(2:end,1),{' '},E_flux_data.textdata(2:end,2))];
            if length(E_flux_data.data(:,1)) ~= 4031
                jump = jump + 1;
                continue
            end
            E_flux_data_08_summary = [E_flux_data_08_summary; E_flux_data.data(:,1)];
            E_flux_data_20_summary = [E_flux_data_20_summary; E_flux_data.data(:,2)];
        end
        
        errorIndex = find(E_flux_data_08_summary == -100000);
        E_flux_data_08_summary(errorIndex) = NaN;
        
        errorIndex = find(E_flux_data_20_summary == -100000);
        E_flux_data_20_summary(errorIndex) = NaN;
        
        Flux08matrix = reshape(E_flux_data_08_summary,[],length(eventTimes)-jump);
        Flux08_avg = nanmean(log10(Flux08matrix),2);
        
        Flux20matrix = reshape(E_flux_data_20_summary,[],length(eventTimes)-jump);
        Flux20_avg = nanmean(log10(Flux20matrix),2);
        
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        %             startIndexKP = 1; endIndexKP = 114;
        
        daydex = round(median(1:length(Flux08_avg))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Flux08_avg)];
        
        subplot(7,1,4)
        plot(1:length(Flux08_avg),Flux08_avg);hold on;ylim([-2 6]);ylabel('log(e- Flux) [0.8 MeV]');grid minor
        hline = refline([0 5]);
        set(hline,'LineStyle','--')
%         set(gca, 'XTick',[length(Flux08_avg)/15 length(Flux08_avg)*2/15 length(Flux08_avg)*3/15 length(Flux08_avg)*4/15 length(Flux08_avg)*5/15 length(Flux08_avg)*6/15 length(Flux08_avg)*7/15 length(Flux08_avg)*8/15 length(Flux08_avg)*9/15 length(Flux08_avg)*10/15 length(Flux08_avg)*11/15 length(Flux08_avg)*12/15 length(Flux08_avg)*13/15 length(Flux08_avg)*14/15 length(Flux08_avg)*15/15]);
        set(gca, 'XTick',xaxis);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        subplot(7,1,5)
        plot(1:length(Flux20_avg),Flux20_avg);hold on;ylim([-2 6]);ylabel('log(e- Flux) [2.0 MeV]');grid minor
        hline = refline([0 5]);
        set(hline,'LineStyle','--')
%         set(gca, 'XTick',[length(Flux20_avg)/15 length(Flux20_avg)*2/15 length(Flux20_avg)*3/15 length(Flux20_avg)*4/15 length(Flux20_avg)*5/15 length(Flux20_avg)*6/15 length(Flux20_avg)*7/15 length(Flux20_avg)*8/15 length(Flux20_avg)*9/15 length(Flux20_avg)*10/15 length(Flux20_avg)*11/15 length(Flux20_avg)*12/15 length(Flux20_avg)*13/15 length(Flux20_avg)*14/15 length(Flux20_avg)*15/15]);
%         set(gca, 'XTick',[1 288 576 864 1152 1440 1728 2016 2304 2592 2880 3168 3456 3744 4031]);
        set(gca, 'XTick',xaxis);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if all == 0
        figure(ii)
        subplot(6,1,4)
        plot(TimestampnumGOES,log10(E_flux_data_08));hold on;ylim([-2 6]);ylabel('log(e- Flux)');grid minor
        hline = refline([0 5]);
        set(hline,'LineStyle','--')
        plot(TimestampnumGOES,log10(E_flux_data_20));hold on;
        legend({'[0.8 MeV]','[2.0 MeV]'},'FontSize',8,'FontWeight','bold','Location','northwest');
        legend boxoff
%         set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
%         set(gca, 'XTick',[length(E_flux_data_08)/15 length(E_flux_data_08)*2/15 length(E_flux_data_08)*3/15 length(E_flux_data_08)*4/15 length(E_flux_data_08)*5/15 length(E_flux_data_08)*6/15 length(E_flux_data_08)*7/15 length(E_flux_data_08)*8/15 length(E_flux_data_08)*9/15 length(E_flux_data_08)*10/15 length(E_flux_data_08)*11/15 length(E_flux_data_08)*12/15 length(E_flux_data_08)*13/15 length(E_flux_data_08)*14/15 length(E_flux_data_08)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    
    
    %% GOES13 Total B
    if data_download == 1
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=Hp,He,Hn,TotalField&resource=GOES-13,GOES-13,GOES-13,GOES-13&resourceInstance=GOES-13,GOES-13,GOES-13,GOES-13&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
        filename = sprintf('./data_files/observed_mag_%s.txt',eventTimes{ii}(1:11));
        outfilename = websave(filename,url);
    end
    
    if summary == 0
        TotalB_data = importdata(sprintf('./data_files/observed_mag_%s.txt',eventTimes{ii}(1:11)),' ',1);
        
        Timestamp = [strcat(TotalB_data.textdata(2:end,1),{' '},TotalB_data.textdata(2:end,2))];
        Hp = TotalB_data.data(:,1);He = TotalB_data.data(:,2);Hn = TotalB_data.data(:,3);TotalField = TotalB_data.data(:,4);
        TotalB_data = TotalB_data.data;
        
        errorIndex = find(TotalField == -100000);
        TotalField(errorIndex) = NaN;
        errorIndex = find(TotalField > 250);
        TotalField(errorIndex) = NaN;
        
        Timestampnum = datenum(Timestamp);
        
        startIndex = strfind(Timestamp,startTime{ii});
        endIndex = strfind(Timestamp,endTime{ii});
        startIndex = find(not(cellfun('isempty', startIndex)));
        endIndex = find(not(cellfun('isempty', endIndex)));
        
        t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
        
        %     dt = length(startIndex:endIndex);
        %     plotRange = linspace(0,1,dt);
        %     plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);
    end
    
    if all == 1 && summary == 0
        daydex = round(median(1:length(TotalField))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(TotalField)];
        
        subplot(7,1,6)
        plot(startIndex:endIndex,TotalField(startIndex:endIndex));hold on;ylim([0 250]);ylabel('Obs. B [nT]');grid minor
        set(gca, 'XTick',xaxis);%[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
%         set(gca, 'XTick',t);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if summary == 1 && ii == 1
        TotalField_summary = [];jump = 0;
        for jj = 1:length(eventTimes)
            TotalField_data = importdata(sprintf('./data_files/observed_mag_%s.txt',eventTimes{jj}(1:11)),' ',1);
            Timestamp = [strcat(TotalField_data.textdata(2:end,1),{' '},TotalField_data.textdata(2:end,2))];
            if length(TotalField_data.data(:,1)) ~= 20161
                jump = jump + 1;
                continue
            end
            TotalField_summary = [TotalField_summary; TotalField_data.data(:,1)];
        end
        
        errorIndex = find(TotalField_summary == -100000);
        TotalField_summary(errorIndex) = NaN;
        errorIndex = find(TotalField_summary > 250);
        TotalField_summary(errorIndex) = NaN;
        
        TotalFieldmatrix = reshape(TotalField_summary,[],length(eventTimes)-jump);
        TotalField_avg = nanmean(TotalFieldmatrix,2);
        
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        %             startIndexKP = 1; endIndexKP = 114;
        
        daydex = round(median(1:length(TotalField_avg))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(TotalField_avg)];
        
        subplot(7,1,6)
        plot(1:length(TotalField_avg),TotalField_avg);hold on;ylim([0 150]);ylabel('Obs. B [nT]');grid minor
        set(gca, 'XTick',xaxis);%[length(TotalField_avg)/15 length(TotalField_avg)*2/15 length(TotalField_avg)*3/15 length(TotalField_avg)*4/15 length(TotalField_avg)*5/15 length(TotalField_avg)*6/15 length(TotalField_avg)*7/15 length(TotalField_avg)*8/15 length(TotalField_avg)*9/15 length(TotalField_avg)*10/15 length(TotalField_avg)*11/15 length(TotalField_avg)*12/15 length(TotalField_avg)*13/15 length(TotalField_avg)*14/15 length(TotalField_avg)*15/15]);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if all == 0
        figure(ii)
        subplot(6,1,5)
        plot(Timestampnum,TotalField);hold on;ylabel('Obs. B [nT]');xlabel('Time [Days]');grid minor
%         set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
%         set(gca, 'XTick',[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
%% KP
    if data_download == 1% && ii ~= 5
        KPTime = eventTime(ii);
        KPRelative = ([7, 3, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
    
        KPBeforeTime = KPTime - KPRelative;
        KPAfterTime = KPTime + KPRelative;
    
        KPstartTime = datestr(KPBeforeTime, 'yyyy-mm-dd HH:MM:SS');
        KPendTime = datestr(KPAfterTime, 'yyyy-mm-dd HH:MM:SS');
        
        api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
        url = sprintf([api '?format=text&quantity=KP&resource=NOAA-KP&resourceInstance=NOAA-KP&end-time=%s&begin-time=%s'],KPendTime,KPstartTime);
        filename = sprintf('./data_files/KP_index_%s.txt',eventTimes{ii}(1:11));
        outfilename = websave(filename,url);
    end
    
    if all == 1 && ii == 1
        KPindex_all_data = [];
        for jj = 1:length(eventTimes)
            KP_data = importdata(sprintf('./data_files/KP_index_%s.txt',eventTimes{jj}(1:11)),' ',1);
            TimestampKP = [strcat(KP_data.textdata(2:end,1),{' '},KP_data.textdata(2:end,2))];
            if length(KP_data.data(:,1)) == 115
                KP_data.data(1,:) = [];
            end
            KPindex_all_data = [KPindex_all_data; KP_data.data(:,1)];
        end
        KPmatrix = reshape(KPindex_all_data,[],length(eventTimes));
        KP_avg = nanmean(KPmatrix,2);
        
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        startIndexKP = 1; endIndexKP = 114;
        
        daydex = round(median(1:length(KP_avg))/7);
        xaxis = [2 2+daydex 2+daydex*2 2+daydex*3 2+daydex*4 2+daydex*5 2+daydex*6 2+daydex*7 2+daydex*8 2+daydex*9 2+daydex*10 2+daydex*11 2+daydex*12 2+daydex*13 length(KP_avg)];
        
%         [tf, loc] = ismember(TimestampnumKP, Timestampnum);
%         KP_t_all = nan(size(Timestampnum));
%         KP_all = KP_t_all;
%         KP_t_all(loc(1:end-1)) = TimestampnumKP(1:end-1);
%         KP_all(loc) = KPindex_data;
    
        subplot(7,1,7)
%         plot(startIndexKP:endIndexKP,KPindex_data(startIndexKP:endIndexKP));ylim([0 9]);hold on;ylabel('KP Index');grid minor
%         KP = KPindex_data;
%         set(gca, 'XTick',[length(KP)/15 length(KP)*2/15 length(KP)*3/15 length(KP)*4/15 length(KP)*5/15 length(KP)*6/15 length(KP)*7/15 length(KP)*8/15 length(KP)*9/15 length(KP)*10/15 length(KP)*11/15 length(KP)*12/15 length(KP)*13/15 length(KP)*14/15 length(KP)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
%         set(gca, 'XTick',t);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        histCtrs = [1:114];%[t(1):(([0, 3, 0, 0] * [24*3600; 3600; 60; 1]) / 86400):t(end)];
        histData = KP_avg;%(startIndexKP:endIndexKP);
        [Xdata, Ydata] = stairs(histCtrs,histData);
        area(Xdata, Ydata);ylim([0 9]);hold on;ylabel('KP Index');grid minor
        
        KP = KP_data.data(:,1);
        set(gca, 'XTick',xaxis);%[length(KP)/15 length(KP)*2/15 length(KP)*3/15 length(KP)*4/15 length(KP)*5/15 length(KP)*6/15 length(KP)*7/15 length(KP)*8/15 length(KP)*9/15 length(KP)*10/15 length(KP)*11/15 length(KP)*12/15 length(KP)*13/15 length(KP)*14/15 length(KP)*15/15]);
%         set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if all == 0
    
        KP_data = importdata(sprintf('./data_files/KP_index_%s.txt',eventTimes{ii}(1:11)),' ',1);
        TimestampKP = [strcat(KP_data.textdata(2:end,1),{' '},KP_data.textdata(2:end,2))];
        KPindex_data = KP_data.data(:,1);
    
        TimestampnumKP = datenum(TimestampKP);
        [c startIndexKP] = min(abs(TimestampnumKP-datenum(startTime{ii})));
        [c endIndexKP] = min(abs(datenum(endTime{ii}) - TimestampnumKP));
    
%     dtKP = length(startIndexKP:endIndexKP);
%     plotRangeKP = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dtKP);
%     plotRangeKP = linspace(datenum(KPstartTime),datenum(KPendTime),dtKP);
    
%     t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];

        figure(ii) % startIndex:endIndex % TimestampnumKP
        subplot(6,1,6)
%         plot(TimestampnumKP,KPindex_data);hold on;ylabel('KP Index');ylim([0 10]);grid minor
        histCtrs = [t(1):(([0, 3, 0, 0] * [24*3600; 3600; 60; 1]) / 86400):t(end)];
        histData = KPindex_data(startIndexKP:endIndexKP);
        [Xdata, Ydata] = stairs(histCtrs,histData);
        area(Xdata, Ydata);ylim([0 9]);hold on;ylabel('KP Index');grid minor

%         set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
%         set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'dd- HH:MM'));
%         KP = KPindex_data;
%         set(gca, 'XTick',[length(KP)/15 length(KP)*2/15 length(KP)*3/15 length(KP)*4/15 length(KP)*5/15 length(KP)*6/15 length(KP)*7/15 length(KP)*8/15 length(KP)*9/15 length(KP)*10/15 length(KP)*11/15 length(KP)*12/15 length(KP)*13/15 length(KP)*14/15 length(KP)*15/15]);
%         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        set(gca, 'XTick',t);
        set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        set(gcf,'visible','off')
        
        saveFigure(gcf, sprintf('%s.png',old_eventTimes{ii}(1:10)));
        close all
%         print('-depsc2', 'test.eps')
%         print(gcf, '-dpdf', sprintf('%s.pdf',eventTimes{ii}(1:10)));
    end
end

if all == 1 && summary == 0
%     set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 30 20])
%     print('-depsc2', 'test.eps')
%     print(gcf, '-dpdf','all_events.pdf');
    saveFigure(gcf,'all_events.png');
end

if all == 1 && summary == 1
    saveFigure(gcf,'all_events_summary.png');
end