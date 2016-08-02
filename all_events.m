clear all; close all; clear; clc;

summary = 1;
otherplots = 1;day7 = 1;day3 = 1;

filepath = 'RBE_times_revised.txt';
[old_startTime startTime old_eventTimes eventTimes eventTime endTime] = time_corrected_download(filepath,0,0);

Bz_summary = [];Bt_summary = [];BulkSpeed_summary = [];Pdyn_summary = [];
E_flux_data_08_summary = []; E_flux_data_20_summary = [];TotalField_summary = [];KPindex_all_data = [];

for ii = 1:length(old_eventTimes)
    %% IMF BZ
    IMF_Bz_data = importdata(sprintf('./clean_data/IMF_Bz_%s.txt',eventTimes{ii}(1:11)),' ',1);
    
    Timestamp = [strcat(IMF_Bz_data.textdata(2:end,1),{' '},IMF_Bz_data.textdata(2:end,2))];
    Timestamp = cellfun(@(x) x(1:19), Timestamp, 'UniformOutput', false);
    Timestamp = cellstr(datestr(Timestamp,'yyyy-mm-dd HH:MM:SS'));
    
    Bz = IMF_Bz_data.data(:,1);
    
    if length(Timestamp) ~= 20161
        interval = 1/(60*24);
        TimestampNew = cellstr(datestr(datenum(startTime{ii}):interval:datenum(endTime{ii}),'yyyy-mm-dd HH:MM:SS'));
        
        [logical, idx] = ismember(Timestamp,TimestampNew);
        
        Timestamp = TimestampNew;
        Bz_new = NaN(20161,1);Bz_new(idx) = Bz;Bz = Bz_new;
    end
    
    Timestampnum = datenum(Timestamp);
    
    errorIndex = find(Bz == -999.9);
    Bz(errorIndex) = NaN;
    
    Bz_summary = [Bz_summary; Bz];
    
    if summary == 0
        daydex = round(median(1:length(Bz))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Bz)];
        x = linspace(1,20161,20161);
        
        figure(1)
        subplot(8,1,1);
        plot(x,Bz);hold on;ylim([-30 35]);xlim([0 20161]);ylabel({'IMF Bz';'[nT]'});grid minor
        title('RBE Events [+/- 7 days]');
        set(gca, 'XTick',xaxis);%[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    if summary == 1 && ii == length(old_eventTimes)
        
        Bzmatrix = reshape(Bz_summary,[],length(eventTimes));
        Bz_avg = nanmean(Bzmatrix,2);
        
        Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        startIndexKP = 1; endIndexKP = 114;
        
        daydex = round(median(1:length(Bz_avg))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Bz_avg)];
        
        x = linspace(1,20161,20161);
        
        ah1 = subplot(8,1,1);
        plot(x,Bz_avg);hold on;ylabel({'IMF Bz';'[nT]'});grid minor; ;ylim([-4, 4]);xlim([0 20161]);
        title('RBE Events Averaged [+/- 7 days]');
        set(gca, 'XTick',xaxis);%[length(Bz_avg)/15 length(Bz_avg)*2/15 length(Bz_avg)*3/15 length(Bz_avg)*4/15 length(Bz_avg)*5/15 length(Bz_avg)*6/15 length(Bz_avg)*7/15 length(Bz_avg)*8/15 length(Bz_avg)*9/15 length(Bz_avg)*10/15 length(Bz_avg)*11/15 length(Bz_avg)*12/15 length(Bz_avg)*13/15 length(Bz_avg)*14/15 length(Bz_avg)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    %% IMF B Total
    
    IMF_Bt_data = importdata(sprintf('./clean_data/IMF_BTotal_%s.txt',eventTimes{ii}(1:11)),' ',1);
    
    Timestamp = [strcat(IMF_Bt_data.textdata(2:end,1),{' '},IMF_Bt_data.textdata(2:end,2))];
    Timestamp = cellstr(datestr(Timestamp,'yyyy-mm-dd HH:MM:SS'));%Timestamp = cellfun(@(x) x(1:19), Timestamp, 'UniformOutput', false);
    
    Bt = IMF_Bt_data.data(:,1);
    
    if length(Timestamp) ~= 20161
        interval = 1/(60*24);
        TimestampNew = cellstr(datestr(datenum(startTime{ii}):interval:datenum(endTime{ii}),'yyyy-mm-dd HH:MM:SS'));
        
        [logical, idx] = ismember(Timestamp,TimestampNew);Timestamp = TimestampNew;
        Bt_new = NaN(20161,1);Bt_new(idx) = Bt;Bt = Bt_new;
    end
    
    Timestampnum = datenum(Timestamp);
    
    errorIndex = find(Bt == -999.9);
    Bt(errorIndex) = NaN;
    
    Bt_summary = [Bt_summary; Bt];
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    if summary == 0
        daydex = round(median(1:length(Bt))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Bt)];
        x = linspace(1,20161,20161);
        
        
        subplot(8,1,2);
        plot(x,Bt);hold on;ylim([0 35]);xlim([0 20161]);ylabel({'IMF Bt';'[nT]'});grid minor
        set(gca, 'XTick',xaxis);%[length(Bt)/15 length(Bt)*2/15 length(Bt)*3/15 length(Bt)*4/15 length(Bt)*5/15 length(Bt)*6/15 length(Bt)*7/15 length(Bt)*8/15 length(Bt)*9/15 length(Bt)*10/15 length(Bt)*11/15 length(Bt)*12/15 length(Bt)*13/15 length(Bt)*14/15 length(Bt)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        %             set(h, 'XTick',t);
        %             set(h, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    
    if summary == 1 && ii == length(old_eventTimes)
        
        Btmatrix = reshape(Bt_summary,[],length(eventTimes));%-jump
        Bt_avg = nanmean(Btmatrix,2);
        
        Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        startIndexKP = 1; endIndexKP = 114;
        
        daydex = round(median(1:length(Bt_avg))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Bt_avg)];
        
        x = linspace(1,20161,20161);
        
        ah2 = subplot(8,1,2);
        plot(x,Bt_avg);hold on;ylabel({'IMF Bt';'[nT]'});grid minor;xlim([0 20161]);%ylim([-4, 4]);
        set(gca, 'XTick',xaxis);%[length(Bt_avg)/15 length(Bt_avg)*2/15 length(Bt_avg)*3/15 length(Bt_avg)*4/15 length(Bt_avg)*5/15 length(Bt_avg)*6/15 length(Bt_avg)*7/15 length(Bt_avg)*8/15 length(Bt_avg)*9/15 length(Bt_avg)*10/15 length(Bt_avg)*11/15 length(Bt_avg)*12/15 length(Bt_avg)*13/15 length(Bt_avg)*14/15 length(Bt_avg)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    %%    SW BulkSpeed
    
    BulkSpeed_data = importdata(sprintf('./clean_data/SW_BulkSpeed_%s.txt',eventTimes{ii}(1:11)),' ',1);
    
    Timestamp = [strcat(BulkSpeed_data.textdata(2:end,1),{' '},BulkSpeed_data.textdata(2:end,2))];
    Timestamp = cellstr(datestr(Timestamp,'yyyy-mm-dd HH:MM:SS'));%Timestamp = cellfun(@(x) x(1:19), Timestamp, 'UniformOutput', false);
    
    BulkSpeed = BulkSpeed_data.data(:,1);
    
    if length(Timestamp) ~= 20161
        interval = 1/(60*24);
        TimestampNew = cellstr(datestr(datenum(startTime{ii}):interval:datenum(endTime{ii}),'yyyy-mm-dd HH:MM:SS'));
        
        [logical, idx] = ismember(Timestamp,TimestampNew);Timestamp = TimestampNew;
        BulkSpeed_new = NaN(20161,1);BulkSpeed_new(idx) = BulkSpeed;BulkSpeed = BulkSpeed_new;
    end
    
    Timestampnum = datenum(Timestamp);
    
    errorIndex = find(BulkSpeed == -9999.9);
    BulkSpeed(errorIndex) = NaN;
    BulkSpeed(find(BulkSpeed < 0)) = NaN;
    
    run('data_cleanup.m');
    
    BulkSpeed_summary = [BulkSpeed_summary; BulkSpeed];
    
    if summary == 0
        
        daydex = round(median(1:length(BulkSpeed))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(BulkSpeed)];
        x = linspace(1,20161,20161);
        
        
        subplot(8,1,3)
        plot(x,BulkSpeed);hold on;ylim([200 1100]);xlim([0 20161]);ylabel({'SW Vel.';'[km/s]'});grid minor
        set(gca, 'XTick',xaxis);%[length(BulkSpeed)/15 length(BulkSpeed)*2/15 length(BulkSpeed)*3/15 length(BulkSpeed)*4/15 length(BulkSpeed)*5/15 length(BulkSpeed)*6/15 length(BulkSpeed)*7/15 length(BulkSpeed)*8/15 length(BulkSpeed)*9/15 length(BulkSpeed)*10/15 length(BulkSpeed)*11/15 length(BulkSpeed)*12/15 length(BulkSpeed)*13/15 length(BulkSpeed)*14/15 length(BulkSpeed)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        %         set(gca, 'XTick',t);
        %         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
    end
    
    if summary == 1 && ii == length(old_eventTimes)
        
        BulkSpeedmatrix = reshape(BulkSpeed_summary,[],length(eventTimes));
        BulkSpeed_avg = nanmean(BulkSpeedmatrix,2);
        
        t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
        startIndexKP = 1; endIndexKP = 114;
        
        daydex = round(median(1:length(BulkSpeed_avg))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(BulkSpeed_avg)];
        
        ah3 = subplot(8,1,3);
        plot(x,BulkSpeed_avg);hold on;ylabel({'SW Vel.';'[km/s]'});grid minor;ylim([200 750]);xlim([0 20161]);
        set(gca, 'XTick',xaxis);%[length(BulkSpeed)/15 length(BulkSpeed)*2/15 length(BulkSpeed)*3/15 length(BulkSpeed)*4/15 length(BulkSpeed)*5/15 length(BulkSpeed)*6/15 length(BulkSpeed)*7/15 length(BulkSpeed)*8/15 length(BulkSpeed)*9/15 length(BulkSpeed)*10/15 length(BulkSpeed)*11/15 length(BulkSpeed)*12/15 length(BulkSpeed)*13/15 length(BulkSpeed)*14/15 length(BulkSpeed)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    %%    Dynamic Pressure
    
    ACE_protonData = importdata(sprintf('./clean_data/ACE_protonD_%s.txt',eventTimes{ii}(1:11)),' ',1);
    Timestamp = [strcat(ACE_protonData.textdata(2:end,1),{' '},ACE_protonData.textdata(2:end,2))];
    Timestamp = cellstr(datestr(Timestamp,'yyyy-mm-dd HH:MM:SS'));%Timestamp = cellfun(@(x) x(1:19), Timestamp, 'UniformOutput', false);
    
    ACE_protonD = ACE_protonData.data(:,1);
    
    if length(Timestamp) ~= 20161
        interval = 1/(60*24);
        TimestampNew = cellstr(datestr(datenum(startTime{ii}):interval:datenum(endTime{ii}),'yyyy-mm-dd HH:MM:SS'));
        
        [logical, idx] = ismember(Timestamp,TimestampNew);Timestamp = TimestampNew;
        ACE_protonD_new = NaN(20161,1);ACE_protonD_new(idx) = ACE_protonD;ACE_protonD = ACE_protonD_new;
    end
    
    Timestampnum = datenum(Timestamp);
    
    errorIndex = find(ACE_protonD == -9999.9);
    ACE_protonD(errorIndex) = NaN;
    
    M_proton = 1.6726219*10^-27;
    Pdyn = ((ACE_protonD.*10^6) .* M_proton .* ((BulkSpeed.*1000).^2)).*10^9;
    
    Pdyn_summary = [Pdyn_summary; Pdyn];
    
    if summary == 0
        daydex = round(median(1:length(Pdyn))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Pdyn)];
        x = linspace(1,20161,20161);
        
        
        subplot(8,1,4)
        plot(x,Pdyn);hold on;ylim([0 15]);xlim([0 20161]);ylabel({'Pdyn';'[nPa]'});grid minor
        set(gca, 'XTick',xaxis);%[length(Pdyn)/15 length(Pdyn)*2/15 length(Pdyn)*3/15 length(Pdyn)*4/15 length(Pdyn)*5/15 length(Pdyn)*6/15 length(Pdyn)*7/15 length(Pdyn)*8/15 length(Pdyn)*9/15 length(Pdyn)*10/15 length(Pdyn)*11/15 length(Pdyn)*12/15 length(Pdyn)*13/15 length(Pdyn)*14/15 length(Pdyn)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        %         set(gca, 'XTick',t);
        %         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
    end
    
    if summary == 1 && ii == length(old_eventTimes)
        
        Pdyn_matrix = reshape(Pdyn_summary,[],length(eventTimes));
        Pdyn_avg = nanmean(Pdyn_matrix,2);
        
        daydex = round(median(1:length(Pdyn))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(Pdyn)];
        
        ah4 = subplot(8,1,4);
        plot(x,Pdyn_avg);hold on;ylabel({'Pdyn';'[nPa]'});grid minor; ;xlim([0 20161]);%ylim([0 5]);
        set(gca, 'XTick',xaxis);%[length(Pdyn)/15 length(Pdyn)*2/15 length(Pdyn)*3/15 length(Pdyn)*4/15 length(Pdyn)*5/15 length(Pdyn)*6/15 length(Pdyn)*7/15 length(Pdyn)*8/15 length(Pdyn)*9/15 length(Pdyn)*10/15 length(Pdyn)*11/15 length(Pdyn)*12/15 length(Pdyn)*13/15 length(Pdyn)*14/15 length(Pdyn)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    %%    GOES e- flux (0.8 - 2 MeV)
    
    E_flux_data = importdata(sprintf('./clean_data/GOES_e-_flux_%s.txt',eventTimes{ii}(1:11)),' ',1);
    
    TimestampGOES = [strcat(E_flux_data.textdata(2:end,1),{' '},E_flux_data.textdata(2:end,2))];
    TimestampGOES = cellstr(datestr(TimestampGOES,'yyyy-mm-dd HH:MM:SS'));
    E_flux_data_08 = E_flux_data.data(:,1);E_flux_data_20 = E_flux_data.data(:,2);
    
    if length(TimestampGOES) ~= 4033
        interval = 5/(60*24);
        TimestampNew = cellstr(datestr(datenum(startTime{ii}):interval:datenum(endTime{ii}),'yyyy-mm-dd HH:MM:SS'));
        
        [logical, idx] = ismember(TimestampGOES,TimestampNew);TimestampGOES = TimestampNew;
        Flux_08 = NaN(4033,1);Flux_08(idx) = E_flux_data_08;E_flux_data_08 = Flux_08;
        Flux_20 = NaN(4033,1);Flux_20(idx) = E_flux_data_20;E_flux_data_20 = Flux_20;
    end
    
    TimestampnumGOES = datenum(TimestampGOES);
    
    errorIndex = find(E_flux_data_08 == -100000);E_flux_data_08(errorIndex) = NaN;
    errorIndex = find(E_flux_data_20 == -100000);E_flux_data_20(errorIndex) = NaN;
    
    E_flux_data_20(find(log(E_flux_data_20)<0)) = NaN;
    
    run('data_cleanup.m');
    
    
    E_flux_data_08_summary = [E_flux_data_08_summary; E_flux_data_08];
    E_flux_data_20_summary = [E_flux_data_20_summary; E_flux_data_20];
    
    if summary == 0
        x = linspace(1,20161,4033);
        daydex = round(median(1:max(x)/7));
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 max(x)];
        
        
        ah5 = subplot(8,1,5);
        plot(x,log10(E_flux_data_08));hold on;ylim([-2 6]);xlim([0 20161]);grid minor;%ylabel('log(e- Flux) [0.8 MeV]');grid minor
        hline = refline([0 5]);
        set(hline,'LineStyle','--')
        set(gca, 'XTick',xaxis);%[length(E_flux_data_08)/15 length(E_flux_data_08)*2/15 length(E_flux_data_08)*3/15 length(E_flux_data_08)*4/15 length(E_flux_data_08)*5/15 length(E_flux_data_08)*6/15 length(E_flux_data_08)*7/15 length(E_flux_data_08)*8/15 length(E_flux_data_08)*9/15 length(E_flux_data_08)*10/15 length(E_flux_data_08)*11/15 length(E_flux_data_08)*12/15 length(E_flux_data_08)*13/15 length(E_flux_data_08)*14/15 length(E_flux_data_08)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        %         set(gca, 'XTick',t);
        %         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        
        ah6 = subplot(8,1,6); % startIndex:endIndex instead of plotRange; E_flux_data_20(startIndex:endIndex)
        plot(x,log10(E_flux_data_20));hold on;ylim([-2 6]);xlim([0 20161]);grid minor;%ylabel('log(e- Flux) [2.0 MeV]');grid minor
        hline = refline([0 5]);
        set(hline,'LineStyle','--')
        set(gca, 'XTick',xaxis);%[length(E_flux_data_20)/15 length(E_flux_data_20)*2/15 length(E_flux_data_20)*3/15 length(E_flux_data_20)*4/15 length(E_flux_data_20)*5/15 length(E_flux_data_20)*6/15 length(E_flux_data_20)*7/15 length(E_flux_data_20)*8/15 length(E_flux_data_20)*9/15 length(E_flux_data_20)*10/15 length(E_flux_data_20)*11/15 length(E_flux_data_20)*12/15 length(E_flux_data_20)*13/15 length(E_flux_data_20)*14/15 length(E_flux_data_20)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        %         set(gca, 'XTick',t);
        %         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        p1=get(ah5,'position');
        p2=get(ah6,'position');
        height=p1(2)+p1(4)-p2(2);
        h3=axes('position',[p2(1) p2(2) p2(3) height],'visible','off');
        h_label=ylabel({'log(e- Flux)';'[2.0 MeV]        [0.8 MeV]'},'visible','on');
        
    end
    
    if summary == 1 && ii == length(old_eventTimes)
        
        Flux08matrix = reshape(E_flux_data_08_summary,[],length(eventTimes));
        Flux08_avg = nanmean(log10(Flux08matrix),2);
        
        Flux20matrix = reshape(E_flux_data_20_summary,[],length(eventTimes));
        Flux20_avg = nanmean(log10(Flux20matrix),2);
        
        
        x = linspace(1,20161,4033);
        daydex = round(median(1:max(x))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 max(x)];
        
        ah5 = subplot(8,1,5);
        
        plot(x,Flux08_avg);hold on;grid minor; ;ylim([-2 6]);xlim([0 20161]);%ylabel('log(e- Flux) [0.8 MeV]');
        hline = refline([0 5]);
        set(hline,'LineStyle','--')
        %         set(gca, 'XTick',[length(Flux08_avg)/15 length(Flux08_avg)*2/15 length(Flux08_avg)*3/15 length(Flux08_avg)*4/15 length(Flux08_avg)*5/15 length(Flux08_avg)*6/15 length(Flux08_avg)*7/15 length(Flux08_avg)*8/15 length(Flux08_avg)*9/15 length(Flux08_avg)*10/15 length(Flux08_avg)*11/15 length(Flux08_avg)*12/15 length(Flux08_avg)*13/15 length(Flux08_avg)*14/15 length(Flux08_avg)*15/15]);
        set(gca, 'XTick',xaxis);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        ah6 = subplot(8,1,6);
        plot(x,Flux20_avg);hold on;grid minor; ;ylim([-2 6]);xlim([0 20161]);%ylabel('log(e- Flux) [2.0 MeV]');
        hline = refline([0 5]);
        set(hline,'LineStyle','--')
        %         set(gca, 'XTick',[length(Flux20_avg)/15 length(Flux20_avg)*2/15 length(Flux20_avg)*3/15 length(Flux20_avg)*4/15 length(Flux20_avg)*5/15 length(Flux20_avg)*6/15 length(Flux20_avg)*7/15 length(Flux20_avg)*8/15 length(Flux20_avg)*9/15 length(Flux20_avg)*10/15 length(Flux20_avg)*11/15 length(Flux20_avg)*12/15 length(Flux20_avg)*13/15 length(Flux20_avg)*14/15 length(Flux20_avg)*15/15]);
        %         set(gca, 'XTick',[1 288 576 864 1152 1440 1728 2016 2304 2592 2880 3168 3456 3744 4031]);
        set(gca, 'XTick',xaxis);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
        p1=get(ah5,'position');
        p2=get(ah6,'position');
        height=p1(2)+p1(4)-p2(2);
        h3=axes('position',[p2(1) p2(2) p2(3) height],'visible','off');
        h_label=ylabel({'log(e- Flux)';'[2.0 MeV]        [0.8 MeV]'},'visible','on');
    end
    
    %% GOES13 Total B
    
    TotalB_data = importdata(sprintf('./clean_data/observed_mag_%s.txt',eventTimes{ii}(1:11)),' ',1);
    
    Timestamp = [strcat(TotalB_data.textdata(2:end,1),{' '},TotalB_data.textdata(2:end,2))];
    Timestamp = cellstr(datestr(Timestamp,'yyyy-mm-dd HH:MM:SS'));
    
    Hp = TotalB_data.data(:,1);He = TotalB_data.data(:,2);Hn = TotalB_data.data(:,3);
    TotalField = TotalB_data.data(:,4);
    
    if length(Timestamp) ~= 20161
        interval = 1/(60*24);
        TimestampNew = cellstr(datestr(datenum(startTime{ii}):interval:datenum(endTime{ii}),'yyyy-mm-dd HH:MM:SS'));
        
        [logical, idx] = ismember(Timestamp,TimestampNew);Timestamp = TimestampNew;
        TotalField_new = NaN(20161,1);TotalField_new(idx) = TotalField;TotalField = TotalField_new;
    end
    
    Timestampnum = datenum(Timestamp);
    
    errorIndex = find(TotalField == -100000);
    TotalField(errorIndex) = NaN;
    errorIndex = find(TotalField > 250);
    TotalField(errorIndex) = NaN;
    
    TotalField_summary = [TotalField_summary; TotalField];
    
    if summary == 0
        daydex = round(median(1:length(TotalField))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 length(TotalField)];
        x = linspace(1,20161,20161);
        
        
        subplot(8,1,7)
        plot(x,TotalField);hold on;ylim([0 250]);ylabel({'Obs. B';'[nT]'});xlim([0 20161]);grid minor
        set(gca, 'XTick',xaxis);%[length(Bz)/15 length(Bz)*2/15 length(Bz)*3/15 length(Bz)*4/15 length(Bz)*5/15 length(Bz)*6/15 length(Bz)*7/15 length(Bz)*8/15 length(Bz)*9/15 length(Bz)*10/15 length(Bz)*11/15 length(Bz)*12/15 length(Bz)*13/15 length(Bz)*14/15 length(Bz)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        %         set(gca, 'XTick',t);
        %         set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
        
    end
    
    if summary == 1 && ii == length(old_eventTimes)
        TotalFieldmatrix = reshape(TotalField_summary,[],length(eventTimes));
        TotalField_avg = nanmean(TotalFieldmatrix,2);
        
        x = linspace(1,20161,20161);
        daydex = round(median(1:max(x))/7);
        xaxis = [1 daydex daydex*2 daydex*3 daydex*4 daydex*5 daydex*6 daydex*7 daydex*8 daydex*9 daydex*10 daydex*11 daydex*12 daydex*13 max(x)];
        
        ah7 = subplot(8,1,7);
        plot(x,TotalField_avg);hold on;ylabel({'Obs. B';'[nT]'});grid minor;ylim([50 130]);xlim([0 20161]);
        set(gca, 'XTick',xaxis);%[length(TotalField_avg)/15 length(TotalField_avg)*2/15 length(TotalField_avg)*3/15 length(TotalField_avg)*4/15 length(TotalField_avg)*5/15 length(TotalField_avg)*6/15 length(TotalField_avg)*7/15 length(TotalField_avg)*8/15 length(TotalField_avg)*9/15 length(TotalField_avg)*10/15 length(TotalField_avg)*11/15 length(TotalField_avg)*12/15 length(TotalField_avg)*13/15 length(TotalField_avg)*14/15 length(TotalField_avg)*15/15]);
        set(gca, 'XTickLabel','');%{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    end
    
    %% KP
    
    if ii == 1
        for jj = 1:length(old_eventTimes)
            KP_data = importdata(sprintf('./clean_data/KP_index_%s.txt',eventTimes{jj}(1:11)),' ',1);
            TimestampKP = [strcat(KP_data.textdata(2:end,1),{' '},KP_data.textdata(2:end,2))];
            if length(KP_data.data(:,1)) == 115
                KP_data.data(1,:) = [];
            end
            KPindex_all_data = [KPindex_all_data; KP_data.data(:,1)];
        end
        
        KPmatrix = reshape(KPindex_all_data,[],length(eventTimes));
        KP_avg = nanmean(KPmatrix,2);
    end
    %         x = linspace(1,114,20161);
    
    %         [tf, loc] = ismember(TimestampnumKP, Timestampnum);
    %         KP_t_all = nan(size(Timestampnum));
    %         KP_all = KP_t_all;
    %         KP_t_all(loc(1:end-1)) = TimestampnumKP(1:end-1);
    %         KP_all(loc) = KPindex_data;
    
    ah8 = subplot(8,1,8);
    histCtrs = linspace(1,20161,114);%[1:114];%[t(1):(([0, 3, 0, 0] * [24*3600; 3600; 60; 1]) / 86400):t(end)];
    daydex = round(median(1:max(histCtrs))/7);
    xaxis = [2 2+daydex 2+daydex*2 2+daydex*3 2+daydex*4 2+daydex*5 2+daydex*6 2+daydex*7 2+daydex*8 2+daydex*9 2+daydex*10 2+daydex*11 2+daydex*12 2+daydex*13 max(histCtrs)];
    
    histData = KP_avg;%(startIndexKP:endIndexKP);
    [Xdata, Ydata] = stairs(histCtrs,histData);
    area(Xdata, Ydata);xlim([0 20161]);hold on;ylabel('KP Index');grid minor;ylim([0 5]);
    
    %         KP = KP_data.data(:,1); ;
    set(gca, 'XTick',xaxis);%[length(KP)/15 length(KP)*2/15 length(KP)*3/15 length(KP)*4/15 length(KP)*5/15 length(KP)*6/15 length(KP)*7/15 length(KP)*8/15 length(KP)*9/15 length(KP)*10/15 length(KP)*11/15 length(KP)*12/15 length(KP)*13/15 length(KP)*14/15 length(KP)*15/15]);
    set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    xlabel('Time [days]');
    
    if summary == 0
        set(gcf,'visible','off')
        saveFigure(gcf,'./summary_events/all_events_everything.png');
    end
    if summary == 1
        set(gcf,'visible','off')
        saveFigure(gcf,'./summary_events/all_events_summary.png');
    end
    
    
    %% Other Plots
    if otherplots == 1
        if summary == 0
            %% E- Flux Plots
            
            if day3 == 1
                x = linspace(1,8641,1729);
                Flux_08 = NaN(8641,1);Flux_08(x) = E_flux_data_08(1153:2881);
                Flux_20 = NaN(8641,1);Flux_20(x) = E_flux_data_20(1153:2881);
                
                figure(2)
                scatter(Bt(5761:14401),log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'|B|_{SW}';'[nT]'});title('IMF Total B [nT] vs log(E- Flux) [0.8 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all3day_flux08_SWBtot.png');
                
                figure(3)
                scatter(BulkSpeed(5761:14401),log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'SW Vel.';'[km/s]'});title('SW Velocity [km/s] vs log(E- Flux) [0.8 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all3day_flux08_SWV.png');
                
                figure(4)
                scatter(Pdyn(5761:14401),log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'P_{dyn}';'[nPa]'});title('Dynamic Pressure [nPa] vs log(E- Flux) [0.8 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all3day_flux08_Pdyn.png');
                
                figure(5)
                scatter(TotalField(5761:14401),log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'Obs. B';'[nT]'});title('GOES Observed B [nT] vs log(E- Flux) [0.8 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all3day_flux08_ObsB.png');
                
                figure(6)
                scatter(Bt(5761:14401),log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'|B|_{SW}';'[nT]'});title('IMF Total B [nT] vs log(E- Flux) [2.0 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all3day_flux20_SWBtot.png');
                
                figure(7)
                scatter(BulkSpeed(5761:14401),log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'SW Vel.';'[km/s]'});title('SW Velocity [km/s] vs log(E- Flux) [2.0 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all3day_flux20_SWV.png');
                
                figure(8)
                scatter(Pdyn(5761:14401),log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'P_{dyn}';'[nPa]'});title('Dynamic Pressure [nPa] vs log(E- Flux) [2.0 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all3day_flux20_Pdyn.png');
                
                figure(9)
                scatter(TotalField(5761:14401),log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'Obs. B';'[nT]'});title('GOES Observed B [nT] vs log(E- Flux) [2.0 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all3day_flux20_ObsB.png');
            end
            if day7 == 1
                x = linspace(1,20161,4033);
                Flux_08 = NaN(20161,1);Flux_08(x) = E_flux_data_08;
                Flux_20 = NaN(20161,1);Flux_20(x) = E_flux_data_20;
                
                figure(2)
                scatter(Bt,log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'|B|_{SW}';'[nT]'});title('IMF Total B [nT] vs log(E- Flux) [0.8 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all7day_flux08_SWBtot.png');
                
                figure(3)
                scatter(BulkSpeed,log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'SW Vel.';'[km/s]'});title('SW Velocity [km/s] vs log(E- Flux) [0.8 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all7day_flux08_SWV.png');
                
                figure(4)
                scatter(Pdyn,log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'P_{dyn}';'[nPa]'});title('Dynamic Pressure [nPa] vs log(E- Flux) [0.8 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all7day_flux08_Pdyn.png');
                
                figure(5)
                scatter(TotalField,log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'Obs. B';'[nT]'});title('GOES Observed B [nT] vs log(E- Flux) [0.8 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all7day_flux08_ObsB.png');
                
                figure(6)
                scatter(Bt,log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'|B|_{SW}';'[nT]'});title('IMF Total B [nT] vs log(E- Flux) [2.0 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all7day_flux20_SWBtot.png');
                
                figure(7)
                scatter(BulkSpeed,log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'SW Vel.';'[km/s]'});title('SW Velocity [km/s] vs log(E- Flux) [2.0 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all7day_flux20_SWV.png');
                
                figure(8)
                scatter(Pdyn,log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'P_{dyn}';'[nPa]'});title('Dynamic Pressure [nPa] vs log(E- Flux) [2.0 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all7day_flux20_Pdyn.png');
                
                figure(9)
                scatter(TotalField,log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'Obs. B';'[nT]'});title('GOES Observed B [nT] vs log(E- Flux) [2.0 MeV]');
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all7day_flux20_ObsB.png');
            end
            %% SW Peak plots
            [value index] = max(BulkSpeed);
            xday = linspace(1,2881,2881);
            xhalf = linspace(1,1441,1441);
            
            if index+1440 < length(BulkSpeed)
                figure(10)
                plot(xday,BulkSpeed(index-1440:index+1440));hold on;xlabel('Peak Time [+/- days]');ylabel('SW Velocity [km/s]');title('Max(BulkSpeed) [+/- 1 day]');grid minor
                xlim([1 2880]);
                set(gca, 'xtick',[1,1440,2880]);
                set(gca, 'xticklabel',{'-1','0','1'});
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all_maxSWV_1day.png');
                
                figure(11)
                plot(xhalf,BulkSpeed(index-720:index+720));hold on;xlabel('Peak Time [+/- days]');ylabel('SW Velocity [km/s]');title('Max(BulkSpeed) [+/- 0.5 day]');grid minor
                xlim([1 1440]);
                set(gca, 'xtick',[1,720,1440]);
                set(gca, 'xticklabel',{'-0.5','0','0.5'});%datestr(Timestampnum(index-720:180:index+720),'HH:MM'));
                set(gcf,'visible','off')
                saveFigure(gcf, './summary_events/all_maxSWV_halfday.png');
            end
        end
    end
end
if otherplots == 1
    if summary == 1
        
        x = linspace(1,20161,4033);
        Flux_08 = NaN(20161,1);Flux_08(x) = Flux08_avg;
        Flux_20 = NaN(20161,1);Flux_20(x) = Flux20_avg;
        
        figure(2)
        scatter(Bt_avg,log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'|B|_{SW}';'[nT]'});title('AVG: IMF Total B [nT] vs log(E- Flux) [0.8 MeV]');
        set(gcf,'visible','off')
        saveFigure(gcf, './summary_events/averaged_flux08_SWBtot.png');
        
        figure(3)
        scatter(BulkSpeed_avg,log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'SW Vel.';'[km/s]'});title('AVG: SW Velocity [km/s] vs log(E- Flux) [0.8 MeV]');
        set(gcf,'visible','off')
        saveFigure(gcf, './summary_events/averaged_flux08_SWV.png');
        
        figure(4)
        scatter(Pdyn_avg,log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'P_{dyn}';'[nPa]'});title('AVG: Dynamic Pressure [nPa] vs log(E- Flux) [0.8 MeV]');
        set(gcf,'visible','off')
        saveFigure(gcf, './summary_events/averaged_flux08_Pdyn.png');
        
        figure(5)
        scatter(TotalField_avg,log10(Flux_08),5);hold on;ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'Obs. B';'[nT]'});title('AVG: GOES Observed B [nT] vs log(E- Flux) [0.8 MeV]');
        set(gcf,'visible','off')
        saveFigure(gcf, './summary_events/averaged_flux08_ObsB.png');
        
        figure(6)
        scatter(Bt_avg,log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'|B|_{SW}';'[nT]'});title('AVG: IMF Total B [nT] vs log(E- Flux) [2.0 MeV]');
        set(gcf,'visible','off')
        saveFigure(gcf, './summary_events/averaged_flux20_SWBtot.png');
        
        figure(7)
        scatter(BulkSpeed_avg,log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'SW Vel.';'[km/s]'});title('AVG: SW Velocity [km/s] vs log(E- Flux) [2.0 MeV]');
        set(gcf,'visible','off')
        saveFigure(gcf, './summary_events/averaged_flux20_SWV.png');
        
        figure(8)
        scatter(Pdyn_avg,log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'P_{dyn}';'[nPa]'});title('AVG: Dynamic Pressure [nPa] vs log(E- Flux) [2.0 MeV]');
        set(gcf,'visible','off')
        saveFigure(gcf, './summary_events/averaged_flux20_Pdyn.png');
        
        figure(9)
        scatter(TotalField_avg,log10(Flux_20),5);hold on;ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'Obs. B';'[nT]'});title('AVG: GOES Observed B [nT] vs log(E- Flux) [2.0 MeV]');
        set(gcf,'visible','off')
        saveFigure(gcf, './summary_events/averaged_flux20_ObsB.png');
        
        %% SW Peak plots
        [value index] = max(BulkSpeed_avg);
        x = linspace(1,20161,20161);
        %
        % %         if index+1440 > length(BulkSpeed_avg)
        % %             figure(10)
        % %             plot(x(index-1440:end),BulkSpeed_avg(index-1440:end));hold on;xlabel('Time [days]');ylabel('SW Velocity [km/s]');title(sprintf('AVG: Max(BulkSpeed): %s [+/- 1 day]',datestr(Timestampnum(index))));grid minor
        % %             xlim([x(index-1440) x(end)]);
        % %             set(gca, 'xtick',[index-1440,index,length(BulkSpeed_avg)]);
        % %             val = length(BulkSpeed_avg)-index/1440;
        % %             set(gca, 'xticklabel',{'-1','0',char(val)});
        % %             set(gcf,'visible','off')
        % %             saveFigure(gcf, './summary_events/averaged_maxSWV_1day.png');
        % %         elseif index+720 > length(BulkSpeed)
        % %             figure(11)
        % %             plot(x(index-720:end),BulkSpeed_avg(index-720:end));hold on;xlabel('Time [days]');ylabel('SW Velocity [km/s]');title(sprintf('AVG: Max(BulkSpeed): %s [+/- 0.5 day]',datestr(Timestampnum(index))));grid minor
        % %             xlim([Timestampnum(index-720) Timestampnum(end)]);
        % %             set(gca, 'xtick',[index-1440,index,length(BulkSpeed_avg)]);
        % %             val = length(BulkSpeed_avg)-index/1440;
        % %             set(gca, 'xticklabel',{'-1','0',char(val)});
        % %             set(gcf,'visible','off')
        % %             saveFigure(gcf, './summary_events/averaged_maxSWV_halfday.png');
        if index+1440 < length(BulkSpeed_avg)
            figure(10)
            plot(x(index-1440:index+1440),BulkSpeed_avg(index-1440:index+1440));hold on;xlabel('Time [days]');ylabel('SW Velocity [km/s]');title(sprintf('AVG: Max(BulkSpeed): %s [+/- 1 day]',datestr(Timestampnum(index))));grid minor
            xlim([index-1440 index+1440]);
            set(gca, 'xtick',[index-1440,index,length(BulkSpeed_avg)]);
            set(gca, 'xticklabel',{'-1','0','1'});
            set(gcf,'visible','off')
            saveFigure(gcf, './summary_events/averaged_maxSWV_1day.png');
            
            figure(11)
            plot(x(index-720:index+720),BulkSpeed_avg(index-720:index+720));hold on;xlabel('Time [days]');ylabel('SW Velocity [km/s]');title(sprintf('AVG: Max(BulkSpeed): %s [+/- 0.5 day]',datestr(Timestampnum(index))));grid minor
            xlim([index-720 index+720]);
            set(gca, 'xtick',[index-720,index,index+720]);
            set(gca, 'xticklabel',{'-0.5','0','0.5'});
            set(gcf,'visible','off')
            saveFigure(gcf, './summary_events/averaged_maxSWV_halfday.png');
        end
    end
end