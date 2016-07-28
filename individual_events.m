clear all; close all; clear; clc;

filepath = 'RBE_times_revised.txt';
[old_startTime startTime old_eventTimes eventTimes eventTime endTime] = time_corrected_download(filepath,0,0);

days3_Bz = [];days3_Bt = [];days3_Bulk = [];days3_Pdyn = [];days3_B = [];days3_KP = [];
days2_Bz = [];days2_Bt = [];days2_Bulk = [];days2_Pdyn = [];days2_B = [];days2_KP = [];

daysP3_J08 = [];daysP3_J20 = [];daysM3_J08 = [];daysM3_J20 = [];
daysP2_J08 = [];daysP2_J20 = [];daysM2_J08 = [];daysM2_J20 = [];

% progressbar
for ii = 1:length(old_startTime)
    newSubFolder = sprintf([pwd '/indiv_events/%s'], old_eventTimes{ii}(1:10));
    if ~exist(newSubFolder, 'dir')
        mkdir(newSubFolder);
    end
    %% IMF Bz

    IMF_Bz_data = importdata(sprintf('./clean_data/IMF_Bz_%s.txt',eventTimes{ii}(1:11)),' ',1);
    
    Timestamp = [strcat(IMF_Bz_data.textdata(2:end,1),{' '},IMF_Bz_data.textdata(2:end,2))];
    %     Timestamp = cellfun(@(x) x(1:19), Timestamp, 'UniformOutput', false);
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
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
    t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
    
    days3_Bz = [days3_Bz; nanmean(Bz(5761:10081))];days2_Bz = [days2_Bz; nanmean(Bz(7201:10081))];
    
    figure(ii)
    ah1 = subplot(7,1,1);
    plot(Timestampnum,Bz);hold on;ylabel({'IMF B_{z}';'[nT]'});grid minor;
    xlim([Timestampnum(1) Timestampnum(end)]);
    title(sprintf('RBE Event Time: %s [+/- 7 days]',datestr(eventTime(ii))));
    set(gca,'XTick',t);
    set(gca,'XTickLabel','');%,{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    
    %% Total SW B Field
    
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
    
    %     if length(Timestamp) ~= 20161
    %         test = [];
    %         tnum = datenum(Timestamp);
    %         for oo = 1:length(Timestamp)-1
    %             test = [test; tnum(oo+1) - tnum(oo)];
    %         end
    %         idx = find(test == max(test));
    %
    %         Bt_one = Bt(1:idx+1); Bt_two = Bt(idx+2:end);
    %         %             Bt = ones(20161,1); Bt(1:17096) = Bt_one;
    %         Bt(end:end+(20161-length(Timestamp))) = NaN;Bt(idx+2:idx+2+(20161-length(Timestamp))) = NaN;
    %         Bt(length(Bt)-length(Bt_two)+1:length(Bt)) = Bt_two;
    %
    %         Timestamp_one = Timestampnum(1:idx+1); Timestamp_two = Timestampnum(idx+2:end);
    %         for jj = 1:(20161-length(Timestamp))
    %             Timestampnum(idx+jj) = Timestamp_one(end-1)+(0.003478*jj);
    %         end
    %         Timestampnum(length(Timestamp_one)+jj+1:20161) = Timestamp_two;
    %         Timestamp = cellstr(datestr(Timestampnum,'yyyy-mm-dd HH:MM:SS'));
    %     end
    
    errorIndex = find(Bt == -999.9);
    Bt(errorIndex) = NaN;
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
    t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
    
    days3_Bt = [days3_Bt; nanmean(Bt(5761:10081))];days2_Bt = [days2_Bt; nanmean(Bt(7201:10081))];
    
    figure(ii)
    ah2 = subplot(7,1,2);
    plot(Timestampnum,Bt);hold on;ylabel({'|B|_{SW}';'[nT]'});grid minor;
    xlim([Timestampnum(1) Timestampnum(end)]);
    set(gca,'XTick',t);
    set(gca,'XTickLabel','');
    
    %% Solar Wind BulkSpeed
    
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
    
    %     if length(Timestamp) ~= 20161
    %         test = [];
    %         tnum = datenum(Timestamp);
    %         for oo = 1:length(Timestamp)-1
    %             test = [test; tnum(oo+1) - tnum(oo)];
    %         end
    %         idx = find(test == max(test));
    %
    %         BulkSpeed_one = BulkSpeed(1:idx+1); BulkSpeed_two = BulkSpeed(idx+2:end);
    %         BulkSpeed(end:end+(20161-length(Timestamp))) = NaN;BulkSpeed(idx+2:idx+2+(20161-length(Timestamp))) = NaN;
    %         BulkSpeed(length(BulkSpeed)-length(BulkSpeed_two)+1:length(BulkSpeed)) = Bz_two;
    %
    %         Timestamp_one = Timestampnum(1:idx+1); Timestamp_two = Timestampnum(idx+2:end);
    %         for jj = 1:(20161-length(Timestamp))
    %             Timestampnum(idx+jj) = Timestamp_one(end-1)+(0.003478*jj);
    %         end
    %         Timestampnum(length(Timestamp_one)+jj+1:20161) = Timestamp_two;
    %         Timestamp = cellstr(datestr(Timestampnum,'yyyy-mm-dd HH:MM:SS'));
    %     end
    
    errorIndex = find(BulkSpeed == -9999.9);
    BulkSpeed(errorIndex) = NaN;
    BulkSpeed(find(BulkSpeed < 0)) = NaN;
    
    run('data_cleanup.m');
    
    Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
    t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    days3_Bulk = [days3_Bulk; nanmean(BulkSpeed(5761:10081))];days2_Bulk = [days2_Bulk; nanmean(BulkSpeed(7201:10081))];
    
    figure(ii)
    ah3 = subplot(7,1,3);
    plot(Timestampnum,BulkSpeed);hold on;ylabel({'SW Vel.';'[km/s]'});grid minor;
    xlim([Timestampnum(1) Timestampnum(end)]);ylim([min(BulkSpeed)-50 max(BulkSpeed)+50]);
    set(gca, 'XTick',t);
    set(gca, 'XTickLabel','');
    
    %% Dynamic Pressure
    
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
    
    %     if length(Timestamp) ~= 20161
    %         test = [];
    %         tnum = datenum(Timestamp);
    %         for oo = 1:length(Timestamp)-1
    %             test = [test; tnum(oo+1) - tnum(oo)];
    %         end
    %         idx = find(test == max(test));
    %
    %         ACE_protonD_one = ACE_protonD(1:idx+1); ACE_protonD_two = ACE_protonD(idx+2:end);
    %         ACE_protonD(end:end+(20161-length(Timestamp))) = NaN;
    %         ACE_protonD(idx+2:idx+2+(20161-length(Timestamp))) = NaN;
    %         ACE_protonD(length(ACE_protonD)-length(ACE_protonD_two)+1:length(ACE_protonD)) = ACE_protonD_two;
    %
    %         Timestamp_one = Timestampnum(1:idx+1); Timestamp_two = Timestampnum(idx+2:end);
    %         for jj = 1:(20161-length(Timestamp))
    %             Timestampnum(idx+jj) = Timestamp_one(end-1)+(0.003478*jj);
    %         end
    %         Timestampnum(length(Timestamp_one)+jj+1:20161) = Timestamp_two;
    %         Timestamp = cellstr(datestr(Timestampnum,'yyyy-mm-dd HH:MM:SS'));
    %     end
    
    errorIndex = find(ACE_protonD == -9999.9);
    ACE_protonD(errorIndex) = NaN;
    
    M_proton = 1.6726219*10^-27;
    Pdyn = ((ACE_protonD.*10^6) .* M_proton .* ((BulkSpeed.*1000).^2)).*10^9;
    
    Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
    t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    days3_Pdyn = [days3_Pdyn; nanmean(Pdyn(5761:10081))];days2_Pdyn = [days2_Pdyn; nanmean(Pdyn(7201:10081))];
    
    figure(ii)
    ah4 = subplot(7,1,4);
    plot(Timestampnum,Pdyn);hold on;ylabel({'P_{dyn}';'[nPa]'});grid minor;xlim([Timestampnum(1) Timestampnum(end)]);
    set(gca, 'XTick',t);
    set(gca, 'XTickLabel','');
    
    %% GOES e- flux (0.8 - 2 MeV)
    
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
    %         test = [];
    %         TimestampnumGOES = datenum(TimestampGOES);
    %         for oo = 1:length(TimestampGOES)-1
    %             test = [test; TimestampnumGOES(oo+1) - TimestampnumGOES(oo)];
    %         end
    %         idx = find(test == max(test));
    %
    %         bjj = 0;
    %         for kk = 1:length(idx)
    %             Timestamp_one = TimestampnumGOES(1:idx(kk)+bjj); Timestamp_two = TimestampnumGOES(idx(kk)+1+bjj:end);
    %             for jj = 1:(4033-length(TimestampGOES)+1)
    %                 Timestamp_one(end+1) = Timestamp_one    (0.003478*jj);
    %                 TimestampnumGOES(idx(kk)+jj) =
    %             end
    %             bjj = jj;
    %             TimestampnumGOES(length(Timestamp_one)+bjj+1:4033) = Timestamp_two;
    %         end
    %
    %         Timestamp = cellstr(datestr(TimestampnumGOES,'yyyy-mm-dd HH:MM:SS'));
    %     end
    %         for kk = 1:length(idx)
    %             E_flux_data_08_one = E_flux_data_08(1:idx(kk)); E_flux_data_08_two = E_flux_data_08(idx(kk)+1:end);
    %             E_flux_data_20_one = E_flux_data_20(1:idx(kk)); E_flux_data_20_two = E_flux_data_20(idx(kk)+1:end);
    %
    %             E_flux_data_08(end:end+(4033-length(TimestampGOES))) = NaN;E_flux_data_08(idx(kk)+1:idx(kk)+1+(4033-length(TimestampGOES))) = NaN;
    %             E_flux_data_08(length(E_flux_data_08)-length(E_flux_data_08_two)+1:length(E_flux_data_08)) = E_flux_data_08_two;
    %             E_flux_data_20(end:end+(4033-length(TimestampGOES))) = NaN;E_flux_data_20(idx(kk)+1:idx(kk)+1+(4033-length(TimestampGOES))) = NaN;
    %             E_flux_data_20(length(E_flux_data_20)-length(E_flux_data_20_two)+1:length(E_flux_data_20)) = E_flux_data_20_two;
    
    
    %     end
    
    errorIndex = find(E_flux_data_08 == -100000);E_flux_data_08(errorIndex) = NaN;
    errorIndex = find(E_flux_data_20 == -100000);E_flux_data_20(errorIndex) = NaN;
    
    E_flux_data_20(find(log(E_flux_data_20)<0)) = NaN;
    
    run('data_cleanup.m');
    
    Day = ([1, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;
    t = [median(TimestampnumGOES)-(7*Day) median(TimestampnumGOES)-(6*Day) median(TimestampnumGOES)-(5*Day) median(TimestampnumGOES)-(4*Day) median(TimestampnumGOES)-(3*Day) median(TimestampnumGOES)-(2*Day) median(TimestampnumGOES)-(Day) median(TimestampnumGOES) median(TimestampnumGOES)+(Day) median(TimestampnumGOES)+(2*Day) median(TimestampnumGOES)+(3*Day) median(TimestampnumGOES)+(4*Day) median(TimestampnumGOES)+(5*Day) median(TimestampnumGOES)+(6*Day) median(TimestampnumGOES)+(7*Day)];
    
    %         t = [1;289;577;865;1153;1441;1729;2017;2305;2593;2881;3169;]
    %         new = [1;289;577;865;1153;1441;1729;2017;2305;2593;2881;3169;3457;3745;4033];
    
    startIndex = strfind(TimestampGOES,startTime{ii});
    endIndex = strfind(TimestampGOES,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    
    daysM3_J08 = [daysM3_J08; nanmean(E_flux_data_08(1153:2017))];daysM2_J08 = [daysM2_J08; nanmean(E_flux_data_08(1441:2017))];
    daysM3_J20 = [daysM3_J20; nanmean(E_flux_data_20(1153:2017))];daysM2_J20 = [daysM2_J20; nanmean(E_flux_data_20(1441:2017))];
    daysP3_J08 = [daysP3_J08; nanmean(E_flux_data_08(2017:2881))];daysP2_J08 = [daysP2_J08; nanmean(E_flux_data_08(2017:2593))];%2017:2593
    daysP3_J20 = [daysP3_J20; nanmean(E_flux_data_20(2017:2881))];daysP2_J20 = [daysP2_J20; nanmean(E_flux_data_20(2017:2593))];%2017:2881
    
    figure(ii)
    ah5 = subplot(7,1,5);
    plot(TimestampnumGOES,log10(E_flux_data_08));hold on;ylim([-2 6]);ylabel('log(e- Flux)');grid minor
    plot(TimestampnumGOES,log10(E_flux_data_20));hold on;xlim([TimestampnumGOES(1) TimestampnumGOES(end)]);
    legend({'[0.8 MeV]','[2.0 MeV]'},'FontSize',8,'FontWeight','bold','Location','northwest');
    hline = refline([0 5]);
    set(hline,'LineStyle','--')
    legend boxoff
    set(gca, 'XTick',t);
    set(gca, 'XTickLabel','');
    
    %% GOES13 Observed B
    
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
    
    %     if length(Timestamp) ~= 20161
    %         test = [];
    %         tnum = datenum(Timestamp);
    %         for oo = 1:length(Timestamp)-1
    %             test = [test; tnum(oo+1) - tnum(oo)];
    %         end
    %         idx = find(test == max(test));
    %
    %         TotalField_one = TotalField(1:idx); TotalField_two = TotalField(idx+1:end);
    %         %             Bz = ones(20161,1); Bz(1:17096) = Bz_one;
    %         TotalField(end:end+(20161-length(Timestamp))) = NaN;
    %         TotalField(idx+2:idx+2+(20161-length(Timestamp))) = NaN;
    %         TotalField(length(TotalField)-length(TotalField_two)+1:length(TotalField)) = TotalField_two;
    %
    %         Timestamp_one = Timestampnum(1:idx); Timestamp_two = Timestampnum(idx+1:end);
    %         for jj = 1:(20161-length(Timestamp))
    %             Timestampnum(idx+jj) = Timestamp_one(end-1)+(0.003478*jj);
    %         end
    %         Timestampnum(length(Timestamp_one)+jj+1:20161) = Timestamp_two;
    %         Timestamp = cellstr(datestr(Timestampnum,'yyyy-mm-dd HH:MM:SS'));
    %     end
    
    errorIndex = find(TotalField == -100000);
    TotalField(errorIndex) = NaN;
    errorIndex = find(TotalField > 250);
    TotalField(errorIndex) = NaN;
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    t = [median(Timestampnum)-(7*Day) median(Timestampnum)-(6*Day) median(Timestampnum)-(5*Day) median(Timestampnum)-(4*Day) median(Timestampnum)-(3*Day) median(Timestampnum)-(2*Day) median(Timestampnum)-(Day) median(Timestampnum) median(Timestampnum)+(Day) median(Timestampnum)+(2*Day) median(Timestampnum)+(3*Day) median(Timestampnum)+(4*Day) median(Timestampnum)+(5*Day) median(Timestampnum)+(6*Day) median(Timestampnum)+(7*Day)];
    
    %     dt = length(startIndex:endIndex);
    %     plotRange = linspace(0,1,dt);
    %     plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);
    
    %         days3_Pdyn = [];days3_J08 = [];days3_J20 = [];days3_B = [];days3_KP = [];
    days3_B = [days3_B; nanmean(TotalField(5761:10081))];days2_B = [days2_B; nanmean(TotalField(7201:10081))];
    
    figure(ii)
    ah6 = subplot(7,1,6);
    plot(Timestampnum,TotalField);hold on;ylabel({'Obs. B';'[nT]'});ylim([min(TotalField)-20 max(TotalField)+20]);
    xlim([Timestampnum(1) Timestampnum(end)]);grid minor
    set(gca, 'XTick',t);
    set(gca, 'XTickLabel','');
    
    %% KP
    
    KP_data = importdata(sprintf('./clean_data/KP_index_%s.txt',eventTimes{ii}(1:11)),' ',1);
    TimestampKP = [strcat(KP_data.textdata(2:end,1),{' '},KP_data.textdata(2:end,2))];
    KPindex_data = KP_data.data(:,1);
    
    TimestampnumKP = datenum(TimestampKP);
    % [c startIndexKP] = min(abs(TimestampnumKP-datenum(startTime{ii})));
    % [c endIndexKP] = min(abs(datenum(endTime{ii}) - TimestampnumKP));
    
    % t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
    % t = [median(TimestampnumKP)-(7*Day) median(TimestampnumKP)-(6*Day) median(TimestampnumKP)-(5*Day) median(TimestampnumKP)-(4*Day) median(TimestampnumKP)-(3*Day) median(TimestampnumKP)-(2*Day) median(TimestampnumKP)-(Day) median(TimestampnumKP) median(TimestampnumKP)+(Day) median(TimestampnumKP)+(2*Day) median(TimestampnumKP)+(3*Day) median(TimestampnumKP)+(4*Day) median(TimestampnumKP)+(5*Day) median(TimestampnumKP)+(6*Day) median(TimestampnumKP)+(7*Day)];
    % t = [eventTime(ii)-(7*Day) eventTime(ii)-(6*Day) eventTime(ii)-(5*Day) eventTime(ii)-(4*Day) eventTime(ii)-(3*Day) eventTime(ii)-(2*Day) eventTime(ii)-(Day) eventTime(ii) eventTime(ii)+(Day) eventTime(ii)+(2*Day) eventTime(ii)+(3*Day) eventTime(ii)+(4*Day) eventTime(ii)+(5*Day) eventTime(ii)+(6*Day) eventTime(ii)+(7*Day)];
    startIndexKP = 1; endIndexKP = 114;
    
    days3_KP = [days3_KP; nanmean(KPindex_data(34:58))];days2_KP = [days2_KP; nanmean(KPindex_data(42:58))];
    
    figure(ii)
    ah7 = subplot(7,1,7);
    histCtrs = linspace(1,20161,114);%[1:114];%[t(1):(([0, 3, 0, 0] * [24*3600; 3600; 60; 1]) / 86400):t(end)];
    daydex = round(median(1:max(histCtrs))/7);
    xaxis = [2 2+daydex 2+daydex*2 2+daydex*3 2+daydex*4 2+daydex*5 2+daydex*6 2+daydex*7 2+daydex*8 2+daydex*9 2+daydex*10 2+daydex*11 2+daydex*12 2+daydex*13 max(histCtrs)];
    
    histData = KPindex_data(startIndexKP:endIndexKP);
    [Xdata, Ydata] = stairs(histCtrs,histData);
    area(Xdata, Ydata);xlim([0 20161]);hold on;ylabel('KP Index');grid minor;ylim([0 9]);
    % histCtrs = [t(1):(([0, 3, 0, 0] * [24*3600; 3600; 60; 1]) / 86400):t(end)];
    % histData = KPindex_data(startIndexKP:endIndexKP);
    % [Xdata, Ydata] = stairs(histCtrs,histData);
    % area(Xdata, Ydata);ylim([0 9]);xlim([0 20161]);hold on;ylabel('KP Index');xlabel('Time [Days]');grid minor
    set(gca, 'XTick',xaxis);
    set(gca, 'XTickLabel',{'-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7'});
    xlabel('Time [days]');
    
    set(gcf,'visible','off')
    
    %     pos7 = get(ah7,'Position');pos6 = get(ah6,'Position');pos5 = get(ah5,'Position');pos4 = get(ah4,'Position');pos3 = get(ah3,'Position');pos2 = get(ah2,'Position');pos1 = get(ah1,'Position');
    %     pos2(2) = pos1(2) - pos2(4);pos3(2) = pos2(2) - pos3(4);pos4(2) = pos3(2) - pos4(4);pos5(2) = pos4(2) - pos5(4);pos6(2) = pos5(2) - pos6(4);pos7(2) = pos6(2) - pos7(4);
    %     set(ah2,'Position',pos2);set(ah3,'Position',pos3);set(ah4,'Position',pos4);set(ah5,'Position',pos5);set(ah6,'Position',pos6);set(ah7,'Position',pos7);
    
    saveFigure(gcf, sprintf('./indiv_events/%s/%s_all.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    
    %% E- Flux Plots
    
    x = linspace(1,20161,4033);
    Flux_08 = NaN(20161,1);Flux_08(x) = E_flux_data_08;
    Flux_20 = NaN(20161,1);Flux_20(x) = E_flux_data_20;
    
    figure
    scatter(Bt,log10(Flux_08),5);ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'|B|_{SW}';'[nT]'});title('IMF Total B [nT] vs log(E- Flux) [0.8 MeV]');
    set(gcf,'visible','off')
    saveFigure(gcf, sprintf('./indiv_events/%s/%s_flux08_SWBtot.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    
    figure
    scatter(BulkSpeed,log10(Flux_08),5);ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'SW Vel.';'[km/s]'});title('SW Velocity [km/s] vs log(E- Flux) [0.8 MeV]');
    set(gcf,'visible','off')
    saveFigure(gcf, sprintf('./indiv_events/%s/%s_flux08_SWV.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    
    figure
    scatter(Pdyn,log10(Flux_08),5);ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'P_{dyn}';'[nPa]'});title('Dynamic Pressure [nPa] vs log(E- Flux) [0.8 MeV]');
    set(gcf,'visible','off')
    saveFigure(gcf, sprintf('./indiv_events/%s/%s_flux08_Pdyn.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    
    figure
    scatter(TotalField,log10(Flux_08),5);ylabel({'log(e- Flux)';'[0.8 MeV]'});xlabel({'Obs. B';'[nT]'});title('GOES Observed B [nT] vs log(E- Flux) [0.8 MeV]');
    set(gcf,'visible','off')
    saveFigure(gcf, sprintf('./indiv_events/%s/%s_flux08_ObsB.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    
    figure
    scatter(Bt,log10(Flux_20),5);ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'|B|_{SW}';'[nT]'});title('IMF Total B [nT] vs log(E- Flux) [2.0 MeV]');
    set(gcf,'visible','off')
    saveFigure(gcf, sprintf('./indiv_events/%s/%s_flux20_SWBtot.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    
    figure
    scatter(BulkSpeed,log10(Flux_20),5);ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'SW Vel.';'[km/s]'});title('SW Velocity [km/s] vs log(E- Flux) [2.0 MeV]');
    set(gcf,'visible','off')
    saveFigure(gcf, sprintf('./indiv_events/%s/%s_flux20_SWV.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    
    figure
    scatter(Pdyn,log10(Flux_20),5);ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'P_{dyn}';'[nPa]'});title('Dynamic Pressure [nPa] vs log(E- Flux) [2.0 MeV]');
    set(gcf,'visible','off')
    saveFigure(gcf, sprintf('./indiv_events/%s/%s_flux20_Pdyn.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    
    figure
    scatter(TotalField,log10(Flux_20),5);ylabel({'log(e- Flux)';'[2.0 MeV]'});xlabel({'Obs. B';'[nT]'});title('GOES Observed B [nT] vs log(E- Flux) [2.0 MeV]');
    set(gcf,'visible','off')
    saveFigure(gcf, sprintf('./indiv_events/%s/%s_flux20_ObsB.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    
    %% SW Peak plots
    [value index] = max(BulkSpeed);
    
    if index+1440 > length(BulkSpeed)
        figure
        plot(Timestampnum(index-1440:end),BulkSpeed(index-1440:end));xlabel('Time [HH:MM]');ylabel('SW Velocity [km/s]');title(sprintf('Max(BulkSpeed): %s [+/- 1 day]',datestr(Timestampnum(index))));grid minor
        xlim([Timestampnum(index-1440) Timestampnum(end)]);
        set(gca, 'xtick',Timestampnum(index-1440:360:end));
        set(gca, 'xticklabel',datestr(Timestampnum(index-1440:360:end),'HH:MM'));
        set(gcf,'visible','off')
        saveFigure(gcf, sprintf('./indiv_events/%s/%s_maxSWV_1day.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    elseif index+720 > length(BulkSpeed)
        figure
        plot(Timestampnum(index-720:end),BulkSpeed(index-720:end));xlabel('Time [HH:MM]');ylabel('SW Velocity [km/s]');title(sprintf('Max(BulkSpeed): %s [+/- 0.5 day]',datestr(Timestampnum(index))));grid minor
        xlim([Timestampnum(index-720) Timestampnum(end)]);
        set(gca, 'xtick',Timestampnum(index-720:180:end));
        set(gca, 'xticklabel',datestr(Timestampnum(index-720:180:end),'HH:MM'));
        set(gcf,'visible','off')
        saveFigure(gcf, sprintf('./indiv_events/%s/%s_maxSWV_halfday.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    elseif index+1440 < length(BulkSpeed)
        figure
        plot(Timestampnum(index-1440:index+1440),BulkSpeed(index-1440:index+1440));xlabel('Time [HH:MM]');ylabel('SW Velocity [km/s]');title(sprintf('Max(BulkSpeed): %s [+/- 1 day]',datestr(Timestampnum(index))));grid minor
        xlim([Timestampnum(index-1440) Timestampnum(index+1440)]);
        set(gca, 'xtick',Timestampnum(index-1440:360:index+1440));
        set(gca, 'xticklabel',datestr(Timestampnum(index-1440:360:index+1440),'HH:MM'));
        set(gcf,'visible','off')
        saveFigure(gcf, sprintf('./indiv_events/%s/%s_maxSWV_1day.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
        
        figure
        plot(Timestampnum(index-720:index+720),BulkSpeed(index-720:index+720));xlabel('Time [HH:MM]');ylabel('SW Velocity [km/s]');title(sprintf('Max(BulkSpeed): %s [+/- 0.5 day]',datestr(Timestampnum(index))));grid minor
        xlim([Timestampnum(index-720) Timestampnum(index+720)]);
        set(gca, 'xtick',Timestampnum(index-720:180:index+720));
        set(gca, 'xticklabel',datestr(Timestampnum(index-720:180:index+720),'HH:MM'));
        set(gcf,'visible','off')
        saveFigure(gcf, sprintf('./indiv_events/%s/%s_maxSWV_halfday.png',old_eventTimes{ii}(1:10),old_eventTimes{ii}(1:10)));
    end
    
%     progressbar(ii/length(old_eventTimes));
end
%% 3 Day Summary (Before)
days3_all = horzcat(days3_Bz,days3_Bt,days3_Bulk,days3_Pdyn,daysM3_J08,daysM3_J20,days3_B,days3_KP);

filename_out = '3day_all_event_summaries.txt';%sprintf([path_to_output_files '%s_%s_supermag_MLT.txt'],startTime(1:10),endTime(1:10));
fid_out = fopen(filename_out,'w');

fprintf(fid_out,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','Timestamp','IMF Bz','SW B Total','BulkSpeed','Dynamic Pressure','Eflux [0.8 MeV]','Eflux [2.0 MeV]','Observed B','KP Index');
for kk = 1:size(days3_all,1)
    fprintf(fid_out,'%s\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t\n',eventTimes{kk},days3_all(kk,:));
end
fclose(fid_out);

%% 2 Day Summary (Before)
days2_all = horzcat(days2_Bz,days2_Bt,days2_Bulk,days2_Pdyn,daysM2_J08,daysM2_J20,days2_B,days2_KP);

filename_out = '2day_all_event_summaries.txt';%sprintf([path_to_output_files '%s_%s_supermag_MLT.txt'],startTime(1:10),endTime(1:10));
fid_out = fopen(filename_out,'w');

fprintf(fid_out,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','Timestamp','IMF Bz','SW B Total','BulkSpeed','Dynamic Pressure','Eflux [0.8 MeV]','Eflux [2.0 MeV]','Observed B','KP Index');
for kk = 1:size(days2_all,1)
    fprintf(fid_out,'%s\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t\n',eventTimes{kk},days3_all(kk,:));
end
fclose(fid_out);

%% GOES e- Flux Summary [0.8 MeV]

GOES_all_08 = horzcat(daysM3_J08,daysM2_J08,daysP2_J08,daysP3_J08);
% GOES_all = vertcat(GOES_all_08,GOES_all_20);

filename_out = 'GOES_08_event_summaries.txt';%sprintf([path_to_output_files '%s_%s_supermag_MLT.txt'],startTime(1:10),endTime(1:10));
fid_out = fopen(filename_out,'w');

fprintf(fid_out,'%s\t%s\t%s\t%s\t%s\n','Timestamp','Minus 3','Minus 2','Plus 2','Plus 3');
for kk = 1:size(GOES_all_08,1)
    fprintf(fid_out,'%s\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t\n',eventTimes{kk},GOES_all_08(kk,:));
end
fclose(fid_out);

%% GOES e- Flux Summary [2.0 MeV]

GOES_all_20 = horzcat(daysM3_J20,daysM2_J20,daysP2_J20,daysP3_J20);

filename_out = 'GOES_20_event_summaries.txt';%sprintf([path_to_output_files '%s_%s_supermag_MLT.txt'],startTime(1:10),endTime(1:10));
fid_out = fopen(filename_out,'w');

fprintf(fid_out,'%s\t%s\t%s\t%s\t%s\n','Timestamp','Minus 3','Minus 2','Plus 2','Plus 3');
for kk = 1:size(GOES_all_20,1)
    fprintf(fid_out,'%s\t%10.5f\t%10.5f\t%10.5f\t%10.5f\t\n',eventTimes{kk},GOES_all_20(kk,:));
end
fclose(fid_out);