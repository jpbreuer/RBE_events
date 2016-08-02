clear all; close all; clc;

Eflux08 = importdata('./GOES_08_event_summaries.txt','\t',1); E08_P3 = Eflux08.data(:,4);E08_P2 = Eflux08.data(:,3);
Eflux20 = importdata('./GOES_20_event_summaries.txt','\t',1); E20_P3 = Eflux08.data(:,4);E20_P2 = Eflux08.data(:,3);

%% Minus 3
all_M3 = importdata('./M3day_all_event_summaries.txt','\t',1);

IMFBz_M3 = all_M3.data(:,1);
IMFBt_M3 = all_M3.data(:,2);
SWV_M3 = all_M3.data(:,3);
Pdyn_M3 = all_M3.data(:,4);
ObsB_M3 = all_M3.data(:,7);

figure
scatter(IMFBz_M3,log10(E08_P3));xlabel({'IMF B_z [nT]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3BzE08.png');

figure
scatter(IMFBt_M3,log10(E08_P3));xlabel({'|B|_{SW} [nT]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3BtE08.png');

figure
scatter(SWV_M3,log10(E08_P3));xlabel({'SW Vel. [km/s]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3SWVE08.png');

figure
scatter(Pdyn_M3,log10(E08_P3));xlabel({'P_{dyn} [nPa]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3PdynE08.png');

figure
scatter(ObsB_M3,log10(E08_P3));xlabel({'Obs. B [nT]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3ObsBE08.png');

figure
scatter(IMFBz_M3,log10(E20_P3));xlabel({'IMF B_z [nT]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3BzE20.png');

figure
scatter(IMFBt_M3,log10(E20_P3));xlabel({'|B|_{SW} [nT]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3BtE20.png');

figure
scatter(SWV_M3,log10(E20_P3));xlabel({'SW Vel. [km/s]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3SWVE20.png');

figure
scatter(Pdyn_M3,log10(E20_P3));xlabel({'P_{dyn} [nPa]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3PdynE20.png');

figure
scatter(ObsB_M3,log10(E20_P3));xlabel({'Obs. B [nT]';'-3 day avg.'});ylabel({'+3 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_3ObsBE20.png');

%% Minus 2
all_M2 = importdata('./M2day_all_event_summaries.txt','\t',1);

IMFBz_M2 = all_M2.data(:,1);
IMFBt_M2 = all_M2.data(:,2);
SWV_M2 = all_M2.data(:,3);
Pdyn_M2 = all_M2.data(:,4);
ObsB_M2 = all_M2.data(:,7);

figure
scatter(IMFBz_M2,log10(E08_P2));xlabel({'IMF B_z [nT]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2BzE08.png');

figure
scatter(IMFBt_M2,log10(E08_P2));xlabel({'|B|_{SW} [nT]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2BtE08.png');

figure
scatter(SWV_M2,log10(E08_P2));xlabel({'SW Vel. [km/s]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2SWVE08.png');

figure
scatter(Pdyn_M2,log10(E08_P2));xlabel({'P_{dyn} [nPa]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2PdynE08.png');

figure
scatter(ObsB_M2,log10(E08_P2));xlabel({'Obs. B [nT]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [0.8 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2ObsBE08.png');

figure
scatter(IMFBz_M2,log10(E20_P2));xlabel({'IMF B_z [nT]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2BzE20.png');

figure
scatter(IMFBt_M2,log10(E20_P2));xlabel({'|B|_{SW} [nT]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2BtE20.png');

figure
scatter(SWV_M2,log10(E20_P2));xlabel({'SW Vel. [km/s]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2SWVE20.png');

figure
scatter(Pdyn_M2,log10(E20_P2));xlabel({'P_{dyn} [nPa]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2PdynE20.png');

figure
scatter(ObsB_M2,log10(E20_P2));xlabel({'Obs. B [nT]';'-2 day avg.'});ylabel({'+2 day avg.';'log(E- flux) [2.0 MeV]'});title('Event Averaged Points');
saveFigure(gcf, './summary_events/perevent_2ObsBE20.png');