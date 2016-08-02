clear all; close all; clear; clc;

mil_10_data = importdata('./rad_dosages/0010mil/GOES-y2012.txt',' ',3);
mil_30_data = importdata('./rad_dosages/0030mil/GOES-y2012.txt',' ',3);
mil_60_data = importdata('./rad_dosages/0060mil/GOES-y2012.txt',' ',3);
mil_100_data = importdata('./rad_dosages/0100mil/GOES-y2012.txt',' ',3);
mil_200_data = importdata('./rad_dosages/0200mil/GOES-y2012.txt',' ',3);
mil_300_data = importdata('./rad_dosages/0300mil/GOES-y2012.txt',' ',3);
mil_500_data = importdata('./rad_dosages/0500mil/GOES-y2012.txt',' ',3);
mil_700_data = importdata('./rad_dosages/0700mil/GOES-y2012.txt',' ',3);
mil_1000_data = importdata('./rad_dosages/1000mil/GOES-y2012.txt',' ',3);


Timestamp = [strcat(mil_10_data.textdata(4:end,1),{' '},mil_10_data.textdata(4:end,2))];
Timestamp = cellstr(datestr(Timestamp,'yyyy-mm-dd HH:MM:SS'));
Timestampnum = datenum(Timestamp);

milxx_none = mil_10_data.data(:,1) .* 300; % 300 because of 5 minute time cadence and unit of radSi/s
mil10_data = mil_10_data.data(:,2) .* 300;
mil30_data = mil_30_data.data(:,2) .* 300;
mil60_data = mil_60_data.data(:,2) .* 300;
mil100_data = mil_100_data.data(:,2) .* 300;
mil200_data = mil_200_data.data(:,2) .* 300;
mil300_data = mil_300_data.data(:,2) .* 300;
mil500_data = mil_500_data.data(:,2) .* 300;
mil700_data = mil_700_data.data(:,2) .* 300;
mil1000_data = mil_1000_data.data(:,2) .* 300;

figure
plot(Timestampnum,log10(milxx_none));hold on;
plot(Timestampnum,log10(mil10_data));
plot(Timestampnum,log10(mil30_data));
plot(Timestampnum,log10(mil60_data));
plot(Timestampnum,log10(mil100_data));
plot(Timestampnum,log10(mil200_data));
plot(Timestampnum,log10(mil300_data));
plot(Timestampnum,log10(mil500_data));
plot(Timestampnum,log10(mil700_data));
plot(Timestampnum,log10(mil1000_data));
[legh,objh,outh,outm] = legend({'None','10mil','30mil','60mil','100mil','200mil','300mil','500mil','700mil','1000mil'},'FontSize',8,'FontWeight','bold','Location','eastoutside');
set(objh,'linewidth',2);
set(gca,'Xtick',[Timestampnum(1) Timestampnum(8638) Timestampnum(16985) Timestampnum(25911) Timestampnum(34550) Timestampnum(43478) Timestampnum(52118) Timestampnum(61046) Timestampnum(69971) Timestampnum(78608) Timestampnum(87534) Timestampnum(96172)]);
set(gca,'Xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});
xlabel('Time 2012 [Months]');ylabel('log(Dosage) [RadSi]');title('Radiation Dosage for 2012 over Various Shielding Thicknesses');
xlim([Timestampnum(1) Timestampnum(end)]);ylim([-5 3]);
saveFigure(gcf, './rad_dosages/radsi_full.png');

figure
plot(Timestampnum,log10(cumsum(milxx_none)),'linewidth',1.2);hold on;
plot(Timestampnum,log10(cumsum(mil10_data)),'linewidth',1.2);
plot(Timestampnum,log10(cumsum(mil30_data)),'linewidth',1.2);
plot(Timestampnum,log10(cumsum(mil60_data)),'linewidth',1.2);
plot(Timestampnum,log10(cumsum(mil100_data)),'linewidth',1.2);
plot(Timestampnum,log10(cumsum(mil200_data)),'linewidth',1.2);
plot(Timestampnum,log10(cumsum(mil300_data)),'linewidth',1.2);
plot(Timestampnum,log10(cumsum(mil500_data)),'linewidth',1.2);
plot(Timestampnum,log10(cumsum(mil700_data)),'linewidth',1.2);
plot(Timestampnum,log10(cumsum(mil1000_data)),'linewidth',1.2);
[legh,objh,outh,outm] = legend({'None','10mil','30mil','60mil','100mil','200mil','300mil','500mil','700mil','1000mil'},'FontSize',8,'FontWeight','bold','Location','eastoutside');
set(objh,'linewidth',2);
set(gca,'Xtick',[Timestampnum(1) Timestampnum(8638) Timestampnum(16985) Timestampnum(25911) Timestampnum(34550) Timestampnum(43478) Timestampnum(52118) Timestampnum(61046) Timestampnum(69971) Timestampnum(78608) Timestampnum(87534) Timestampnum(96172)]);
set(gca,'Xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});
xlabel('Time 2012 [Months]');ylabel('log(Dosage) [RadSi]');title('Cumulative Radiation Dosage for 2012 over Various Shielding Thicknesses');
% xlim([ Timestampnum(end)]);
ylim([-5 5.5]);
saveFigure(gcf, './rad_dosages/radsi_commulative.png');